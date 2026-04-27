import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/utils/prefs_helper.dart';
import 'package:se7ty/core/widgets/dialogs.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';
import 'package:se7ty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:se7ty/features/auth/presentation/cubit/auth_states.dart';

class DoctorRegistrationScreen extends StatefulWidget {
  const DoctorRegistrationScreen({super.key});

  @override
  State<DoctorRegistrationScreen> createState() => _DoctorRegistrationScreenState();
}

class _DoctorRegistrationScreenState extends State<DoctorRegistrationScreen> {
  final _bioController = TextEditingController();
  final _addressController = TextEditingController();
  final _phone1Controller = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _openHourController = TextEditingController();
  final _closeHourController = TextEditingController();
  
  String? _specialization;
  File? _image;
  final _formKey = GlobalKey<FormState>();

  final List<String> _specializations = [
    'دكتور قلب',
    'جراحة عامة',
    'جلدية',
    'نساء وتوليد',
    'أطفال',
    'أسنان',
    'عظام',
    'مخ وأعصاب',
  ];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          showLoadingDialog(context);
        } else if (state is AuthSuccessState) {
          PrefsHelper.setIsProfileCompleted(true);
          context.pop();
          context.go(Routes.doctorMainApp);
        } else if (state is AuthErrorState) {
          context.pop();
          showMyDialog(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'إكمال عملية التسجيل',
            style: GoogleFonts.cairo(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(20.h),
                _buildImagePicker(),
                Gap(30.h),
                _buildDropdown(),
                Gap(20.h),
                _buildTextField(_bioController, 'نبذة تعريفية', maxLines: 3),
                Gap(20.h),
                _buildTextField(_addressController, 'عنوان العيادة'),
                Gap(20.h),
                _buildWorkingHours(),
                Gap(20.h),
                _buildTextField(_phone1Controller, 'رقم الهاتف 1', keyboardType: TextInputType.phone),
                Gap(20.h),
                _buildTextField(_phone2Controller, 'رقم الهاتف 2 (اختياري)', keyboardType: TextInputType.phone, isRequired: false),
                Gap(40.h),
                _buildSubmitButton(),
                Gap(30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60.r,
            backgroundColor: const Color(0xFFF8FAFD),
            backgroundImage: _image != null ? FileImage(_image!) : null,
            child: _image == null
                ? Icon(Icons.person_outline, size: 50.sp, color: AppColors.primary)
                : null,
          ),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.camera_alt_outlined, size: 18.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _specialization,
      alignment: Alignment.centerRight,
      icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
      decoration: _inputDecoration('التخصص'),
      items: _specializations.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          alignment: Alignment.centerRight,
          child: Text(value, style: GoogleFonts.cairo()),
        );
      }).toList(),
      onChanged: (newValue) => setState(() => _specialization = newValue),
      validator: (value) => value == null ? 'يرجى اختيار التخصص' : null,
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1, TextInputType keyboardType = TextInputType.text, bool isRequired = true}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textAlign: TextAlign.right,
      keyboardType: keyboardType,
      style: GoogleFonts.cairo(fontSize: 15.sp),
      decoration: _inputDecoration(hint),
      validator: (value) => (isRequired && (value == null || value.isEmpty)) ? 'هذا الحقل مطلوب' : null,
    );
  }

  Widget _buildWorkingHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'ساعات العمل:',
          style: GoogleFonts.cairo(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.dark),
        ),
        Gap(10.h),
        Row(
          children: [
            Expanded(child: _buildTextField(_closeHourController, 'إلى (مثلاً 8)')),
            Gap(15.w),
            Expanded(child: _buildTextField(_openHourController, 'من (مثلاً 10)')),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final doctor = DoctorModel(
              uid: FirebaseAuth.instance.currentUser!.uid,
              name: PrefsHelper.getUserName(),
              email: FirebaseAuth.instance.currentUser!.email,
              bio: _bioController.text,
              specialization: _specialization,
              address: _addressController.text,
              openHour: _openHourController.text,
              closeHour: _closeHourController.text,
              phone1: _phone1Controller.text,
              phone2: _phone2Controller.text,
              rating: 3,
            );
            context.read<AuthCubit>().updateDoctor(doctor, image: _image);
          }
        },
        child: Text(
          'إتمام التسجيل',
          style: GoogleFonts.cairo(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
