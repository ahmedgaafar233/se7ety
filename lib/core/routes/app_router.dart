import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ty/core/routes/routes.dart';
import 'package:se7ty/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:se7ty/features/auth/presentation/page/login_screen.dart';
import 'package:se7ty/features/auth/presentation/page/register_screen.dart';
import 'package:se7ty/features/auth/presentation/role_view.dart';
import 'package:se7ty/features/onboarding/presentation/onboarding_view.dart';
import 'package:se7ty/features/onboarding/presentation/splash_view.dart';
import 'package:se7ty/features/home/presentation/page/patient/patient_main_app.dart';
import 'package:se7ty/features/auth/presentation/page/doctor_registration_screen.dart';
import 'package:se7ty/features/home/presentation/page/doctor/doctor_main_app.dart';
import 'package:se7ty/features/home/presentation/page/patient/doctor_profile_screen.dart';
import 'package:se7ty/features/home/presentation/page/patient/booking_screen.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const RoleView(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: LoginScreen(isDoctor: state.extra as bool),
        ),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: RegisterScreen(isDoctor: state.extra as bool),
        ),
      ),
      GoRoute(
        path: Routes.patientMainApp,
        builder: (context, state) => const PatientMainApp(),
      ),
      GoRoute(
        path: Routes.doctorUpdateProfile,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: const DoctorRegistrationScreen(),
        ),
      ),
      GoRoute(
        path: Routes.doctorMainApp,
        builder: (context, state) => const DoctorMainApp(),
      ),
      GoRoute(
        path: Routes.doctorProfile,
        builder: (context, state) => DoctorProfileScreen(doctor: state.extra as DoctorModel),
      ),
      GoRoute(
        path: Routes.booking,
        builder: (context, state) => BookingScreen(doctor: state.extra as DoctorModel),
      ),
    ],
  );
}
