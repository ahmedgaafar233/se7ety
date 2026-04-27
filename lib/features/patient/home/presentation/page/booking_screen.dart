import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final DoctorModel doctor;

  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;

  final List<String> _timeSlots = [
    '10:00 ص', '11:00 ص', '12:00 م',
    '01:00 م', '02:00 م', '03:00 م',
    '04:00 م', '05:00 م', '06:00 م',
    '07:00 م', '08:00 م', '09:00 م',
  ];

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
          'حجز موعد',
          style: GoogleFonts.cairo(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildDoctorSummary(),
                Gap(24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildSectionTitle('اختر التاريخ'),
                      Gap(16.h),
                      _buildDateSelector(),
                      Gap(32.h),
                      _buildSectionTitle('اختر الوقت'),
                      Gap(16.h),
                      _buildTimeGrid(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildConfirmButton(context),
        ],
      ),
    );
  }

  Widget _buildDoctorSummary() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'د. ${widget.doctor.name}',
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  widget.doctor.specialization ?? '',
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Gap(12.w),
          CircleAvatar(
            radius: 25.r,
            backgroundImage: (widget.doctor.image != null && widget.doctor.image!.isNotEmpty)
                ? NetworkImage(widget.doctor.image!)
                : const AssetImage('assets/images/logo.png') as ImageProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.dark,
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 90.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true, // For RTL
        itemCount: 14,
        separatorBuilder: (_, __) => Gap(12.w),
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = DateUtils.isSameDay(date, _selectedDate);
          
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 70.w,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey.withOpacity(0.1),
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ] : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E', 'ar').format(date),
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      color: isSelected ? Colors.white : AppColors.grey,
                    ),
                  ),
                  Text(
                    DateFormat('d').format(date),
                    style: GoogleFonts.cairo(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.dark,
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

  Widget _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 2.2,
      ),
      itemCount: _timeSlots.length,
      itemBuilder: (context, index) {
        final time = _timeSlots[index];
        final isSelected = _selectedTime == time;

        return GestureDetector(
          onTap: () => setState(() => _selectedTime = time),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.grey.withOpacity(0.1),
              ),
            ),
            child: Text(
              time,
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.dark,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              elevation: 0,
            ),
            onPressed: () {
              if (_selectedTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('يرجى اختيار الوقت', textAlign: TextAlign.center, style: GoogleFonts.cairo()),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              // TODO: Logic for booking
              _showSuccessDialog(context);
            },
            child: Text(
              'تأكيد الحجز',
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(10.h),
            Icon(Icons.check_circle, color: AppColors.primary, size: 80.sp),
            Gap(20.h),
            Text(
              'تم الحجز بنجاح!',
              style: GoogleFonts.cairo(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            Gap(10.h),
            Text(
              'يمكنك مراجعة مواعيدك في صفحة المواعيد',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 14.sp,
                color: AppColors.grey,
              ),
            ),
            Gap(30.h),
            SizedBox(
              width: double.infinity,
              height: 45.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                onPressed: () {
                  context.pop(); // close dialog
                  context.pop(); // back to profile
                  context.pop(); // back to home
                },
                child: Text('حسناً', style: GoogleFonts.cairo(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
