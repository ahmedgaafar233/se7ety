import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/features/patient/home/presentation/widgets/patient_home_body.dart';
import 'package:se7ty/features/patient/search/main_search/page/search_screen.dart';
import 'package:se7ty/features/patient/home/presentation/widgets/patient_appointments_body.dart';
import 'package:se7ty/features/patient/home/presentation/widgets/patient_profile_body.dart';

class PatientMainApp extends StatefulWidget {
  const PatientMainApp({super.key});

  @override
  State<PatientMainApp> createState() => _PatientMainAppState();
}

class _PatientMainAppState extends State<PatientMainApp> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    PatientHomeBody(),
    SearchScreen(),
    PatientAppointmentsBody(),
    PatientProfileBody(),
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
            rippleColor: Colors.grey.withOpacity(0.1),
            hoverColor: Colors.grey.withOpacity(0.1),
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: AppColors.primary,
            textStyle: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            color: AppColors.grey,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'الرئيسية',
              ),
              GButton(
                icon: Icons.search,
                text: 'البحث',
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
