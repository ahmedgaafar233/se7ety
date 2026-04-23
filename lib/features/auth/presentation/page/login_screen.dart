import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/widgets/dialogs.dart';
import 'package:se7ty/features/auth/data/model/user_type_enum.dart';
import 'package:se7ty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:se7ty/features/auth/presentation/cubit/auth_states.dart';


class LoginScreen extends StatefulWidget {
  final bool isDoctor;
  const LoginScreen({super.key, required this.isDoctor});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          showLoadingDialog(context);
        } else if (state is AuthSuccessState) {
          Navigator.of(context).pop(); // dismiss dialog
          if (state.userType == UserTypeEnum.patient) {
            context.go(Routes.patientMainApp);
          } else {
            context.go(Routes.doctorUpdateProfile);
          }
        } else if (state is AuthErrorState) {
          Navigator.of(context).pop(); // dismiss dialog
          showMyDialog(context, state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20.sp),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(Routes.welcome);
                }
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Gap(10.h),
                  Center(
                    child: Image.asset(
                      'assets/images/se7ty_logo.png',
                      width: 180.w,
                    ),
                  ),
                  Gap(20.h),
                  Text(
                    'سجل دخول الآن كـ "${widget.isDoctor ? 'دكتور' : 'مريض'}"',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(
                      fontSize: 20.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(40.h),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'Sayed@example.com',
                      hintStyle: GoogleFonts.cairo(color: AppColors.grey.withOpacity(0.5), fontSize: 14.sp),
                      suffixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFD),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                      return null;
                    },
                  ),
                  Gap(20.h),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'كلمة المرور',
                      hintStyle: GoogleFonts.cairo(color: AppColors.grey.withOpacity(0.5), fontSize: 14.sp),
                      prefixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      suffixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFD),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
                      return null;
                    },
                  ),
                  Gap(10.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'نسيت كلمة السر؟',
                      style: GoogleFonts.cairo(
                        color: AppColors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Gap(30.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().login(
                                widget.isDoctor ? UserTypeEnum.doctor : UserTypeEnum.patient,
                                _emailController.text,
                                _passwordController.text,
                              );
                        }
                      },
                      child: Text(
                        'تسجيل الدخول',
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.cairo(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Gap(20.h),
                  Text(
                    'أو عبر',
                    style: GoogleFonts.cairo(color: AppColors.grey, fontSize: 14.sp),
                  ),
                  Gap(15.h),
                  GestureDetector(
                    onTap: () {
                      // Google Login Logic
                    },
                    child: Container(
                      width: 160.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Google',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ليس لدي حساب؟ ',
                        style: GoogleFonts.cairo(fontSize: 14.sp, color: AppColors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushReplacement(Routes.register, extra: widget.isDoctor);
                        },
                        child: Text(
                          'سجل الآن',
                          style: GoogleFonts.cairo(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
