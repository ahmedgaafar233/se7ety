import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';
import 'package:se7ty/features/home/presentation/manager/home_cubit.dart';

class PatientHomeBody extends StatefulWidget {
  const PatientHomeBody({super.key});

  @override
  State<PatientHomeBody> createState() => _PatientHomeBodyState();
}

class _PatientHomeBodyState extends State<PatientHomeBody> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getTopRatedDoctors(),
      child: SingleChildScrollView(
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
            color: const Color(0xFFE6EEF9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
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
          'مرحباً بك،',
          style: GoogleFonts.cairo(
            fontSize: 18.sp,
            color: AppColors.dark,
          ),
        ),
        Text(
          PrefsHelper.getUserName() ?? 'مريضنا العزيز',
          style: GoogleFonts.cairo(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EEF9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'ابحث عن طبيب...',
          hintStyle: GoogleFonts.cairo(fontSize: 14.sp, color: AppColors.grey),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        image: const DecorationImage(
          image: AssetImage('assets/images/logo.png'), // Replace with actual banner if available
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF4DB6AC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'احجز موعدك الآن\nمع أفضل الأطباء',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
          style: GoogleFonts.cairo(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'عرض الكل',
            style: GoogleFonts.cairo(color: AppColors.primary, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecializations() {
    final List<Map<String, dynamic>> specs = [
      {'icon': Icons.favorite, 'name': 'دكتور قلب', 'color': const Color(0xFFE1F5FE)},
      {'icon': Icons.medical_services, 'name': 'جراحة عامة', 'color': const Color(0xFFE8F5E9)},
      {'icon': Icons.child_care, 'name': 'أطفال', 'color': const Color(0xFFFFF3E0)},
      {'icon': Icons.visibility, 'name': 'عيون', 'color': const Color(0xFFF3E5F5)},
    ];

    return SizedBox(
      height: 160.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specs.length,
        separatorBuilder: (_, __) => Gap(15.w),
        itemBuilder: (context, index) {
          return Container(
            width: 110.w,
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              color: specs[index]['color'],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(specs[index]['icon'], color: AppColors.primary, size: 30.sp),
                ),
                Gap(15.h),
                Text(
                  specs[index]['name'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopDoctors() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeError) {
          return Center(child: Text(state.error));
        } else if (state is HomeSuccess) {
          if (state.doctors.isEmpty) {
            return Center(child: Text('لا يوجد أطباء متاحون حالياً', style: GoogleFonts.cairo()));
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.doctors.length,
            separatorBuilder: (_, __) => Gap(15.h),
            itemBuilder: (context, index) {
              final doctor = state.doctors[index];
              return Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: doctor.image != null
                          ? CachedNetworkImage(
                              imageUrl: doctor.image!,
                              width: 80.w,
                              height: 80.h,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey[200]),
                              errorWidget: (context, url, error) => const Icon(Icons.person),
                            )
                          : Container(
                              width: 80.w,
                              height: 80.h,
                              color: const Color(0xFFE6EEF9),
                              child: const Icon(Icons.person, color: AppColors.primary),
                            ),
                    ),
                    Gap(15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name ?? 'طبيب غير مسمى',
                            style: GoogleFonts.cairo(fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            doctor.specialization ?? 'تخصص عام',
                            style: GoogleFonts.cairo(fontSize: 14.sp, color: AppColors.grey),
                          ),
                          Gap(5.h),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18.sp),
                              Gap(5.w),
                              Text(
                                doctor.rating?.toString() ?? '0.0',
                                style: GoogleFonts.cairo(fontSize: 14.sp, fontWeight: FontWeight.bold),
                              ),
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
        return const SizedBox();
      },
    );
  }
}
