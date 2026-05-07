import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/firebase/firestore_provider.dart';
import 'appointments_states.dart';

class AppointmentsCubit extends Cubit<AppointmentsStates> {
  AppointmentsCubit() : super(AppointmentsInitialState());

  void getPatientAppointments(String patientId) {
    emit(AppointmentsLoadingState());
    try {
      FirebaseProvider.getPatientAppointments(patientId).listen((event) {
        emit(AppointmentsSuccessState(event.docs));
      });
    } catch (e) {
      emit(AppointmentsErrorState(e.toString()));
    }
  }

  void getDoctorAppointments(String doctorId) {
    emit(AppointmentsLoadingState());
    try {
      FirebaseProvider.getDoctorAppointments(doctorId).listen((event) {
        emit(AppointmentsSuccessState(event.docs));
      });
    } catch (e) {
      emit(AppointmentsErrorState(e.toString()));
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await FirebaseProvider.deleteAppointment(appointmentId);
    } catch (e) {
      emit(AppointmentsErrorState(e.toString()));
    }
  }
}
