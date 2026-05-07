import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../features/appointments/data/model/appointment_model.dart';
import '../../../../features/auth/data/model/doctor_model.dart';
import '../../../../features/auth/data/model/patient_model.dart';

class FirebaseProvider {
  static final patientCollection = FirebaseFirestore.instance.collection("patient");
  static final doctorCollection = FirebaseFirestore.instance.collection("doctor");
  static final appointmentCollection = FirebaseFirestore.instance.collection("appointments");

  static Future<void> addPatient(PatientModel patient) async {
    await patientCollection.doc(patient.uid).set(patient.toJson());
  }

  static Future<void> addDoctor(DoctorModel doctor) async {
    await doctorCollection.doc(doctor.uid).set(doctor.toJson());
  }

  static Future<void> updateDoctor(DoctorModel doctor) async {
    await doctorCollection.doc(doctor.uid).set(doctor.toJson(), SetOptions(merge: true));
  }

  static Future<QuerySnapshot> getDoctors() async {
    return await doctorCollection.get();
  }

  static Future<QuerySnapshot> sortingDoctors() async {
    return await doctorCollection
        .orderBy("rating", descending: true)
        .limit(5)
        .get();
  }

  static Future<QuerySnapshot> getDoctorsBySpecialization(String specialization) async {
    return await doctorCollection
        .where("specialization", isEqualTo: specialization)
        .get();
  }

  static Future<QuerySnapshot> searchForDoctorsByName(String name) async {
    return await doctorCollection
        .where("name", isGreaterThanOrEqualTo: name)
        .where("name", isLessThanOrEqualTo: "$name\uf8ff")
        .get();
  }

  // Appointment methods
  static Future<void> bookAppointment(AppointmentModel appointment) async {
    final docRef = appointmentCollection.doc();
    appointment.appointmentId = docRef.id;
    await docRef.set(appointment.toJson());
  }

  static Stream<QuerySnapshot> getPatientAppointments(String patientId) {
    return appointmentCollection
        .where("patientId", isEqualTo: patientId)
        .snapshots();
  }

  static Stream<QuerySnapshot> getDoctorAppointments(String doctorId) {
    return appointmentCollection
        .where("doctorId", isEqualTo: doctorId)
        .snapshots();
  }

  static Future<void> deleteAppointment(String appointmentId) async {
    await appointmentCollection.doc(appointmentId).delete();
  }
}
