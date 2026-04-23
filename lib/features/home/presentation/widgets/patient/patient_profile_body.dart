import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/functions/navigation.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';
import 'package:se7ty/features/onboarding/presentation/splash_view.dart';

class PatientProfileBody extends StatelessWidget {
  const PatientProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildProfileHeader(),
          Gap(20.h),
          _buildInfoSection(),
          _buildSettingsSection(context),
          Gap(30.h),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.r, 40.r, 24.r, 30.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1B6BD5)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
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
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: const Color(0xFFE6EEF9),
                  child: const Icon(Icons.person, color: AppColors.primary, size: 60),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, color: AppColors.primary, size: 18.sp),
                ),
              ),
            ],
          ),
          Gap(15.h),
          Text(
            PrefsHelper.getUserName() ?? 'مريضنا العزيز',
            style: GoogleFonts.cairo(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'patient@example.com',
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('المعلومات الشخصية'),
          Gap(15.h),
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.cake_outlined, 'العمر', '25 عام'),
                const Divider(height: 30, thickness: 0.5),
                _buildInfoRow(Icons.location_on_outlined, 'المدينة', 'القاهرة'),
                const Divider(height: 30, thickness: 0.5),
                _buildInfoRow(Icons.person_outline, 'الجنس', 'ذكر'),
                const Divider(height: 30, thickness: 0.5),
                _buildInfoRow(Icons.phone_outlined, 'رقم الهاتف', '0123456789'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('الإعدادات العامة'),
          Gap(15.h),
          _buildSettingsTile(Icons.edit_outlined, 'تعديل الملف الشخصي', () {}),
          _buildSettingsTile(Icons.notifications_none_outlined, 'الإشعارات', () {}),
          _buildSettingsTile(Icons.language_outlined, 'اللغة', () {}),
          _buildSettingsTile(Icons.help_outline, 'المساعدة والدعم', () {}),
          Gap(10.h),
          _buildSettingsTile(
            Icons.logout_rounded,
            'تسجيل الخروج',
            () {
              PrefsHelper.logout();
              pushAndRemoveUntil(context, const SplashScreen());
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.dark,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F5FD),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 20.sp, color: AppColors.primary),
        ),
        Gap(12.w),
        Text(
          label,
          style: GoogleFonts.cairo(fontSize: 14.sp, color: AppColors.grey),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 14.sp,
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.red : AppColors.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDestructive ? Colors.red.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Icon(icon, color: isDestructive ? Colors.red : AppColors.primary),
        title: Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 14.sp,
            color: color,
            fontWeight: isDestructive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14.sp,
          color: isDestructive ? Colors.red : AppColors.grey,
        ),
      ),
    );
  }
}
