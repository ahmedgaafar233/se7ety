import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingNavBar extends StatelessWidget {
  const OnboardingNavBar({
    super.key,
    required this.pageController,
    required this.currentIndex,
    required this.count,
  });

  final PageController pageController;
  final int currentIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SmoothPageIndicator(
          controller: pageController,
          count: count,
          effect: ExpandingDotsEffect(
            dotColor: Colors.grey.shade300,
            activeDotColor: AppColors.primary,
            dotHeight: 8.h,
            dotWidth: 8.w,
            expansionFactor: 4,
            spacing: 5.w,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (currentIndex == 2) {
              PrefsHelper.setIsOnboarded(true);
              context.go(Routes.welcome);
            } else {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            currentIndex == 2 ? 'ابدأ الآن' : 'التالي',
            style: GoogleFonts.cairo(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
