import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';
import 'package:se7ty/features/home/data/repo/home_repo.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeSuccess extends HomeState {
  final List<DoctorModel> doctors;
  HomeSuccess(this.doctors);
}
class HomeError extends HomeState {
  final String error;
  HomeError(this.error);
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> getTopRatedDoctors() async {
    emit(HomeLoading());
    final result = await HomeRepo.getTopRatedDoctors();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (doctors) => emit(HomeSuccess(doctors)),
    );
  }
}
