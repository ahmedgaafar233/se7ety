import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DoctorModel> _allDoctors = [];
  List<DoctorModel> _filteredDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    final snapshot = await FirebaseFirestore.instance.collection('doctor').get();
    final doctors = snapshot.docs
        .map((doc) => DoctorModel.fromJson(doc.data()))
        .toList();
    setState(() {
      _allDoctors = doctors;
      _filteredDoctors = doctors;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredDoctors = _allDoctors
          .where((doctor) =>
              doctor.name!.toLowerCase().contains(query.toLowerCase()) ||
              doctor.specialization!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ابحث عن طبيب',
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
          Gap(20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث عن طبيب أو تخصص...',
                hintStyle: GoogleFonts.cairo(fontSize: 14.sp, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: const Color(0xFFF8FAFD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Gap(20.h),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredDoctors.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        itemCount: _filteredDoctors.length,
                        separatorBuilder: (_, __) => Gap(16.h),
                        itemBuilder: (context, index) {
                          return _buildDoctorCard(_filteredDoctors[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80.sp, color: Colors.grey.withOpacity(0.3)),
          Gap(16.h),
          Text(
            'لا توجد نتائج بحث',
            style: GoogleFonts.cairo(fontSize: 16.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModel doctor) {
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
