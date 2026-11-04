import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import '../models/survey_step_model.dart';
import '../controllers/survey_controller.dart';

class SectionStepWidget2 extends StatelessWidget {
  final SectionModel section;
  final SurveyController controller;
  final VoidCallback onStateUpdate;
  final VoidCallback onNextPressed;
  final VoidCallback? onBackPressed;
  final bool isArabic;

  const SectionStepWidget2({
    super.key,
    required this.section,
    required this.controller,
    required this.onStateUpdate,
    required this.onNextPressed,
    this.onBackPressed,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? section.sectionTitleAr : section.sectionTitleEn,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          const SizedBox(height: 20),

          ...section.questions.map((question) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? question.titleAr : question.titleEn,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  if (question.inputType == InputType.text)
                    TextField(
                      controller: controller.getTextController(question.id),
                      decoration: InputDecoration(
                        hintText: isArabic ? 'أدخل الإجابة هنا...' : 'Enter response here...',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),

                  if (question.inputType == InputType.countryPicker)
                    InkWell(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: false,
                          onSelect: (Country country) {
                            final countryName = isArabic ? country.nameLocalized ?? country.name : country.name;
                            controller.setOptionValue(question.id, countryName, onStateUpdate);
                          },
                          countryListTheme: CountryListThemeData(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            inputDecoration: InputDecoration(
                              labelText: isArabic ? 'بحث' : 'Search',
                              hintText: isArabic ? 'اكتب اسم الدولة...' : 'Start typing to search...',
                              prefixIcon: const Icon(Icons.search),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.selectedOptions[question.id] ??
                                  (isArabic ? 'اختر الدولة...' : 'Select Country...'),
                              style: TextStyle(
                                fontSize: 16,
                                color: controller.selectedOptions.containsKey(question.id)
                                    ? Colors.black
                                    : Colors.grey[600],
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),

                  if (question.inputType == InputType.dropdown)
                    DropdownButtonFormField<String>(
                      value: controller.selectedOptions[question.id],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      hint: Text(isArabic ? 'اختر الخيار المناسب' : 'Select an option'),
                      items: question.options.map((option) {
                        return DropdownMenuItem<String>(
                          value: option.value,
                          child: Text(isArabic ? option.titleAr : option.titleEn),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          controller.setOptionValue(question.id, val, onStateUpdate);
                        }
                      },
                    ),

                  if (question.inputType == InputType.radio)
                    Column(
                      children: question.options.map((option) {
                        final selectedVal = controller.selectedOptions[question.id];
                        return RadioListTile<String>(
                          title: Text(isArabic ? option.titleAr : option.titleEn),
                          value: option.value,
                          groupValue: selectedVal,
                          activeColor: Colors.deepPurple,
                          onChanged: (val) {
                            if (val != null) {
                              controller.setOptionValue(question.id, val, onStateUpdate);
                            }
                          },
                        );
                      }).toList(),
                    ),
                ],
              ),
            );
          }),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              onBackPressed != null
                  ? OutlinedButton(
                      onPressed: onBackPressed,
                      child: Text(isArabic ? 'السابق' : 'Previous'),
                    )
                  : const SizedBox.shrink(),
              ElevatedButton(
                onPressed: onNextPressed,
                child: Text(isArabic ? 'التالي' : 'Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}