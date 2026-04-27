import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';
import 'package:se7ty/features/home/presentation/page/patient/booking_screen.dart';
import 'package:go_router/go_router.dart';

class DoctorProfileScreen extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'بيانات الدكتور',
          style: GoogleFonts.cairo(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Gap(20.h),
                _buildDoctorCard(),
                Gap(24.h),
                _buildSectionTitle('نبذة تعريفية'),
                Gap(12.h),
                _buildInfoBox(
                  child: Text(
                    doctor.bio ?? 'لا يوجد وصف متاح لهذا الطبيب حالياً.',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      color: AppColors.dark,
                      height: 1.5,
                    ),
                  ),
                ),
                Gap(24.h),
                _buildSectionTitle('معلومات التواصل'),
                Gap(12.h),
                _buildInfoBox(
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.location_on_outlined, 'العنوان', doctor.address ?? 'غير محدد'),
                      Gap(12.h),
                      _buildInfoRow(Icons.phone_outlined, 'رقم الهاتف', doctor.phone1 ?? 'غير محدد'),
                      if (doctor.phone2 != null && doctor.phone2!.isNotEmpty) ...[
                        Gap(12.h),
                        _buildInfoRow(Icons.phone_outlined, 'رقم هاتف إضافي', doctor.phone2!),
                      ],
                      Gap(12.h),
                      _buildInfoRow(Icons.access_time, 'ساعات العمل', '${doctor.openHour} ص - ${doctor.closeHour} م'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppColors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${doctor.rating}',
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  Gap(4.w),
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                ],
              ),
              Gap(12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'كشف 100 ج.م',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'د. ${doctor.name}',
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              Text(
                doctor.specialization ?? '',
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          Gap(16.w),
          Hero(
            tag: doctor.uid ?? '',
            child: Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: (doctor.image != null && doctor.image!.isNotEmpty)
                      ? NetworkImage(doctor.image!)
                      : const AssetImage('assets/images/logo.png') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.dark,
      ),
    );
  }

  Widget _buildInfoBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.05)),
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  color: AppColors.grey,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  color: AppColors.dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Gap(12.w),
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 20.sp),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(doctor: doctor),
                ),
              );
            },
            child: Text(
              'احجز موعد الآن',
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
