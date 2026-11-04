import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/survey_step_model.dart';
import '../controllers/survey_controller.dart';

class CheckoutStepWidget extends StatelessWidget {
  final SurveyStepModel step;
  final SurveyController controller;
  final VoidCallback onPickDocument;
  final Function(String paymentMethod) onSubmitAndPay;
  final VoidCallback onBackPressed;
  final bool isArabic;

  const CheckoutStepWidget({
    super.key,
    required this.step,
    required this.controller,
    required this.onPickDocument,
    required this.onSubmitAndPay,
    required this.onBackPressed,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Text(
            isArabic ? step.titleAr : step.titleEn,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D253F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'الرجاء إدخال البريد الإلكتروني، رفع المستند المطلوبة، ثم اختيار وسيلة الدفع لإتمام الطلب.'
                : 'Please enter your email, upload the required document, and choose a payment method.',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // حقل البريد الإلكتروني
          const Text(
            'البريد الإلكتروني للإيصال والمتابعة / Email for Receipt',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'example@domain.com',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 24),

          // قسم رفع المستندات
          const Text(
            'المستندات المطلوبة (PDF, PNG, JPG)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: onPickDocument,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple.withOpacity(0.4), width: 1.5),
                borderRadius: BorderRadius.circular(12),
                color: Colors.deepPurple.withOpacity(0.03),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_upload_outlined, color: Colors.deepPurple, size: 28),
                  const SizedBox(height: 12, width: 12),
                  Expanded(
                    child: Text(
                      controller.pickedFile != null
                          ? controller.pickedFile!.name
                          : (isArabic ? 'اضغط هنا لرفع الملف الشخصي أو جواز السفر' : 'Click here to upload document'),
                      style: TextStyle(
                        color: controller.pickedFile != null ? Colors.black87 : Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (controller.pickedFile != null)
                    const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // خيارات الدفع (Stripe & PayPal)
          const Text(
            'اختر بوابة الدفع الآمنة / Select Payment Gateway',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D253F)),
          ),
          const SizedBox(height: 16),

          // زر الدفع بواسطة Stripe
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: controller.isLoading ? null : () => onSubmitAndPay('stripe'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF635BFF), // لون Stripe الرسمي
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              icon: const Icon(Icons.credit_card, color: Colors.white),
              label: controller.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      isArabic ? 'الدفع بواسطة بطاقة الائتمان (Stripe)' : 'Pay with Stripe',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 14),

          // زر الدفع بواسطة PayPal
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: controller.isLoading ? null : () => onSubmitAndPay('paypal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003087), // لون PayPal الرسمي
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              icon: const Icon(Icons.payment, color: Colors.white), // أو أيقونة باي بال لو متوفرة
              label: controller.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      isArabic ? 'الدفع بواسطة حساب PayPal' : 'Pay with PayPal',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 30),

          // أزرار التنقل (رجوع)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OutlinedButton.icon(
                onPressed: onBackPressed,
                icon: const Icon(Icons.arrow_back, size: 16),
                label: Text(isArabic ? 'السابق' : 'Previous'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}