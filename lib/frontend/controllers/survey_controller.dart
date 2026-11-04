import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SurveyController {
  final PageController pageController = PageController();

  int currentIndex = 0;

  // خريطة لحفظ الإجابات النصية
  Map<String, TextEditingController> textControllers = {};

  // خريطة لحفظ اختيارات الراديو
  Map<String, String> selectedOptions = {};

  // كنترولر خاص بالبريد الإلكتروني في صفحة الـ Checkout
  final TextEditingController emailController = TextEditingController();

  PlatformFile? pickedFile;
  bool isLoading = false;

  TextEditingController getTextController(String questionId) {
    if (!textControllers.containsKey(questionId)) {
      textControllers[questionId] = TextEditingController();
    }
    return textControllers[questionId]!;
  }

  void setOptionValue(String questionId, String value, VoidCallback onUpdate) {
    selectedOptions[questionId] = value;
    onUpdate();
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void dispose() {
    pageController.dispose();
    emailController.dispose();
    textControllers.forEach((_, controller) => controller.dispose());
  }
}