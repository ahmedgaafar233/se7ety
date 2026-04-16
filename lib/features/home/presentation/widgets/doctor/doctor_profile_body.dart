import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
          _buildInfoSection(),
          _buildSettingsSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Gap(20.h),
          CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.white,
            child: const Icon(Icons.person, color: AppColors.primary, size: 60),
          ),
          Gap(15.h),
          Text(
            'د. ${PrefsHelper.getUserName() ?? 'طبيبنا'}',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            'أخصائي طب وجراحة العيون',
            style: TextStyle(fontSize: 14.sp, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('نبذة عن الطبيب'),
          Gap(10.h),
          Text(
            'أخصائي طب وجراحة العيون، خبرة أكثر من 10 سنوات في عمليات تصحيح النظر والمياه البيضاء والزرقاء.',
            style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
          ),
          Gap(20.h),
          _buildSectionTitle('معلومات العيادة'),
          Gap(15.h),
          _buildInfoCard([
            _buildInfoRow('العنوان', 'القاهرة، شارع التحرير'),
            _buildInfoRow('رقم العيادة', '01012345678'),
            _buildInfoRow('ساعات العمل', '10:00 ص - 08:00 م'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('الإعدادات'),
          Gap(15.h),
          _buildSettingsTile(Icons.edit, 'تعديل البيانات المهنية', () {}),
          _buildSettingsTile(Icons.notifications, 'تنبيهات المواعيد', () {}),
          _buildSettingsTile(Icons.language, 'اللغة', () {}),
          const Divider(),
          _buildSettingsTile(Icons.logout, 'تسجيل الخروج', () {
            PrefsHelper.logout();
            pushAndRemoveUntil(context, const SplashView());
          }, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.dark),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
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
        children: children.expand((w) => [w, const Divider()]).toList()..removeLast(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, color: AppColors.grey)),
          Text(value, style: TextStyle(fontSize: 14.sp, color: AppColors.dark, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.red : AppColors.dark;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDestructive ? Colors.red : AppColors.primary),
      title: Text(title, style: TextStyle(fontSize: 16.sp, color: color)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
    );
  }
}
