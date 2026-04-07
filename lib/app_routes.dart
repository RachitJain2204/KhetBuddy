import 'package:flutter/material.dart';
import 'package:khet_buddy/farm/presentation/add_farm_page.dart';
import 'package:khet_buddy/farm/presentation/select_farm_page.dart';
import 'package:khet_buddy/profile/create_profile.dart';
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
  static const String createProfile = '/createProfile';
  static const String selectFram = '/selectFarmPage';
  static const String addFarm = '/addFarmPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case auth:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
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

      case createProfile:
        return MaterialPageRoute(
          builder: (_) => const CreateProfile(),
        );

      case selectFram:
        return MaterialPageRoute(
          builder: (_) => const SelectFarmPage(),
        );

      case addFarm:
        return MaterialPageRoute(
          builder: (_) => const AddFarmPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}