import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';

class PatientAppointmentsBody extends StatefulWidget {
  const PatientAppointmentsBody({super.key});

  @override
  State<PatientAppointmentsBody> createState() => _PatientAppointmentsBodyState();
}

class _PatientAppointmentsBodyState extends State<PatientAppointmentsBody> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'مواعيدي',
          style: GoogleFonts.cairo(
            color: AppColors.primary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              unselectedLabelColor: AppColors.grey,
              labelColor: Colors.white,
              labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14.sp),
              unselectedLabelStyle: GoogleFonts.cairo(fontSize: 14.sp),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'المواعيد القادمة'),
                Tab(text: 'المواعيد السابقة'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentList(isUpcoming: true),
                _buildAppointmentList(isUpcoming: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList({required bool isUpcoming}) {
    return ListView.separated(
      itemCount: 4,
      padding: EdgeInsets.all(20.r),
      separatorBuilder: (_, __) => Gap(15.h),
      itemBuilder: (context, index) {
        return _buildAppointmentCard(isUpcoming);
      },
    );
  }

  Widget _buildAppointmentCard(bool isUpcoming) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          Row(
            children: [
              Container(
                width: 65.w,
                height: 65.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EEF9),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: const Icon(Icons.person, color: AppColors.primary, size: 30),
              ),
              Gap(15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'د. أحمد محمود',
                      style: GoogleFonts.cairo(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'أخصائي طب وجراحة الأذن',
                      style: GoogleFonts.cairo(fontSize: 13.sp, color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              if (!isUpcoming)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'مكتمل',
                    style: GoogleFonts.cairo(color: Colors.green, fontSize: 11.sp, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          Gap(15.h),
          const Divider(thickness: 0.5, color: Color(0xFFF1F1F1)),
          Gap(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoRow(Icons.calendar_today_outlined, 'الاثنين 20 يناير'),
              _buildInfoRow(Icons.access_time, '10:00 صباحاً'),
            ],
          ),
          if (isUpcoming) ...[
            Gap(20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE6E6E6)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: Text(
                      'إلغاء الموعد',
                      style: GoogleFonts.cairo(color: Colors.red, fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Gap(15.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: Text(
                      'إعادة حجز',
                      style: GoogleFonts.cairo(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.primary),
        Gap(8.w),
        Text(
          text,
          style: GoogleFonts.cairo(fontSize: 12.sp, color: const Color(0xFF7E8CA0)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
