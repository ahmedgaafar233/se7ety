import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:se7ty/core/theme/app_colors.dart';

class PatientAppointmentsBody extends StatelessWidget {
  const PatientAppointmentsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Gap(20.h),
            _buildTabBar(),
            Gap(20.h),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAppointmentList(isUpcoming: true),
                  _buildAppointmentList(isUpcoming: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: TabBar(
        indicatorColor: AppColors.primary,
        indicatorPadding: EdgeInsets.symmetric(horizontal: 10.w),
        indicatorWeight: 3,
        unselectedLabelColor: AppColors.grey,
        labelColor: AppColors.primary,
        dividerColor: Colors.transparent,
        tabs: [
          _buildTab('المواعيد القادمة'),
          _buildTab('المواعيد السابقة'),
        ],
      ),
    );
  }

  Widget _buildTab(String title) {
    return Tab(
      child: Text(title, style: TextStyle(fontSize: 14.sp)),
    );
  }

  Widget _buildAppointmentList({required bool isUpcoming}) {
    return ListView.separated(
      itemCount: 3,
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Icon(Icons.person, color: AppColors.primary, size: 25),
              ),
              Gap(15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'د. أحمد محمود',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'أخصائي طب وجراحة الأذن',
                      style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              if (isUpcoming)
                const Icon(Icons.more_vert, color: AppColors.grey)
              else
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text('مكتمل', style: TextStyle(color: AppColors.primary, fontSize: 12.sp)),
                ),
            ],
          ),
          Gap(15.h),
          const Divider(thickness: 0.5),
          Gap(10.h),
          Row(
            children: [
              _buildInfoRow(Icons.calendar_today, 'الاثنين 20 يناير'),
              const Spacer(),
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
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: const Text('إلغاء الموعد', style: TextStyle(color: Colors.red)),
                  ),
                ),
                Gap(15.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: const Text('إعادة حجز', style: TextStyle(color: Colors.white)),
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
        Icon(icon, size: 16, color: AppColors.primary),
        Gap(8.w),
        Text(text, style: TextStyle(fontSize: 12.sp, color: AppColors.grey)),
      ],
    );
  }
}
