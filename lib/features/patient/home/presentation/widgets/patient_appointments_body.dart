import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/widgets/dialogs.dart';
import 'package:se7ty/features/appointments/data/model/appointment_model.dart';
import 'package:se7ty/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:se7ty/features/appointments/presentation/cubit/appointments_states.dart';

class PatientAppointmentsBody extends StatefulWidget {
  const PatientAppointmentsBody({super.key});

  @override
  State<PatientAppointmentsBody> createState() => _PatientAppointmentsBodyState();
}

class _PatientAppointmentsBodyState extends State<PatientAppointmentsBody> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    context.read<AppointmentsCubit>().getPatientAppointments(user?.uid ?? '');
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
          'مواعيد الحجز',
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
      body: BlocBuilder<AppointmentsCubit, AppointmentsStates>(
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
              separatorBuilder: (_, __) => Gap(20.h),
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
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 24.sp),
              Text(
                'د. ${appointment.doctorName}',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Gap(10.h),
          _buildInfoRow(Icons.calendar_month, appointment.date ?? ''),
          _buildInfoRow(Icons.access_time_filled, appointment.time ?? ''),
          _buildInfoRow(Icons.person, 'اسم المريض: ${appointment.patientName}'),
          _buildInfoRow(Icons.location_on, appointment.doctorAddress ?? ''),
          Gap(20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showConfirmationDialog(
                  context,
                  title: 'إلغاء الموعد',
                  content: 'هل أنت متأكد من رغبتك في إلغاء هذا الموعد؟',
                  okText: 'إلغاء الموعد',
                  onOk: () {
                    context.read<AppointmentsCubit>().deleteAppointment(appointment.appointmentId!);
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5252),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'حذف الحجز',
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              color: AppColors.dark,
            ),
          ),
          Gap(10.w),
          Icon(icon, size: 18.sp, color: AppColors.primary),
        ],
      ),
    );
  }
}
