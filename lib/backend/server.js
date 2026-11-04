require('dotenv').config();
const express = require('express');
const cors = require('cors');
const multer = require('multer');
const Stripe = require('stripe');
const paypal = require('@paypal/checkout-server-sdk');
const axios = require('axios'); // أضفنا مكتبة axios عشان نكلم بيها تليجرام

const app = express();
app.use(cors({ origin: true }));
app.use(express.json()); // لدعم قراءة الـ JSON لو لزم الأمر

// ------------------- إعدادات تليجرام بوت -------------------
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN;
const TELEGRAM_CHAT_ID = process.env.TELEGRAM_CHAT_ID;

// دالة إرسال الإشعار لتليجرام
async function sendTelegramNotification(email, paymentMethod, paymentStatus, surveyData, fileName) {
    if (!TELEGRAM_BOT_TOKEN) return; // عشان ميديورش خطأ لو لسه محطتش التوكن

    try {
        let detailsText = '';
        for (const [key, value] of Object.entries(surveyData)) {
            detailsText += `- *${key}*: ${value}\n`;
        }

        const message = `
🚨 *تسجيل طلب جديد وتحويل دفع* 🇬🇧
📧 *البريد الإلكتروني:* ${email}
💳 *وسيلة الدفع:* ${paymentMethod.toUpperCase()}
📌 *حالة الدفع:* ${paymentStatus}
📎 *المرفق:* ${fileName}

📝 *بيانات النموذج:*
${detailsText || 'لا توجد تفاصيل إضافية'}
        `;

        await axios.post(`https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`, {
            chat_id: TELEGRAM_CHAT_ID,
            text: message,
            parse_mode: 'Markdown',
        });
    } catch (err) {
        console.error('Telegram Error:', err.message);
    }
}

// ------------------- 1. إعدادات Stripe -------------------
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

// ------------------- 2. إعدادات PayPal -------------------
const PAYPAL_CLIENT_ID = process.env.PAYPAL_CLIENT_ID || 'YOUR_PAYPAL_CLIENT_ID';
const PAYPAL_CLIENT_SECRET = process.env.PAYPAL_CLIENT_SECRET || 'YOUR_PAYPAL_CLIENT_SECRET';

const environment = new paypal.core.SandboxEnvironment(PAYPAL_CLIENT_ID, PAYPAL_CLIENT_SECRET);
const paypalClient = new paypal.core.PayPalHttpClient(environment);

// إعداد التخزين المؤقت للملفات
const upload = multer({ storage: multer.memoryStorage() });

// ------------------- 3. Endpoint استقبال الطلب والدفع -------------------
app.post('/api/submit-form-and-pay', upload.single('document'), async (req, res) => {
    try {
        const { email, payment_method } = req.body;
        const uploadedFile = req.file;

        if (!email) {
            return res.status(400).json({ error: 'البريد الإلكتروني مطلوب' });
        }

        if (uploadedFile) {
            console.log(`تم استلام ملف: ${uploadedFile.originalname} بحجم ${uploadedFile.size} بايت`);
        }

        // تجميع كل بيانات الأسئلة الديناميكية المبعوثة في req.body
        const surveyData = { ...req.body };
        delete surveyData.email;
        delete surveyData.payment_method;

        const fileName = uploadedFile ? uploadedFile.originalname : 'لا يوجد ملف مرفق';

        // ------------------ خيار 1: الدفع بـ PayPal ------------------
        if (payment_method === 'paypal') {
            const request = new paypal.orders.OrdersCreateRequest();
            request.prefer("return=representation");
            request.requestBody({
                intent: 'CAPTURE',
                purchase_units: [{
                    amount: {
                        currency_code: 'USD',
                        value: '50.00'
                    },
                    description: `Humanitarian Relocation Registration - ${email}`
                }],
                application_context: {
                    return_url: 'https://yourdomain.com/success',
                    cancel_url: 'https://yourdomain.com/cancel',
                }
            });

            const order = await paypalClient.execute(request);
            const approveUrl = order.result.links.find(link => link.rel === 'approve').href;

            // إرسال تنبيه لتليجرام أن العميل بدأ عملية الدفع بـ PayPal
            await sendTelegramNotification(email, 'paypal', 'جاري تحويل العميل لدفع 50$', surveyData, fileName);

            return res.json({ url: approveUrl });
        }

        // ------------------ خيار 2: الدفع بـ Stripe (الافتراضي) ------------------
        else {
            const session = await stripe.checkout.sessions.create({
                payment_method_types: ['card'],
                customer_email: email,
                line_items: [
                    {
                        price: 'price_1UPo0BL8Y2plkg68il4XD3sV',
                        quantity: 1,
                    },
                ],
                mode: 'subscription',
                success_url: 'https://yourdomain.com/success',
                cancel_url: 'https://yourdomain.com/cancel',
                metadata: {
                    userEmail: email,
                    fileName: fileName,
                },
            });

            // إرسال تنبيه لتليجرام أن العميل دخل بوابة Stripe
            await sendTelegramNotification(email, 'stripe', 'جاري تحويل العميل لبوابة بطاقة الائتمان', surveyData, fileName);

            return res.json({ url: session.url });
        }

    } catch (error) {
        console.error('Payment Error:', error);
        res.status(500).json({ error: error.message });
    }
});

const PORT = process.env.PORT;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));