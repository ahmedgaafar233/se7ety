import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';

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
        leading: const Gap(0),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
        ],
        title: Text(
          'بيانات الدكتور',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 120.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Gap(20.h),
                _buildDoctorHeaderCard(),
                Gap(24.h),
                _buildSectionTitle('نبذة تعريفية'),
                Gap(8.h),
                Text(
                  doctor.bio ?? 'ماجستير في العلوم والتكنولوجيا والنقل البحري في هذا المنتدى في نفس الوقت',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    color: AppColors.grey,
                    height: 1.6,
                  ),
                ),
                Gap(24.h),
                _buildInfoBox(
                  child: Column(
                    children: [
                      _buildSimpleInfoRow(Icons.access_time_filled, '${doctor.openHour} - ${doctor.closeHour}'),
                      Gap(12.h),
                      _buildSimpleInfoRow(Icons.location_on, doctor.address ?? 'مدينة نصر القاهرة'),
                    ],
                  ),
                ),
                Gap(24.h),
                _buildSectionTitle('معلومات الاتصال'),
                Gap(12.h),
                _buildInfoBox(
                  child: Column(
                    children: [
                      _buildContactRow(Icons.email, doctor.email ?? 'khaled@gmail.com'),
                      Gap(12.h),
                      _buildContactRow(Icons.phone, doctor.phone1 ?? '01222222222'),
                      if (doctor.phone2 != null && doctor.phone2!.isNotEmpty) ...[
                        Gap(12.h),
                        _buildContactRow(Icons.phone, doctor.phone2!),
                      ],
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

  Widget _buildDoctorHeaderCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'د. ${doctor.name}',
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                doctor.specialization ?? 'دكتور قلب',
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  color: AppColors.grey,
                ),
              ),
              Gap(8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  Gap(4.w),
                  Text(
                    '${doctor.rating}',
                    style: GoogleFonts.cairo(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Gap(12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildCallButton('2', Icons.phone),
                  Gap(12.w),
                  _buildCallButton('1', Icons.phone),
                ],
              ),
            ],
          ),
        ),
        Gap(20.w),
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: (doctor.image != null && doctor.image!.isNotEmpty)
                  ? NetworkImage(doctor.image!)
                  : const AssetImage('assets/images/logo.png') as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCallButton(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F2F2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Text(label, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          Gap(4.w),
          Icon(icon, size: 16, color: AppColors.dark),
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
        color: const Color(0xFFE6F2F2).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }

  Widget _buildSimpleInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          text,
          style: GoogleFonts.cairo(fontSize: 14.sp, color: AppColors.dark),
        ),
        Gap(12.w),
        Icon(icon, color: AppColors.primary, size: 20),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          text,
          style: GoogleFonts.cairo(fontSize: 14.sp, color: AppColors.dark),
        ),
        Gap(12.w),
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Positioned(
      bottom: 20.h,
      left: 20.w,
      right: 20.w,
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
            context.push(Routes.booking, extra: doctor);
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
    );
  }
}
