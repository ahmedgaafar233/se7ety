import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/features/onboarding/data/models/onboarding_model.dart';

class OnboardingPageViewItem extends StatelessWidget {
  const OnboardingPageViewItem({
    super.key,
    required this.model,
  });

  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          model.image,
          height: 300.h,
        ),
        Gap(40.h),
        Text(
          model.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Gap(20.h),
        Text(
          model.description,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: 16.sp,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
