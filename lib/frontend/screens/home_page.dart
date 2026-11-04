// lib/frontend/screens/home_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/home_data_model.dart'; // عدل المسار لو كان ../../ حسب هيكل مجلداتك
import '../screens/section_step_widget.dart'; 
import '../screens/section_step_widget2.dart'; 
import '../controllers/survey_controller.dart';
import '../models/survey_step_model.dart';
import '../../../main.dart'; // للوصول الصحيح لـ main.dart من مجلد screens

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _destinationPageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _destinationPageController = PageController(viewportFraction: 0.25);
    
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < HomeStaticData.destinations.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_destinationPageController.hasClients) {
        _destinationPageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _destinationPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildCustomAppBar(),
        body: ListView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _buildHeroHeader(),
                  const SizedBox(height: 24),
                  _buildProgramCardsSection(context),
                  const SizedBox(height: 20),
                  _buildServicesSection(),
                  const SizedBox(height: 32),
                  _buildWhyChooseUsSection(),
                  const SizedBox(height: 32),
                  _buildDestinationsSection(),
                  const SizedBox(height: 32),
                  _buildCTASection(),
                  _buildFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      toolbarHeight: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo.jpg', height: 50),
          Row(
            children: [
              _navLink('الرئيسية', isSelected: true),
              _navLink('خدماتنا'),
              _navLink('البرامج'),
              _navLink('عن الشركة'),
              _navLink('اتصل بنا'),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.send, size: 16, color: Colors.black),
            label: const Text('تواصل معنا', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1B842),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          )
        ],
      ),
    );
  }

  Widget _navLink(String title, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFFF1B842) : const Color(0xFF0D253F),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/header.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProgramCardsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: HomeStaticData.programs.map((program) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(program.bgImagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(program.flagPath, width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(program.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text(program.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (program.programId == 'uk_program') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormFlowScreen(), // تم إزالة const لتجنب الخطأ
                            ),
                          );
                        } else if (program.programId == 'canada_program') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormFlowScreen(), // تم إزالة const لتجنب الخطأ
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(program.buttonText, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      children: [
        const Text('خدماتنا المميزة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D253F))),
        const SizedBox(height: 4),
        const Text('نقدم لك مجموعة متكاملة من خدمات السفر والسياحة والهجرة', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: HomeStaticData.services.map((service) {
            return Container(
              width: 140,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                children: [
                  Image.asset(service.iconPath, width: 36, height: 36),
                  const SizedBox(height: 8),
                  Text(service.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(service.subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWhyChooseUsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      child: Image.asset('assets/images/footer.jpg'),
    );
  }

  Widget _buildDestinationsSection() {
    return Column(
      children: [
        const Text('وجهاتنا المميزة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D253F))),
        const SizedBox(height: 4),
        const Text('اكتشف أجمل الوجهات السياحية حول العالم', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _destinationPageController,
            itemCount: HomeStaticData.destinations.length,
            itemBuilder: (context, index) {
              final dest = HomeStaticData.destinations[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(image: AssetImage(dest.imagePath), fit: BoxFit.cover),
                ),
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  color: Colors.black54,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    dest.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCTASection() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D253F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('وجهتك القادمة تبدأ من هنا', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('تواصل معنا الآن للحصول على أفضل العروض والخدمات', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.send, size: 16, color: Colors.black),
            label: const Text('تواصل معنا', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1B842),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: const Color(0xFF081829),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('مسقط - سلطنة عمان', style: TextStyle(color: Colors.white70, fontSize: 11)),
          Text('info@alanwar-travel.com', style: TextStyle(color: Colors.white70, fontSize: 11)),
          Text('© 2025 جميع الحقوق محفوظة - شركة الأنوار للسفريات', style: TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }
}