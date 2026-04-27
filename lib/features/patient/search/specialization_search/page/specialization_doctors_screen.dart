import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';

class SpecializationDoctorsScreen extends StatelessWidget {
  final String specialization;
  final List<DoctorModel> doctors; // For demo, or we could fetch here

  const SpecializationDoctorsScreen({
    super.key,
    required this.specialization,
    required this.doctors,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          specialization,
          style: GoogleFonts.cairo(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20.r),
        itemCount: doctors.length,
        separatorBuilder: (_, __) => Gap(16.h),
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return GestureDetector(
            onTap: () {
              context.push(Routes.doctorProfile, extra: doctor);
            },
            child: _buildDoctorCard(doctor),
          );
        },
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModel doctor) {
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
        border: Border.all(color: AppColors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${doctor.rating}',
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  Gap(4.w),
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                ],
              ),
              Gap(20.h),
              Icon(Icons.arrow_back_ios, size: 16.sp, color: AppColors.primary),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'د. ${doctor.name}',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              Text(
                doctor.specialization ?? '',
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          Gap(16.w),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: doctor.image != null
                ? CachedNetworkImage(
                    imageUrl: doctor.image!,
                    width: 70.w,
                    height: 70.h,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 70.w,
                    height: 70.h,
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
          ),
        ],
      ),
    );
  }
}
