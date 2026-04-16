import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';

class PatientHomeBody extends StatelessWidget {
  const PatientHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20.h),
            _buildHeader(context),
            Gap(20.h),
            _buildWelcomeText(context),
            Gap(20.h),
            _buildSearchBar(),
            Gap(25.h),
            _buildBanner(),
            Gap(25.h),
            _buildSectionHeader('التخصصات'),
            Gap(15.h),
            _buildSpecializations(),
            Gap(25.h),
            _buildSectionHeader('الأعلى تقييماً'),
            Gap(15.h),
            _buildTopDoctors(),
            Gap(20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.searchBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Icon(Icons.notifications_none_rounded, color: AppColors.dark),
        ),
        Image.asset(
          'assets/images/logo.png',
          height: 40.h,
        ),
      ],
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحباً: ${PrefsHelper.getUserName() ?? 'مريضنا العزيز'}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
        Gap(5.h),
        Text(
          'احجز الآن وكن جزءاً من رحلتك الصحية',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.searchBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ابحث عن طبيب أو تخصص...',
          hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.grey),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'احجز موعدك الآن مع أفضل الأطباء',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10.h),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: const Text('احجز الآن'),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/logo.png', width: 80.w, color: Colors.white.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('عرض الكل', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _buildSpecializations() {
    final List<Map<String, dynamic>> specs = [
      {'icon': Icons.favorite, 'name': 'القلب'},
      {'icon': Icons.visibility, 'name': 'العيون'},
      {'icon': Icons.child_care, 'name': 'الأطفال'},
      {'icon': Icons.medical_services, 'name': 'أسنان'},
    ];

    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specs.length,
        separatorBuilder: (_, __) => Gap(15.w),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Icon(specs[index]['icon'], color: Colors.white),
              ),
              Gap(5.h),
              Text(specs[index]['name'], style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopDoctors() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => Gap(15.h),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
              Gap(15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'د. أحمد محمد',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'أخصائي جراحة القلب',
                      style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                    ),
                    Gap(5.h),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Gap(5.w),
                        Text('4.8', style: TextStyle(fontSize: 12.sp)),
                        const Spacer(),
                        const Icon(Icons.location_on, color: AppColors.primary, size: 14),
                        Gap(2.w),
                        Text('القاهرة', style: TextStyle(fontSize: 12.sp, color: AppColors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
