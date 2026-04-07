import 'package:flutter/material.dart';

import 'auth/presentation/login_screen.dart';
import 'auth/presentation/sign_up_screen.dart';
import '../splash/splash_screen.dart';
import 'screens/home_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String homepage = '/homepage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case auth:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(), // temporary (we’ll improve later)
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );

      case homepage:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}