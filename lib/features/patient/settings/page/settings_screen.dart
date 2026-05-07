import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/widgets/dialogs.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ],
        title: Text(
          'الاعدادات',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            Gap(10.h),
            _buildSettingItem(Icons.person, 'إعدادات الحساب', () {
              context.push(Routes.patientDetails);
            }),
            _buildSettingItem(Icons.security, 'كلمة السر', () {}),
            _buildSettingItem(Icons.notifications_active, 'إعدادات الاشعارات', () {}),
            _buildSettingItem(Icons.privacy_tip, 'الخصوصية', () {}),
            _buildSettingItem(Icons.help_outline, 'المساعدة والدعم', () {}),
            _buildSettingItem(Icons.person_add_alt_1, 'دعوة صديق', () {}),
            Gap(40.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showConfirmationDialog(
                    context,
                    title: 'تسجيل الخروج',
                    content: 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                    okText: 'خروج',
                    onOk: () {
                      FirebaseAuth.instance.signOut();
                      context.pushReplacement(Routes.welcome);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4B6B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  'تسجيل خروج',
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Icon(
          Icons.arrow_back_ios_new,
          size: 16.sp,
          color: AppColors.dark,
        ),
        title: Text(
          title,
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.dark,
          ),
        ),
        trailing: Icon(
          icon,
          color: AppColors.dark,
          size: 22.sp,
        ),
      ),
    );
  }
}
