import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/widgets/dialogs.dart';

class DoctorProfileBody extends StatefulWidget {
  const DoctorProfileBody({super.key});

  @override
  State<DoctorProfileBody> createState() => _DoctorProfileBodyState();
}

class _DoctorProfileBodyState extends State<DoctorProfileBody> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('doctor')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الملف الشخصي',
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
        child: Column(
          children: [
            Gap(30.h),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundColor: AppColors.grey.withOpacity(0.1),
                    backgroundImage: (userData != null && userData!['image'] != null)
                        ? NetworkImage(userData!['image'])
                        : null,
                    child: (userData == null || userData!['image'] == null)
                        ? Icon(Icons.person, size: 60.sp, color: AppColors.primary)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18.r,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 18.sp),
                    ),
                  ),
                ],
              ),
            ),
            Gap(16.h),
            Text(
              userData?['name'] ?? 'جاري التحميل...',
              style: GoogleFonts.cairo(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              userData?['specialization'] ?? '',
              style: GoogleFonts.cairo(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            Gap(32.h),
            _buildProfileItem(Icons.person_outline, 'تعديل البيانات', () {
               context.push(Routes.doctorDetails);
            }),
            _buildProfileItem(Icons.lock_outline, 'تغيير كلمة المرور', () {}),
            _buildProfileItem(Icons.language, 'اللغة', () {}),
            _buildProfileItem(Icons.help_outline, 'مركز المساعدة', () {}),
            _buildProfileItem(Icons.logout, 'تسجيل الخروج', () {
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
            }, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap,
      {bool isLogout = false}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        Icons.arrow_back_ios_new,
        size: 16.sp,
        color: isLogout ? Colors.red : Colors.grey,
      ),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: GoogleFonts.cairo(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isLogout ? Colors.red : AppColors.dark,
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isLogout ? Colors.red.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: isLogout ? Colors.red : AppColors.primary,
          size: 20.sp,
        ),
      ),
    );
  }
}
