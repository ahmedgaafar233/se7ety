import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:se7ty/core/theme/app_colors.dart';

class DoctorAppointmentsBody extends StatelessWidget {
  const DoctorAppointmentsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20.h),
          Text(
            'جدول المواعيد',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.dark),
          ),
          Gap(20.h),
          Expanded(
            child: ListView.separated(
              itemCount: 6,
              separatorBuilder: (_, __) => Gap(15.h),
              itemBuilder: (context, index) {
                return _buildAppointmentCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.primary),
          ),
          Gap(15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أحمد السعيد',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  'منذ 15 دقيقة',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.grey),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '10:30 ص',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Text(
                'كشف عادي',
                style: TextStyle(fontSize: 12.sp, color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
