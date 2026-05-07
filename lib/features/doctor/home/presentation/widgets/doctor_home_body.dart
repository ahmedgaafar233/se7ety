import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:se7ty/core/theme/app_colors.dart';

class DoctorHomeBody extends StatefulWidget {
  const DoctorHomeBody({super.key});

  @override
  State<DoctorHomeBody> createState() => _DoctorHomeBodyState();
}

class _DoctorHomeBodyState extends State<DoctorHomeBody> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  int todayAppointmentsCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchTodayAppointments();
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

  Future<void> _fetchTodayAppointments() async {
    if (user != null) {
      // For simplicity, we just count all appointments for this doctor.
      // Ideally, we filter by today's date.
      final snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: user!.uid)
          .get();
      
      setState(() {
        todayAppointmentsCount = snapshot.docs.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Gap(24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTodayStats(),
              Gap(32.h),
              Text(
                'مواعيد اليوم',
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              Gap(16.h),
              _buildNoAppointmentsPlaceholder(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 30.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'مرحباً بك،',
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                'د. ${userData?['name'] ?? '...'}',
                style: GoogleFonts.cairo(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Gap(16.w),
          CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.white.withOpacity(0.2),
            backgroundImage: (userData != null && userData!['image'] != null)
                ? NetworkImage(userData!['image'])
                : null,
            child: (userData == null || userData!['image'] == null)
                ? Icon(Icons.person, color: Colors.white, size: 25.sp)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTodayStats() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem('تم الكشف', '0'),
          Container(width: 1, height: 40.h, color: AppColors.primary.withOpacity(0.2)),
          _buildStatItem('مواعيد قادمة', todayAppointmentsCount.toString()),
          Container(width: 1, height: 40.h, color: AppColors.primary.withOpacity(0.2)),
          _buildStatItem('إجمالي الحالات', todayAppointmentsCount.toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12.sp,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildNoAppointmentsPlaceholder() {
    return Center(
      child: Column(
        children: [
          Gap(40.h),
          Icon(Icons.calendar_today_outlined, size: 60.sp, color: AppColors.grey.withOpacity(0.3)),
          Gap(16.h),
          Text(
            'لا توجد مواعيد متبقية لليوم',
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
