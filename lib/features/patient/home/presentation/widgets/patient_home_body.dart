import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/services/firebase/firestore_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';
import 'specialists_list.dart';

class PatientHomeBody extends StatefulWidget {
  const PatientHomeBody({super.key});

  @override
  State<PatientHomeBody> createState() => _PatientHomeBodyState();
}

class _PatientHomeBodyState extends State<PatientHomeBody> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('patient')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Gap(30.h),
          _buildHeader(),
          Gap(16.h),
          _buildWelcomeText(),
          Gap(24.h),
          _buildSectionTitle('التخصصات'),
          Gap(16.h),
          const SpecialistsList(),
          Gap(32.h),
          _buildSectionTitle('الأعلى تقييماً'),
          Gap(16.h),
          const TopRatedDoctorList(),
          Gap(20.h),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.notifications_none, color: AppColors.dark, size: 28.sp),
        Text(
          'صحّتي',
          style: GoogleFonts.cairo(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        Gap(28.sp), // To balance the left icon
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'مرحباً، ${userData?['name'] ?? '...'}',
          style: GoogleFonts.cairo(
            fontSize: 16.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(8.h),
        Text(
          'احجز الآن وكن جزءًا من رحلتك الصحية.',
          style: GoogleFonts.cairo(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
            height: 1.4,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }



  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'عرض الكل',
          style: GoogleFonts.cairo(
            fontSize: 14.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
      ],
    );
  }
}

class TopRatedDoctorList extends StatelessWidget {
  const TopRatedDoctorList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseProvider.sortingDoctors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('لا يوجد أطباء متاحون'));
        }

        var doctors = snapshot.data!.docs
            .map((doc) => DoctorModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        return ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: doctors.length > 5 ? 5 : doctors.length,
          separatorBuilder: (context, index) => Gap(16.h),
          itemBuilder: (context, index) {
            return _buildDoctorCard(context, doctors[index]);
          },
        );
      },
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorModel doctor) {
    return InkWell(
      onTap: () {
        context.push(Routes.doctorProfile, extra: doctor);
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.primary),
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
                    fontSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${doctor.rating}',
                      style: GoogleFonts.cairo(fontSize: 12.sp, color: Colors.grey),
                    ),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
              ],
            ),
            Gap(16.w),
            CircleAvatar(
              radius: 35.r,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: doctor.image != null ? NetworkImage(doctor.image!) : null,
              child: doctor.image == null
                  ? Icon(Icons.person, size: 35.sp, color: AppColors.primary)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
