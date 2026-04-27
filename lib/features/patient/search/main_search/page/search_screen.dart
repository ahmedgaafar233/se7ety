import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/services/firebase/firestore_provider.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String search = '';

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
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            // Search Bar
            Container(
              height: 55.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                textAlign: TextAlign.right,
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'ابحث...',
                  hintStyle: GoogleFonts.cairo(color: AppColors.grey, fontSize: 14.sp),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                ),
              ),
            ),
            Gap(20.h),
            // Search Results
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('doctor').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var docs = snapshot.data!.docs.where((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    var name = data['name'].toString().toLowerCase();
                    var specialization = data['specialization'].toString().toLowerCase();
                    return name.contains(search.toLowerCase()) || specialization.contains(search.toLowerCase());
                  }).toList();

                  if (docs.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/no_search.png', width: 200.w, errorBuilder: (c, e, s) => Icon(Icons.search_off, size: 100.sp, color: AppColors.grey)),
                        Gap(20.h),
                        Text(
                          'لا يوجد دكتور بهذا التخصص حالياً',
                          style: GoogleFonts.cairo(
                            fontSize: 16.sp,
                            color: AppColors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => Gap(15.h),
                    itemBuilder: (context, index) {
                      var doctor = DoctorModel.fromJson(docs[index].data() as Map<String, dynamic>);
                      return _buildDoctorCard(doctor);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModel doctor) {
    return GestureDetector(
      onTap: () {
        context.push(Routes.doctorProfile, extra: doctor);
      },
      child: Container(
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
            // Rating
            Column(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(
                  '${doctor.rating}',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
            Gap(15.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'د. ${doctor.name}',
                    style: GoogleFonts.cairo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    doctor.specialization ?? '',
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
            ),
            Gap(15.w),
            // Image
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                image: DecorationImage(
                  image: (doctor.image != null && doctor.image!.isNotEmpty)
                      ? NetworkImage(doctor.image!)
                      : const AssetImage('assets/images/logo.png') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
