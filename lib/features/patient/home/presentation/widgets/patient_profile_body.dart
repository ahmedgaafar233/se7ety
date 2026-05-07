import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/core/theme/app_colors.dart';
import 'package:se7ty/core/widgets/dialogs.dart';
import 'package:se7ty/features/appointments/data/model/appointment_model.dart';
import 'package:se7ty/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:se7ty/features/appointments/presentation/cubit/appointments_states.dart';

class PatientProfileBody extends StatefulWidget {
  const PatientProfileBody({super.key});

  @override
  State<PatientProfileBody> createState() => _PatientProfileBodyState();
}

class _PatientProfileBodyState extends State<PatientProfileBody> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    context.read<AppointmentsCubit>().getPatientAppointments(user?.uid ?? '');
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      FirebaseFirestore.instance
          .collection('patient')
          .doc(user!.uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists && mounted) {
          setState(() {
            userData = doc.data();
          });
        }
      });
    }
  }

  void _showSettingsModal() {
    context.push(Routes.settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: _showSettingsModal,
        ),
        title: Text(
          'الحساب الشخصي',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        userData?['name'] ?? 'جاري التحميل...',
                        style: GoogleFonts.cairo(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gap(8.h),
                      SizedBox(
                        width: double.infinity,
                        height: 40.h,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push(Routes.patientDetails);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'تعديل الحساب',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(20.w),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 45.r,
                      backgroundColor: AppColors.grey.withOpacity(0.1),
                      backgroundImage: (userData != null && userData!['image'] != null && userData!['image'] != '')
                          ? NetworkImage(userData!['image'])
                          : null,
                      child: (userData == null || userData!['image'] == null || userData!['image'] == '')
                          ? Icon(Icons.person, size: 45.sp, color: AppColors.primary)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 14.r,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 14.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(20.h),
            const Divider(),
            Gap(10.h),
            Text(
              'نبذه تعريفيه',
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            Gap(5.h),
            Text(
              (userData?['bio'] == null || userData?['bio'] == '')
                  ? 'لم تضاف'
                  : userData!['bio'],
              style: GoogleFonts.cairo(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
              textAlign: TextAlign.right,
            ),
            Gap(10.h),
            const Divider(),
            Gap(10.h),
            Text(
              'معلومات التواصل',
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            Gap(10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        user?.email ?? 'لم تضاف',
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          color: AppColors.dark,
                        ),
                      ),
                      Gap(10.w),
                      Icon(Icons.email, color: AppColors.primary, size: 20.sp),
                    ],
                  ),
                  Gap(12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        (userData?['phone'] == null || userData?['phone'] == '')
                            ? 'لم تضاف'
                            : userData!['phone'],
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          color: AppColors.dark,
                        ),
                      ),
                      Gap(10.w),
                      Icon(Icons.phone, color: AppColors.primary, size: 20.sp),
                    ],
                  ),
                ],
              ),
            ),
            Gap(10.h),
            const Divider(),
            Gap(10.h),
            Text(
              'حجوزاتي',
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            Gap(10.h),
            BlocBuilder<AppointmentsCubit, AppointmentsStates>(
              builder: (context, state) {
                if (state is AppointmentsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AppointmentsSuccessState) {
                  if (state.appointments.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Text(
                          'لا يوجد حجوزات حالياً',
                          style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14.sp),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.appointments.length,
                    separatorBuilder: (_, __) => Gap(16.h),
                    itemBuilder: (context, index) {
                      var appointment = AppointmentModel.fromJson(
                          state.appointments[index].data() as Map<String, dynamic>);
                      return _buildAppointmentCard(appointment);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
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
              Icon(Icons.keyboard_arrow_up, color: AppColors.primary, size: 24.sp),
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
