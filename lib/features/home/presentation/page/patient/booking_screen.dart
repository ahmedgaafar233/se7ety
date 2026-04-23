import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/widgets/custom_text_form_field.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final DoctorModel doctor;

  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedTime;

  final List<String> _timeSlots = [
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.dark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
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
        centerTitle: true,
        title: Text(
          'احجز مع دكتورك',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 100.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildDoctorBrief(),
                  Gap(20.h),
                  Center(
                    child: Text(
                      '-- ادخل بيانات الحجز --',
                      style: GoogleFonts.cairo(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Gap(20.h),
                  _buildLabel('اسم المريض'),
                  Gap(8.h),
                  CustomTextFormField(
                    controller: _nameController,
                    hintText: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال اسم المريض';
                      }
                      return null;
                    },
                  ),
                  Gap(16.h),
                  _buildLabel('رقم الهاتف'),
                  Gap(8.h),
                  CustomTextFormField(
                    controller: _phoneController,
                    hintText: '',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال رقم الهاتف';
                      }
                      return null;
                    },
                  ),
                  Gap(16.h),
                  _buildLabel('وصف الحالة'),
                  Gap(8.h),
                  CustomTextFormField(
                    controller: _descController,
                    hintText: '',
                    maxLines: 4,
                  ),
                  Gap(24.h),
                  _buildLabel('تاريخ الحجز'),
                  Gap(8.h),
                  InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(15.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.calendar_month, color: AppColors.primary),
                          Text(
                            _selectedDate == null
                                ? 'اختر تاريخ الحجز'
                                : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                            style: GoogleFonts.cairo(
                              fontSize: 14.sp,
                              color: _selectedDate == null ? AppColors.grey : AppColors.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(24.h),
                  _buildLabel('وقت الحجز'),
                  Gap(12.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    alignment: WrapAlignment.end,
                    children: _timeSlots.map((time) {
                      final isSelected = _selectedTime == time;
                      return ChoiceChip(
                        label: Text(
                          time,
                          style: GoogleFonts.cairo(
                            color: isSelected ? Colors.white : AppColors.dark,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        onSelected: (selected) {
                          setState(() {
                            _selectedTime = selected ? time : null;
                          });
                        },
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Book Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedDate == null || _selectedTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'يرجى اختيار التاريخ والوقت',
                              style: GoogleFonts.cairo(),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      // TODO: Implement actual booking logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تم الحجز بنجاح',
                            style: GoogleFonts.cairo(),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      context.pop();
                      context.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'تأكيد الحجز',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorBrief() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'د. ${widget.doctor.name ?? ''}',
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  widget.doctor.specialization ?? '',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    color: AppColors.grey,
                  ),
                ),
                Gap(4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${widget.doctor.rating ?? 0}',
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(4.w),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
              ],
            ),
          ),
          Gap(16.w),
          CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: (widget.doctor.image != null && widget.doctor.image!.isNotEmpty)
                ? NetworkImage(widget.doctor.image!)
                : null,
            child: (widget.doctor.image == null || widget.doctor.image!.isEmpty)
                ? Icon(Icons.person, size: 30.sp, color: AppColors.primary)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.dark,
      ),
    );
  }
}
