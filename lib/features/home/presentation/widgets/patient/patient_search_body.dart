import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:se7ty/core/theme/app_colors.dart';

class PatientSearchBody extends StatelessWidget {
  const PatientSearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Gap(20.h),
                _buildSearchField(),
                Gap(20.h),
                _buildFilterChips(),
                Gap(20.h),
                Expanded(
                  child: _buildSearchResults(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Center(
        child: Text(
          'ابحث عن دكتور',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.searchBackground,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'عن ماذا تبحث؟',
          hintStyle: TextStyle(color: AppColors.grey),
          border: InputBorder.none,
          suffixIcon: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final List<String> filters = ['الكل', 'القلب', 'العيون', 'الأسنان', 'الأطفال'];
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => Gap(10.w),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.searchBackground,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Text(
              filters[index],
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.primary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.separated(
      itemCount: 5,
      padding: EdgeInsets.only(bottom: 20.h),
      separatorBuilder: (_, __) => Gap(15.h),
      itemBuilder: (context, index) {
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
          child: Row(
            children: [
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: const Icon(Icons.person, color: AppColors.primary, size: 30),
              ),
              Gap(15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'د. سارة أحمد',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'أخصائية طب العيون',
                      style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                    ),
                    Gap(5.h),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Gap(5.w),
                        Text('4.9 (120 تقييم)', style: TextStyle(fontSize: 12.sp, color: AppColors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
            ],
          ),
        );
      },
    );
  }
}
