import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';

class SpecialistsList extends StatelessWidget {
  const SpecialistsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> specializations = [
      {'name': 'جراحة عامة', 'color': AppColors.blueCard},
      {'name': 'دكتور قلب', 'color': AppColors.tealCard},
      {'name': 'عظام', 'color': AppColors.orangeCard},
      {'name': 'أعصاب', 'color': AppColors.blueCard},
      {'name': 'عيون', 'color': AppColors.tealCard},
    ];

    return SizedBox(
      height: 180.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true, // For RTL
        itemCount: specializations.length,
        separatorBuilder: (context, index) => Gap(12.w),
        itemBuilder: (context, index) {
          return Container(
            width: 140.w,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: specializations[index]['color'],
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 40.h,
                  right: -10.w,
                  left: -10.w,
                  child: SvgPicture.asset(
                    'assets/images/doctor-card.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Text(
                      specializations[index]['name']!,
                      style: GoogleFonts.cairo(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
