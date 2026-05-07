import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/services/firebase/firestore_provider.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/widgets/dialogs.dart';
import 'package:se7ty/features/appointments/data/model/appointment_model.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late List<String> _timeSlots;

  @override
  void initState() {
    super.initState();
    _timeSlots = _generateTimeSlots();
  }

  List<String> _generateTimeSlots() {
    int startHour = 10;
    int endHour = 20;

    if (widget.doctor.openHour != null) {
      startHour = _parseHour(widget.doctor.openHour!);
    }
    if (widget.doctor.closeHour != null) {
      endHour = _parseHour(widget.doctor.closeHour!);
    }

    if (endHour <= startHour) {
      endHour += 12;
    }

    List<String> slots = [];
    for (int i = startHour; i < endHour; i++) {
      int hour = i % 12 == 0 ? 12 : i % 12;
      String amPm = (i % 24) < 12 ? 'ص' : 'م';
      String formattedHour = hour.toString().padLeft(2, '0');
      slots.add('$formattedHour:00 $amPm');
    }
    
    if (slots.isEmpty) {
      return [
        '10:00 ص', '11:00 ص', '12:00 م',
        '01:00 م', '02:00 م', '03:00 م',
        '04:00 م', '05:00 م', '06:00 م',
        '07:00 م',
      ];
    }
    
    return slots;
  }

  int _parseHour(String timeString) {
    try {
      final lower = timeString.toLowerCase();
      final regex = RegExp(r'\d+');
      final match = regex.firstMatch(lower);
      if (match != null) {
        int hour = int.parse(match.group(0)!);
        if (lower.contains('pm') || lower.contains('م')) {
          if (hour < 12) hour += 12;
        } else if (lower.contains('am') || lower.contains('ص')) {
          if (hour == 12) hour = 0;
        }
        return hour;
      }
    } catch (e) {}
    return 10;
  }

  void _bookAppointment() {
    if (_formKey.currentState!.validate()) {
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى اختيار الوقت', textAlign: TextAlign.center, style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      final appointment = AppointmentModel(
        doctorId: widget.doctor.uid,
        doctorName: widget.doctor.name,
        doctorImage: widget.doctor.image,
        doctorSpecialization: widget.doctor.specialization,
        doctorAddress: widget.doctor.address,
        patientId: user?.uid,
        patientName: _nameController.text,
        patientPhone: _phoneController.text,
        patientDescription: _descriptionController.text,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        time: _selectedTime!,
        isCompleted: false,
      );

      showLoadingDialog(context);
      FirebaseProvider.bookAppointment(appointment).then((value) {
        context.pop(); // close loading
        _showSuccessDialog(context);
      }).catchError((error) {
        context.pop(); // close loading
        showMyDialog(context, 'حدث خطأ أثناء الحجز، يرجى المحاولة مرة أخرى');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'احجز مع دكتورك',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildDoctorSummary(),
                  Gap(24.h),
                  Center(
                    child: Text(
                      '-- ادخل بيانات الحجز --',
                      style: GoogleFonts.cairo(
                        color: AppColors.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Gap(20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildSectionTitle('اسم المريض'),
                        Gap(8.h),
                        _buildTextField(_nameController, 'اسم المريض'),
                        Gap(16.h),
                        
                        _buildSectionTitle('رقم الهاتف'),
                        Gap(8.h),
                        _buildTextField(_phoneController, 'رقم الهاتف', isPhone: true),
                        Gap(16.h),
                        
                        _buildSectionTitle('وصف الحاله'),
                        Gap(8.h),
                        _buildTextField(_descriptionController, 'وصف الحاله', maxLines: 4),
                        Gap(24.h),
                        
                        _buildSectionTitle('تاريخ الحجز'),
                        Gap(16.h),
                        _buildDateSelector(),
                        Gap(32.h),
                        _buildSectionTitle('وقت الحجز'),
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
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1, bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textAlign: TextAlign.right,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      style: GoogleFonts.cairo(fontSize: 15.sp),
      decoration: InputDecoration(
        hintStyle: GoogleFonts.cairo(color: AppColors.grey.withOpacity(0.5), fontSize: 14.sp),
        filled: true,
        fillColor: const Color(0xFFF8FAFD),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'يرجى إدخال $hint' : null,
    );
  }

  Widget _buildDoctorSummary() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(25.r),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: (widget.doctor.image != null && widget.doctor.image!.isNotEmpty)
                ? Image.network(widget.doctor.image!, width: 60.w, height: 60.h, fit: BoxFit.cover)
                : Image.asset('assets/images/logo.png', width: 60.w, height: 60.h),
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
        reverse: true,
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
                color: isSelected ? AppColors.primary : AppColors.lightBlue,
                borderRadius: BorderRadius.circular(20.r),
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
              color: isSelected ? AppColors.primary : AppColors.lightBlue,
              borderRadius: BorderRadius.circular(15.r),
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
              _bookAppointment();
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
