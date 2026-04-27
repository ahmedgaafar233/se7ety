import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:intl/intl.dart';

class DoctorHomeBody extends StatelessWidget {
  const DoctorHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Gap(24.h),
                _buildSectionHeader('نظرة عامة'),
                Gap(16.h),
                _buildStatsGrid(),
                Gap(32.h),
                _buildSectionHeader('جدول اليوم'),
                Gap(16.h),
                _buildHorizontalCalendar(),
                Gap(32.h),
                _buildSectionHeader('مواعيد اليوم'),
                Gap(16.h),
                _buildUpcomingAppointments(),
                Gap(24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  await PrefsHelper.logout();
                  if (context.mounted) {
                    context.go(Routes.welcome);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.logout, color: Colors.white, size: 20.sp),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'أهلاً بك،',
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    'د. ${PrefsHelper.getUserName() ?? 'طبيبنا'}',
                    style: GoogleFonts.cairo(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard('إجمالي المرضى', '120', Icons.people_outline, const Color(0xFF42A5F5)),
        _buildStatCard('مواعيد اليوم', '8', Icons.calendar_today_outlined, const Color(0xFFFFA726)),
        _buildStatCard('المراجعات', '15', Icons.star_outline, const Color(0xFFFFCA28)),
        _buildStatCard('المهام', '4', Icons.pending_actions_outlined, const Color(0xFFEF5350)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              Gap(8.w),
              Icon(icon, color: color, size: 24.sp),
            ],
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 12.sp,
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCalendar() {
    return SizedBox(
      height: 90.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: 14,
        separatorBuilder: (_, __) => Gap(12.w),
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isToday = index == 0;
          
          return Container(
            width: 70.w,
            decoration: BoxDecoration(
              color: isToday ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isToday ? AppColors.primary : AppColors.grey.withOpacity(0.1),
              ),
              boxShadow: isToday ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ] : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('E', 'ar').format(date),
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    color: isToday ? Colors.white : AppColors.grey,
                  ),
                ),
                Text(
                  DateFormat('d').format(date),
                  style: GoogleFonts.cairo(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.white : AppColors.dark,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'عرض الكل',
          style: GoogleFonts.cairo(
            fontSize: 14.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingAppointments() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (_, __) => Gap(12.h),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.arrow_back_ios_new, size: 14, color: AppColors.primary),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'محمد علي السيد',
                    style: GoogleFonts.cairo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '10:30 صباحاً',
                        style: GoogleFonts.cairo(
                          fontSize: 13.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(4.w),
                      Icon(Icons.access_time, size: 14, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
              Gap(16.w),
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'), // Placeholder
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
