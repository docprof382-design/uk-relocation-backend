import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

import 'frontend/models/survey_step_model.dart';
import 'frontend/controllers/survey_controller.dart';
import 'frontend/screens/section_step_widget.dart';
import 'frontend/screens/checkout_step_widget.dart';
import 'frontend/screens/splash_screen.dart';
import 'frontend/screens/home_page.dart'; // تأكد من مسار الـ HomePage
import 'routes/app_routes.dart';

void main() {
  runApp(const MultiStepLandingApp());
}

class MultiStepLandingApp extends StatelessWidget {
  const MultiStepLandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Form Landing Page',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home, // يبدأ من الهوم بيج
      onGenerateRoute: AppRoutes.generateRoute, // نظام الروتس المنظم
    );
  }
}

class FormFlowScreen extends StatefulWidget {
  const FormFlowScreen({super.key});

  @override
  State<FormFlowScreen> createState() => _FormFlowScreenState();
}

class _FormFlowScreenState extends State<FormFlowScreen> {
  final SurveyController _controller = SurveyController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        _controller.pickedFile = result.files.first;
      });
    }
  }

  Future<void> _submitDataAndPay(String paymentMethod) async {
    final email = _controller.emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال بريد إلكتروني صحيح')),
      );
      return;
    }

    setState(() => _controller.isLoading = true);

    try {
      const backendUrl = 'http://localhost:3000/api/submit-form-and-pay';
      var request = http.MultipartRequest('POST', Uri.parse(backendUrl));

      request.fields['email'] = email;
      request.fields['payment_method'] = paymentMethod;

      _controller.textControllers.forEach((questionId, textController) {
        request.fields['question_$questionId'] = textController.text.trim();
      });

      _controller.selectedOptions.forEach((questionId, optionVal) {
        request.fields['question_$questionId'] = optionVal;
      });

      if (_controller.pickedFile != null && kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'document',
            _controller.pickedFile!.bytes!,
            filename: _controller.pickedFile!.name,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final checkoutUrl = data['url'];

        if (kIsWeb) {
          web.window.location.href = checkoutUrl;
        } else {
          final uri = Uri.parse(checkoutUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      } else {
        throw Exception('خطأ من السيرفر: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    } finally {
      setState(() => _controller.isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = View.of(context).platformDispatcher.locale.languageCode == 'ar';
    final totalSections = SectionModel.sections.length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isArabic
                  ? 'نموذج التسجيل لبرنامج الانتقال الانساني الى المملكة المتحده 🇬🇧 (${_controller.currentIndex + 1} من $totalSections)'
                  : 'UK Humanitarian Relocation Registration 🇬🇧 (${_controller.currentIndex + 1} of $totalSections)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              isArabic
                  ? 'يهدف هذا النموذج لجمع معلومات الأفراد والعائلات الراغبين في التسجيل.'
                  : 'This form aims to collect info from individuals/families wishing to register.',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        controller: _controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _controller.currentIndex = index;
          });
        },
        itemCount: totalSections,
        itemBuilder: (context, index) {
          final section = SectionModel.sections[index];

          if (index < totalSections - 1) {
            return SectionStepWidget(
              section: section,
              controller: _controller,
              onStateUpdate: () => setState(() {}),
              onNextPressed: _controller.nextPage,
              onBackPressed: index > 0 ? _controller.previousPage : null,
              isArabic: isArabic,
            );
          }

          return CheckoutStepWidget(
            step: SurveyStepModel(
              id: section.id.toString(),
              titleAr: section.sectionTitleAr,
              titleEn: section.sectionTitleEn,
              type: StepType.checkout,
            ),
            controller: _controller,
            onPickDocument: _pickDocument,
            onSubmitAndPay: _submitDataAndPay,
            onBackPressed: _controller.previousPage,
            isArabic: isArabic,
          );
        },
      ),
    );
  }
}