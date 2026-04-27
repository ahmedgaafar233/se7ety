import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../features/auth/data/model/doctor_model.dart';
import '../../../../features/auth/data/model/patient_model.dart';

class FirebaseProvider {
  static final patientCollection = FirebaseFirestore.instance.collection("patient");
  static final doctorCollection = FirebaseFirestore.instance.collection("doctor");

  static Future<void> addPatient(PatientModel patient) async {
    await patientCollection.doc(patient.uid).set(patient.toJson());
  }

  static Future<void> addDoctor(DoctorModel doctor) async {
    await doctorCollection.doc(doctor.uid).set(doctor.toJson());
  }

  static Future<void> updateDoctor(DoctorModel doctor) async {
    await doctorCollection.doc(doctor.uid).update(doctor.toJson());
  }

  static Future<QuerySnapshot> getDoctors() async {
    return await doctorCollection.get();
  }

  static Future<QuerySnapshot> sortingDoctors() async {
    return await doctorCollection
        .where("specialization", isNull: false)
        .orderBy("rating", descending: true)
        .get();
  }

  static Future<QuerySnapshot> getDoctorsBySpecialization(String specialization) async {
    return await doctorCollection
        .where("specialization", isEqualTo: specialization)
        .get();
  }

  static Future<QuerySnapshot> searchForDoctorsByName(String name) async {
    return await doctorCollection.get();
  }
}
