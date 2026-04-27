import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';
import 'package:se7ty/features/home/presentation/manager/home_cubit.dart';
import 'package:se7ty/features/home/presentation/page/patient/specialization_doctors_screen.dart';

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
        Icon(Icons.notifications_active_outlined, color: AppColors.dark, size: 24.sp),
        Text(
          'صحتي',
          style: GoogleFonts.cairo(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        const SizedBox(width: 24), // Spacer for centering
      ],
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'مرحباً، ${PrefsHelper.getUserName() ?? 'سيد عبد العزيز'}',
            style: GoogleFonts.cairo(
              fontSize: 16.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(5.h),
          Text(
            'احجز الآن وكن جزءًا من رحلتك\nالصحية.',
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'ابحث عن دكتور',
          hintStyle: GoogleFonts.cairo(fontSize: 14.sp, color: AppColors.grey),
          border: InputBorder.none,
          prefixIcon: Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return const SizedBox.shrink();
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSpecializations() {
    final List<Map<String, dynamic>> specs = [
      {'name': 'دكتور قلب', 'color': const Color(0xFF4DB6AC)},
      {'name': 'جراحة عامة', 'color': const Color(0xFF42A5F5)},
      {'name': 'أطفال', 'color': const Color(0xFFFF8A65)},
      {'name': 'عيون', 'color': const Color(0xFF9575CD)},
    ];

    return SizedBox(
      height: 170.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specs.length,
        separatorBuilder: (_, __) => Gap(15.w),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpecializationDoctorsScreen(
                    specialization: specs[index]['name'],
                    doctors: [], // In a real app, this would be filtered
                  ),
                ),
              );
            },
            child: Container(
              width: 130.w,
              decoration: BoxDecoration(
                color: specs[index]['color'],
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    left: 10,
                    bottom: 40,
                    child: Image.asset(
                      'assets/images/logo.png', // Fallback if no specific illustration
                      opacity: const AlwaysStoppedAnimation(0.5),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Text(
                        specs[index]['name'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
