import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/functions/navigation.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';
import 'package:se7ty/features/onboarding/presentation/splash_view.dart';

class DoctorProfileBody extends StatelessWidget {
  const DoctorProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Gap(24.h),
                _buildSectionTitle('نبذة تعريفية'),
                Gap(12.h),
                _buildInfoBox(
                  child: Text(
                    'أخصائي طب وجراحة العيون، خبرة أكثر من 10 سنوات في عمليات تصحيح النظر والمياه البيضاء والزرقاء.',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      color: AppColors.dark,
                      height: 1.5,
                    ),
                  ),
                ),
                Gap(24.h),
                _buildSectionTitle('معلومات العيادة'),
                Gap(12.h),
                _buildInfoBox(
                  child: Column(
                    children: [
                      _buildInfoRow('العنوان', 'القاهرة، شارع التحرير'),
                      Gap(12.h),
                      _buildInfoRow('رقم العيادة', '01012345678'),
                      Gap(12.h),
                      _buildInfoRow('ساعات العمل', '10:00 ص - 08:00 م'),
                    ],
                  ),
                ),
                Gap(24.h),
                _buildSectionTitle('الإعدادات'),
                Gap(12.h),
                _buildSettingsList(context),
                Gap(40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 47.r,
                  backgroundColor: AppColors.accent,
                  child: Icon(Icons.person, size: 50.sp, color: AppColors.primary),
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.edit, size: 16.sp, color: AppColors.primary),
              ),
            ],
          ),
          Gap(16.h),
          Text(
            'د. ${PrefsHelper.getUserName() ?? 'طبيبنا'}',
            style: GoogleFonts.cairo(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'أخصائي طب وجراحة العيون',
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
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
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 14.sp,
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 14.sp,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildSettingsTile(Icons.person_outline, 'تعديل البيانات الشخصية', () {}),
          const Divider(height: 1),
          _buildSettingsTile(Icons.history, 'سجل المواعيد', () {}),
          const Divider(height: 1),
          _buildSettingsTile(Icons.notifications_none, 'الإشعارات', () {}),
          const Divider(height: 1),
          _buildSettingsTile(Icons.logout, 'تسجيل الخروج', () {
            PrefsHelper.logout();
            pushAndRemoveUntil(context, const SplashScreen());
          }, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(Icons.arrow_back_ios_new, size: 14, color: AppColors.grey),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: GoogleFonts.cairo(
          fontSize: 15.sp,
          color: isDestructive ? Colors.red : AppColors.dark,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(icon, color: isDestructive ? Colors.red : AppColors.primary, size: 22.sp),
    );
  }
}
