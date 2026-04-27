import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';

class PatientAppointmentsBody extends StatefulWidget {
  const PatientAppointmentsBody({super.key});

  @override
  State<PatientAppointmentsBody> createState() => _PatientAppointmentsBodyState();
}

class _PatientAppointmentsBodyState extends State<PatientAppointmentsBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'مواعيد الحجز',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25.r),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: 3,
        padding: EdgeInsets.all(20.r),
        separatorBuilder: (_, __) => Gap(20.h),
        itemBuilder: (context, index) {
          return _buildAppointmentCard();
        },
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 24.sp),
              Text(
                'د. خالد علي عبدالله',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Gap(10.h),
          _buildInfoRow(Icons.calendar_month, '٢٧ أبريل ٢٠٢٦'),
          _buildInfoRow(Icons.access_time_filled, '١٠:٣٠ م'),
          _buildInfoRow(Icons.person, 'اسم المريض: Ahmed'),
          _buildInfoRow(Icons.location_on, 'مدينة نصر، القاهرة'),
          Gap(20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5252),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'حذف الحجز',
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              color: AppColors.dark,
            ),
          ),
          Gap(10.w),
          Icon(icon, size: 18.sp, color: AppColors.primary),
        ],
      ),
    );
  }
}
