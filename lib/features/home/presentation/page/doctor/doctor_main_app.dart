import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:se7ty/features/home/presentation/widgets/doctor/doctor_home_body.dart';
import 'package:se7ty/features/home/presentation/widgets/doctor/doctor_appointments_body.dart';
import 'package:se7ty/features/home/presentation/widgets/doctor/doctor_profile_body.dart';

class DoctorMainApp extends StatefulWidget {
  const DoctorMainApp({super.key});

  @override
  State<DoctorMainApp> createState() => _DoctorMainAppState();
}

class _DoctorMainAppState extends State<DoctorMainApp> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DoctorHomeBody(),
    DoctorAppointmentsBody(),
    DoctorProfileBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: GNav(
            rippleColor: AppColors.primary.withOpacity(0.1),
            hoverColor: AppColors.primary.withOpacity(0.1),
            gap: 8,
            activeColor: AppColors.primary,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: AppColors.primary.withOpacity(0.1),
            color: AppColors.grey,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'الرئيسية',
              ),
              GButton(
                icon: Icons.calendar_month,
                text: 'المواعيد',
              ),
              GButton(
                icon: Icons.person,
                text: 'الحساب',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
