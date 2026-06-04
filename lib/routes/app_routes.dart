import 'package:flutter/material.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/home_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginScreen(),
        home: (_) => const HomeScreen(),
      };
}
