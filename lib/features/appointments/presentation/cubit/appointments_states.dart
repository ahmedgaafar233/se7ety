import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppointmentsStates {}

class AppointmentsInitialState extends AppointmentsStates {}

class AppointmentsLoadingState extends AppointmentsStates {}

class AppointmentsSuccessState extends AppointmentsStates {
  final List<QueryDocumentSnapshot> appointments;
  AppointmentsSuccessState(this.appointments);
}

class AppointmentsErrorState extends AppointmentsStates {
  final String error;
  AppointmentsErrorState(this.error);
}
