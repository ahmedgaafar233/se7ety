import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';

class PatientSearchBody extends StatefulWidget {
  const PatientSearchBody({super.key});

  @override
  State<PatientSearchBody> createState() => _PatientSearchBodyState();
}

class _PatientSearchBodyState extends State<PatientSearchBody> {
  int _selectedFilter = 0;
  final List<String> filters = ['الكل', 'دكتور قلب', 'جراحة عامة', 'أطفال', 'عيون', 'أسنان'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ابحث عن دكتور',
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
            child: Column(
              children: [
                _buildSearchField(),
                Gap(15.h),
                _buildFilterChips(),
              ],
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'عن ماذا تبحث؟',
          hintStyle: GoogleFonts.cairo(color: AppColors.grey, fontSize: 14.sp),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 45.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => Gap(10.w),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilter == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = index;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.1),
                ),
              ),
              child: Text(
                filters[index],
                style: GoogleFonts.cairo(
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.separated(
      itemCount: 8,
      padding: EdgeInsets.all(20.r),
      separatorBuilder: (_, __) => Gap(15.h),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFD),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Rating on the left
              Column(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16.sp),
                  Text(
                    '4', // Example rating
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
              Gap(15.w),
              // Name and Specialization
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'خالد علي عبدالله',
                      style: GoogleFonts.cairo(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'دكتور قلب',
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        color: AppColors.dark,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(15.w),
              // Image on the right
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EEF9),
                  borderRadius: BorderRadius.circular(10.r),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'), // Placeholder
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
