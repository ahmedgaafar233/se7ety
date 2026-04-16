import 'package:flutter/material.dart';
import 'package:se7ty/features/auth/presentation/page/login_screen.dart';
import 'package:se7ty/features/auth/presentation/page/register_screen.dart';
import 'package:se7ty/features/home/presentation/page/doctor/doctor_main_view.dart';
import 'package:se7ty/features/home/presentation/page/patient/patient_main_view.dart';
import 'package:se7ty/features/onboarding/presentation/onboarding_view.dart';
import 'package:se7ty/features/auth/presentation/role_view.dart';
import 'package:se7ty/features/onboarding/presentation/splash_view.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String role = '/role';
  static const String login = '/login';
  static const String register = '/register';
  static const String patientHome = '/patientHome';
  static const String doctorHome = '/doctorHome';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case AppRoutes.role:
        return MaterialPageRoute(builder: (_) => const RoleView());
      case AppRoutes.login:
        final bool isDoctor = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => LoginScreen(isDoctor: isDoctor),
        );
      case AppRoutes.register:
        final bool isDoctor = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(isDoctor: isDoctor),
        );
      case AppRoutes.patientHome:
        return MaterialPageRoute(builder: (_) => const PatientMainView());
      case AppRoutes.doctorHome:
        return MaterialPageRoute(builder: (_) => const DoctorMainView());
      default:
        return null;
    }
  }
}
