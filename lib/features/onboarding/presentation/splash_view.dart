import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    
    // Forcing to show onboarding for testing
    // PrefsHelper.remove('isOnboarded'); // Or we can just set isOnboarded to false
    
    if (mounted) {
      final isOnboarded = PrefsHelper.getIsOnboarded();
      final isLoggedIn = PrefsHelper.getIsLoggedIn();
      final role = PrefsHelper.getUserRole();
      final isProfileCompleted = PrefsHelper.getIsProfileCompleted();

      if (isOnboarded) {
        if (isLoggedIn) {
          if (role == 'doctor') {
            if (isProfileCompleted) {
              context.go(Routes.doctorMainApp);
            } else {
              context.go(Routes.doctorUpdateProfile);
            }
          } else {
            context.go(Routes.patientMainApp);
          }
        } else {
          context.go(Routes.welcome);
        }
      } else {
        context.go(Routes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/se7ty_logo.png',
          width: 250.w,
        ),
      ),
    );
  }
}
