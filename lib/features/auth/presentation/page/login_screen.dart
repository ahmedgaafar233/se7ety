import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:se7ty/core/functions/navigation.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/widgets/dialogs.dart';
import 'package:se7ty/features/auth/data/model/user_type_enum.dart';
import 'package:se7ty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:se7ty/features/auth/presentation/cubit/auth_states.dart';
import 'package:se7ty/features/home/presentation/page/doctor/doctor_main_app.dart';
import 'package:se7ty/features/home/presentation/page/patient/patient_main_app.dart';

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
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            showLoadingDialog(context);
          } else if (state is AuthSuccessState) {
            if (state.userType == UserTypeEnum.patient) {
              pushAndRemoveUntil(context, const PatientMainApp());
            } else {
              pushAndRemoveUntil(context, const DoctorMainApp());
            }
          } else if (state is AuthErrorState) {
            pop(context);
            showMyDialog(context, state.error);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Gap(20.h),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 120.w,
                    ),
                  ),
                  Gap(30.h),
                  Text(
                    "سجل دخول الآن كـ '${widget.isDoctor ? 'دكتور' : 'مريض'}'",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Gap(40.h),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Sayed@example.com',
                      prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                      filled: true,
                      fillColor: AppColors.accent.withAlpha(50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال البريد الإلكتروني';
                      }
                      return null;
                    },
                  ),
                  Gap(20.h),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: AppColors.accent.withAlpha(50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال كلمة المرور';
                      }
                      return null;
                    },
                  ),
                  Gap(10.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'نسيت كلمة السر؟',
                        style: TextStyle(color: AppColors.grey, fontSize: 13.sp),
                      ),
                    ),
                  ),
                  Gap(30.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
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
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Gap(20.h),
                  const Text('أو عبر', style: TextStyle(color: Colors.grey)),
                  Gap(20.h),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.login, color: Colors.blue),
                    label: const Text('Google', style: TextStyle(color: Colors.black87)),
                  ),
                  Gap(30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ليس لدي حساب؟'),
                      TextButton(
                        onPressed: () {
                          // No direct pushTo here yet, but we can align it later
                          Navigator.pushNamed(
                            context,
                            '/register',
                            arguments: widget.isDoctor,
                          );
                        },
                        child: const Text(
                          'سجل الآن',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
