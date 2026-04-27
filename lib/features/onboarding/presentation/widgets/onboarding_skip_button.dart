import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return index != 2
        ? TextButton(
            onPressed: () {
              PrefsHelper.setIsOnboarded(true);
              context.go(Routes.welcome);
            },
            child: Text(
              'تخطي',
              style: GoogleFonts.cairo(
                color: AppColors.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
