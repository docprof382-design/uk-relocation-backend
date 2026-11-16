// home_data_model.dart

class ProgramCardModel {
  final String title;
  final String subtitle;
  final String buttonText;
  final String bgImagePath;
  final String flagPath;
  final Function()? onTap;
  final String programId;

  ProgramCardModel({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.bgImagePath,
    required this.flagPath,
    this.onTap,
    required this.programId,
  });
}

class ServiceModel {
  final String title;
  final String subtitle;
  final String iconPath;

  ServiceModel({
    required this.title,
    required this.subtitle,
    required this.iconPath,
  });
}

class DestinationModel {
  final String title;
  final String imagePath;

  DestinationModel({
    required this.title,
    required this.imagePath,
  });
}

// Data Storage Class (Static Data Model)
class HomeStaticData {
  static final List<ProgramCardModel> programs = [
    ProgramCardModel(
      title: 'نموذج التسجيل لبرنامج\nالانتقال الإنساني لبريطانيا',
      subtitle: 'قدم الآن على برنامج الانتقال الإنساني\nللحصول على فرصة آمنة ومستقبل أفضل',
      buttonText: 'الانتقال الإنساني لبريطانيا',
      bgImagePath: 'assets/images/uk_card.jpg',
      flagPath: 'assets/images/uk_card.jpg',
      programId: 'uk_program',
      
    ),
    ProgramCardModel(
      title: 'استمارة الهجرة إلى كندا',
      subtitle: 'ابدأ رحلتك نحو مستقبل أفضل\nمع برامج الهجرة إلى كندا',
      buttonText: 'تقديم استمارة الهجرة إلى كندا',
      bgImagePath: 'assets/images/canada_card.jpg',
      flagPath: 'assets/images/canada_card.jpg',
      programId: 'canada_program',
    ),

    ProgramCardModel(
      title: ' استبيان التسجيل في المنح الدراسيه',
      subtitle: 'ابدأ رحلتك لعالم افضل',
      buttonText: 'تسجيل البيانات',
      bgImagePath: 'assets/images/canada_card.jpg',
      flagPath: 'assets/images/canada_card.jpg',
      programId: 'scholarships',
    ),
  ];

  static final List<ServiceModel> services = [
    ServiceModel(title: 'خدمات الهجرة', subtitle: 'كندا - بريطانيا - دول أخرى', iconPath: 'assets/icons/world.jpg'),
    ServiceModel(title: 'برامج السفر', subtitle: 'سياحة - سياحة علاجية - دراسة', iconPath: 'assets/icons/people.jpg'),
    ServiceModel(title: 'إصدار التأشيرات', subtitle: 'بسرعة واحترافية', iconPath: 'assets/icons/wallet.jpg'),
    ServiceModel(title: 'حجوزات الفنادق', subtitle: 'في جميع أنحاء العالم', iconPath: 'assets/icons/bank.jpg'),
    ServiceModel(title: 'تذاكر الطيران', subtitle: 'بأفضل الأسعار والوجهات', iconPath: 'assets/icons/travel.jpg'),
  ];

  static final List<DestinationModel> destinations = [
    DestinationModel(title: 'ماليزيا', imagePath: 'assets/images/malyzy.jpg'),
    DestinationModel(title: 'كندا', imagePath: 'assets/images/canada.jpg'),
    DestinationModel(title: 'لندن', imagePath: 'assets/images/london.jpg'),
    DestinationModel(title: 'دبي', imagePath: 'assets/images/dobai.jpg'),
    DestinationModel(title: 'تركيا', imagePath: 'assets/images/tourkish.jpg'),
    DestinationModel(title: 'لندن', imagePath: 'assets/images/london.jpg'),
    DestinationModel(title: 'باريس', imagePath: 'assets/images/paris.jpg'),
    DestinationModel(title: 'ألبانيا', imagePath: 'assets/images/albania.jpg'),
  ];
}