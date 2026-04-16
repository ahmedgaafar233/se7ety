import 'package:se7ty/features/auth/data/model/user_type_enum.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final UserTypeEnum userType;
  AuthSuccessState(this.userType);
}

class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState(this.error);
}
