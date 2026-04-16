import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:se7ty/core/routing/app_router.dart';
import 'package:se7ty/core/theme/app_colors.dart';
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
    if (mounted) {
      final isOnboarded = PrefsHelper.getIsOnboarded();
      final isLoggedIn = PrefsHelper.getIsLoggedIn();
      final role = PrefsHelper.getUserRole();

      if (isOnboarded) {
        if (isLoggedIn) {
          if (role == 'doctor') {
            Navigator.pushReplacementNamed(context, AppRoutes.doctorHome);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.patientHome);
          }
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.role);
        }
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 150.w,
                ),
                const Gap(20),
                Text(
                  'Se7ety',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 2.0,
                       ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50.h,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
