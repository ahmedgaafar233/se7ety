import 'package:flutter_bloc/flutter_bloc.dart';
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
}
