import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';

class DoctorProfileScreen extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'بيانات الدكتور',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDoctorCard(),
                Gap(24.h),
                _buildSectionTitle('نبذه تعريفيه'),
                Gap(12.h),
                _buildInfoBox(
                  child: Text(
                    doctor.bio ?? 'لا توجد نبذة تعريفية',
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      color: AppColors.dark,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Gap(16.h),
                _buildInfoBox(
                  child: Column(
                    children: [
                      _buildInfoRow(
                        icon: Icons.access_time_filled,
                        text: '${doctor.openHour ?? ''} - ${doctor.closeHour ?? ''}',
                      ),
                      Gap(12.h),
                      _buildInfoRow(
                        icon: Icons.location_on,
                        text: doctor.address ?? 'لم يضاف',
                      ),
                    ],
                  ),
                ),
                Gap(24.h),
                _buildSectionTitle('معلومات الاتصال'),
                Gap(12.h),
                _buildInfoBox(
                  child: Column(
                    children: [
                      _buildInfoRow(
                        icon: Icons.email,
                        text: doctor.email ?? 'لم يضاف',
                      ),
                      if (doctor.phone1 != null && doctor.phone1!.isNotEmpty) ...[
                        Gap(12.h),
                        _buildInfoRow(
                          icon: Icons.phone,
                          text: doctor.phone1!,
                        ),
                      ],
                      if (doctor.phone2 != null && doctor.phone2!.isNotEmpty) ...[
                        Gap(12.h),
                        _buildInfoRow(
                          icon: Icons.phone,
                          text: doctor.phone2!,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Book Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(Routes.booking, extra: doctor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'احجز موعد الان',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'د. ${doctor.name ?? ''}',
                      style: GoogleFonts.cairo(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      doctor.specialization ?? '',
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        color: AppColors.grey,
                      ),
                    ),
                    Gap(8.h),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        Gap(4.w),
                        Text(
                          '${doctor.rating ?? 0}',
                          style: GoogleFonts.cairo(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Gap(16.h),
                    Row(
                      children: [
                        _buildCallButton(Icons.phone),
                        Gap(12.w),
                        _buildCallButton(Icons.video_call),
                      ],
                    )
                  ],
                ),
              ),
              CircleAvatar(
                radius: 45.r,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: (doctor.image != null && doctor.image!.isNotEmpty)
                    ? NetworkImage(doctor.image!)
                    : null,
                child: (doctor.image == null || doctor.image!.isEmpty)
                    ? Icon(Icons.person, size: 50.sp, color: AppColors.primary)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, color: AppColors.primary, size: 24.sp),
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
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              color: AppColors.dark,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Gap(12.w),
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 16.sp),
        ),
      ],
    );
  }
}
