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
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: const Color(0xFFE6EEF9),
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(Icons.camera_alt_outlined, size: 40.sp, color: AppColors.primary)
                          : null,
                    ),
                  ),
                  Gap(30.h),
                  DropdownButtonFormField<String>(
                    value: _specialization,
                    decoration: InputDecoration(
                      hintText: 'التخصص',
                      hintStyle: GoogleFonts.cairo(color: AppColors.grey.withOpacity(0.5)),
                      filled: true,
                      fillColor: const Color(0xFFE6EEF9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _specializations.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _specialization = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'يرجى اختيار التخصص' : null,
                  ),
                  Gap(20.h),
                  TextFormField(
                    controller: _bioController,
                    maxLines: 3,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'نبذة تعريفية',
                      hintStyle: GoogleFonts.cairo(color: AppColors.grey.withOpacity(0.5)),
                      filled: true,
                      fillColor: const Color(0xFFE6EEF9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'يرجى كتابة نبذة تعريفية' : null,
                  ),
                  Gap(20.h),
                  TextFormField(
                    controller: _addressController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'عنوان العيادة',
                      hintStyle: GoogleFonts.cairo(color: AppColors.grey.withOpacity(0.5)),
                      filled: true,
                      fillColor: const Color(0xFFE6EEF9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'يرجى إدخال عنوان العيادة' : null,
                  ),
                  Gap(20.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _closeHourController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'إلى',
                            hintStyle: GoogleFonts.cairo(color: AppColors.grey.withOpacity(0.5)),
                            prefixIcon: Icon(Icons.access_time, color: AppColors.primary),
                            filled: true,
                            fillColor: const Color(0xFFE6EEF9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: TextFormField(
                          controller: _openHourController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'من',
                            hintStyle: GoogleFonts.cairo(color: AppColors.grey.withOpacity(0.5)),
                            prefixIcon: Icon(Icons.access_time, color: AppColors.primary),
                            filled: true,
                            fillColor: const Color(0xFFE6EEF9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                        ),
                      ),
                      Gap(10.w),
                      Text('ساعات العمل:', style: GoogleFonts.cairo()),
                    ],
                  ),
                  Gap(20.h),
                  TextFormField(
                    controller: _phone1Controller,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'رقم الهاتف 1',
                      hintStyle: GoogleFonts.cairo(color: AppColors.grey.withOpacity(0.5)),
                      filled: true,
                      fillColor: const Color(0xFFE6EEF9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
                  ),
                  Gap(20.h),
                  TextFormField(
                    controller: _phone2Controller,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'رقم الهاتف 2 (اختياري)',
                      hintStyle: GoogleFonts.cairo(color: AppColors.grey.withOpacity(0.5)),
                      filled: true,
                      fillColor: const Color(0xFFE6EEF9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  Gap(30.h),
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: Builder(
                      builder: (context) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final doctor = DoctorModel(
                                uid: FirebaseAuth.instance.currentUser!.uid,
                                bio: _bioController.text,
                                specialization: _specialization,
                                address: _addressController.text,
                                openHour: _openHourController.text,
                                closeHour: _closeHourController.text,
                                phone1: _phone1Controller.text,
                                phone2: _phone2Controller.text,
                                rating: 3, // Initial rating
                              );
                              context.read<AuthCubit>().updateDoctor(doctor, image: _image);
                            }
                          },
                          child: Text(
                            'التسجيل',
                            style: GoogleFonts.cairo(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                  Gap(30.h),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
