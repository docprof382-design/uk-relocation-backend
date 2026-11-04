// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../frontend/screens/home_page.dart';
import '../main.dart'; // للوصول لـ FormFlowScreen

class AppRoutes {
  static const String home = '/';
  static const String formFlow = '/form-flow';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case formFlow:
        return MaterialPageRoute(builder: (_) => const FormFlowScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('خطأ: المسار غير موجود ${settings.name}'),
            ),
          ),
        );
    }
  }
}