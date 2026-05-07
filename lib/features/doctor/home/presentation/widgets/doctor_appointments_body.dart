import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/features/appointments/data/model/appointment_model.dart';
import 'package:se7ty/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:se7ty/features/appointments/presentation/cubit/appointments_states.dart';

class DoctorAppointmentsBody extends StatefulWidget {
  const DoctorAppointmentsBody({super.key});

  @override
  State<DoctorAppointmentsBody> createState() => _DoctorAppointmentsBodyState();
}

class _DoctorAppointmentsBodyState extends State<DoctorAppointmentsBody> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    context.read<AppointmentsCubit>().getDoctorAppointments(user?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: BlocBuilder<AppointmentsCubit, AppointmentsStates>(
            builder: (context, state) {
              if (state is AppointmentsLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AppointmentsSuccessState) {
                if (state.appointments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, size: 80.sp, color: Colors.grey),
                        Gap(20.h),
                        Text(
                          'لا يوجد مواعيد محجوزة',
                          style: GoogleFonts.cairo(fontSize: 16.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: state.appointments.length,
                  padding: EdgeInsets.all(20.r),
                  separatorBuilder: (_, __) => Gap(16.h),
                  itemBuilder: (context, index) {
                    var appointment = AppointmentModel.fromJson(
                        state.appointments[index].data() as Map<String, dynamic>);
                    return _buildAppointmentCard(appointment);
                  },
                );
              } else if (state is AppointmentsErrorState) {
                return Center(child: Text(state.error));
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Center(
        child: Text(
          'جدول المواعيد',
          style: GoogleFonts.cairo(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppColors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                appointment.time ?? '',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  appointment.date ?? '',
                  style: GoogleFonts.cairo(
                    fontSize: 10.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                appointment.patientName ?? '',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              Row(
                children: [
                  Text(
                    'كشف',
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      color: AppColors.grey,
                    ),
                  ),
                  Gap(4.w),
                  Icon(Icons.history, size: 14, color: AppColors.grey),
                ],
              ),
            ],
          ),
          Gap(16.w),
          Container(
            width: 54.w,
            height: 54.h,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
