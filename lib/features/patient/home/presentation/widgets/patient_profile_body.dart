import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';

class PatientProfileBody extends StatelessWidget {
  const PatientProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: Icon(Icons.settings, color: Colors.white, size: 24.sp),
        title: Text(
          'الحساب الشخصي',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildProfileHeader(),
            Gap(30.h),
            _buildBioSection(),
            Gap(30.h),
            _buildContactInfo(),
            Gap(30.h),
             Gap(30.h),
            _buildMyBookingsHeader(),
            Gap(30.h),
            _buildLogoutButton(context),
            Gap(40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          PrefsHelper.logout();
          context.go(Routes.welcome);
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: Text(
          'تسجيل الخروج',
          style: GoogleFonts.cairo(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 45.r,
              backgroundColor: const Color(0xFFE6EEF9),
              child: const Icon(Icons.person, color: AppColors.primary, size: 50),
            ),
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.camera_alt, color: AppColors.dark, size: 16.sp),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              PrefsHelper.getUserName() ?? 'سيد عبد العزيز',
              style: GoogleFonts.cairo(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Gap(10.h),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              ),
              child: Text(
                'تعديل الحساب',
                style: GoogleFonts.cairo(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'نبذه تعريفيه',
          style: GoogleFonts.cairo(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        Gap(10.h),
        Text(
          'لم تضاف',
          style: GoogleFonts.cairo(
            fontSize: 14.sp,
            color: AppColors.grey,
          ),
        ),
        const Divider(height: 30),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'معلومات التواصل',
          style: GoogleFonts.cairo(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        Gap(15.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
            color: const Color(0xFFE6EEF9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildContactRow(Icons.email_outlined, 'sayed22@gmail.com'),
              Gap(15.h),
              _buildContactRow(Icons.phone, 'لم تضاف'),
            ],
          ),
        ),
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
        Gap(15.w),
        Container(
          padding: EdgeInsets.all(5.r),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: Colors.white, size: 20.sp),
        ),
      ],
    );
  }

  Widget _buildMyBookingsHeader() {
    return Text(
      'حجوزاتي',
      style: GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.dark,
      ),
    );
  }
}
