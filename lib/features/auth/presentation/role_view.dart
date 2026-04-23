import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';

class RoleView extends StatelessWidget {
  const RoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/role_bg.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          
          // Gradient Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.6),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Gap(80.h),
                  Text(
                    'أهلاً بك',
                    style: GoogleFonts.cairo(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Gap(8.h),
                  Text(
                    'سجل واحجز عند دكتورك وأنت في البيت',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                      fontSize: 18.sp,
                      color: AppColors.dark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  
                  // Bottom Container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'سجل دلوقتي كـ',
                          style: GoogleFonts.cairo(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(24.h),
                        
                        // Doctor Button
                        _RoleButton(
                          title: 'دكتور',
                          onPressed: () {
                            context.push(
                              Routes.login,
                              extra: true,
                            );
                          },
                        ),
                        Gap(16.h),
                        
                        // Patient Button
                        _RoleButton(
                          title: 'مريض',
                          onPressed: () {
                            context.push(
                              Routes.login,
                              extra: false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Gap(60.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _RoleButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
