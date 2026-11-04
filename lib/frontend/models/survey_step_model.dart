enum InputType { text, radio, dropdown , countryPicker}
enum StepType { normal, checkout }

class SurveyStepModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final StepType type;

  SurveyStepModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    this.type = StepType.normal,
  });
}

class OptionModel {
  final String value;
  final String titleAr;
  final String titleEn;

  OptionModel({
    required this.value,
    required this.titleAr,
    required this.titleEn,
  });
}

class QuestionModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final InputType inputType;
  final List<OptionModel> options;

  QuestionModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.inputType,
    this.options = const [],
  });
}

class SectionModel {
  final int id;
  final String sectionTitleAr;
  final String sectionTitleEn;
  final List<QuestionModel> questions;

  SectionModel({
    required this.id,
    required this.sectionTitleAr,
    required this.sectionTitleEn,
    required this.questions,
  });

  static List<SectionModel> sections = [
    // القسم الأول
    SectionModel(
      id: 1,
      sectionTitleAr: 'القسم الأول: المعلومات الشخصية',
      sectionTitleEn: 'Section 1: Personal Information',
      questions: [
        QuestionModel(
          id: 'full_name',
          titleAr: 'الاسم بالكامل (كما بالوثائق الرسمية)',
          titleEn: 'Full Name (as in official documents)',
          inputType: InputType.text,
        ),
        QuestionModel(
          id: 'nationality',
          titleAr: 'الجنسية',
          titleEn: 'Nationality',
          inputType: InputType.countryPicker,
          
        ),
        QuestionModel(
          id: 'residence_country',
          titleAr: 'بلد الإقامة',
          titleEn: 'Country of Residence',
          inputType: InputType.text,
        ),
        QuestionModel(
          id: 'gender',
          titleAr: 'الجنس',
          titleEn: 'Gender',
          inputType: InputType.radio,
          options: [
            OptionModel(value: 'male', titleAr: 'ذكر', titleEn: 'Male'),
            OptionModel(value: 'female', titleAr: 'أنثى', titleEn: 'Female'),
          ],
        ),
      ],
    ),

    // القسم الثاني
    SectionModel(
      id: 2,
      sectionTitleAr: 'القسم الثاني: معلومات التواصل',
      sectionTitleEn: 'Section 2: Contact Information',
      questions: [
        QuestionModel(
          id: 'phone',
          titleAr: 'رقم الهاتف',
          titleEn: 'Phone Number',
          inputType: InputType.text,
        ),
        QuestionModel(
          id: 'preferred_language',
          titleAr: 'اللغة المفضلة للتواصل',
          titleEn: 'Preferred Language for Communication',
          inputType: InputType.radio,
          options: [
            OptionModel(value: 'ar', titleAr: 'العربية', titleEn: 'Arabic'),
            OptionModel(value: 'en', titleAr: 'الإنجليزية', titleEn: 'English'),
          ],
        ),
      ],
    ),

    // القسم الثالث
    SectionModel(
      id: 3,
      sectionTitleAr: 'القسم الثالث: الوضع الإنساني والحالة',
      sectionTitleEn: 'Section 3: Humanitarian Status',
      questions: [
        QuestionModel(
          id: 'case_type',
          titleAr: 'ما نوع الحالة؟',
          titleEn: 'What is the case type?',
          inputType: InputType.radio,
          options: [
            OptionModel(value: 'individual', titleAr: 'فرد', titleEn: 'Individual'),
            OptionModel(value: 'family', titleAr: 'عائلة / أسرة', titleEn: 'Family'),
            OptionModel(value: 'special_case', titleAr: 'حالة خاصة تتطلب مراجعة', titleEn: 'Special Case'),
          ],
        ),
        QuestionModel(
          id: 'is_displaced',
          titleAr: 'هل أنت نازح حالياً؟',
          titleEn: 'Are you currently displaced?',
          inputType: InputType.radio,
          options: [
            OptionModel(value: 'yes', titleAr: 'نعم', titleEn: 'Yes'),
            OptionModel(value: 'no', titleAr: 'لا', titleEn: 'No'),
          ],
        ),
        QuestionModel(
          id: 'unhcr_number',
          titleAr: 'هل لديك ملف لدى المفوضية السامية للأمم المتحدة (UNHCR)؟',
          titleEn: 'Do you have a file with UNHCR?',
          inputType: InputType.radio,
          options: [
            OptionModel(value: 'yes', titleAr: 'نعم', titleEn: 'Yes'),
            OptionModel(value: 'no', titleAr: 'لا', titleEn: 'No'),
          ],
        ),
      ],
    ),

    // القسم الرابع
    SectionModel(
      id: 4,
      sectionTitleAr: 'القسم الرابع: الوثائق والمستندات',
      sectionTitleEn: 'Section 4: Documents',
      questions: [
        QuestionModel(
          id: 'passport_number',
          titleAr: 'رقم جواز السفر / وثيقة السفر',
          titleEn: 'Passport / Travel Document Number',
          inputType: InputType.text,
        ),
      ],
    ),

    // القسم الخامس
    SectionModel(
      id: 5,
      sectionTitleAr: 'القسم الخامس: التفاصيل الإضافية',
      sectionTitleEn: 'Section 5: Additional Details',
      questions: [
        QuestionModel(
          id: 'notes',
          titleAr: 'شرح مختصر للحالة أو أي ملاحظات مهمة',
          titleEn: 'Brief explanation of the case or notes',
          inputType: InputType.text,
        ),
      ],
    ),

    // القسم السادس (الدفع والتأكيد)
    SectionModel(
      id: 6,
      sectionTitleAr: 'القسم السادس: التأكيد والدفع',
      sectionTitleEn: 'Section 6: Confirmation & Payment',
      questions: [],
    ),
  ];
}