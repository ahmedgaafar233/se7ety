import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';
import '../../data/model/auth_params.dart';
import '../../data/model/user_type_enum.dart';
import '../../data/repo/auth_repo.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  Future<void> login(UserTypeEnum userType, String email, String password) async {
    emit(AuthLoadingState());
    final result = await AuthRepo.login(email: email, password: password);
    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (success) => emit(AuthSuccessState(userType)),
    );
  }

  Future<void> register(UserTypeEnum userType, AuthParams params) async {
    emit(AuthLoadingState());
    
    final result = userType == UserTypeEnum.doctor
        ? await AuthRepo.registerDoctor(params)
        : await AuthRepo.registerPatient(params);

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (success) => emit(AuthSuccessState(userType)),
    );
  }

  Future<void> updateDoctor(DoctorModel doctor, {File? image}) async {
    emit(AuthLoadingState());
    try {
      if (image != null) {
        String? imageUrl = await AuthRepo.uploadImage(image);
        if (imageUrl != null) {
          doctor.image = imageUrl;
        }
      }
      final result = await AuthRepo.updateDoctorProfile(doctor);
      result.fold(
        (failure) => emit(AuthErrorState(failure.message)),
        (success) => emit(AuthSuccessState(UserTypeEnum.doctor)),
      );
    } catch (e) {
      emit(AuthErrorState('حدث خطأ أثناء رفع الصورة.'));
    }
  }
}
