import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../features/auth/data/model/doctor_model.dart';
import '../../../../features/auth/data/model/patient_model.dart';

class FirestoreProvider {
  static final patientCollection = FirebaseFirestore.instance.collection("patient");
  static final doctorCollection = FirebaseFirestore.instance.collection("doctor");

  static Future<void> addPatient(PatientModel patient) async {
    await patientCollection.doc(patient.uid).set(patient.toJson());
  }

  static Future<void> addDoctor(DoctorModel doctor) async {
    await doctorCollection.doc(doctor.uid).set(doctor.toJson());
  }

  static Future<List<DoctorModel>> getTopRatedDoctors() async {
    final querySnapshot = await doctorCollection
        .orderBy('rating', descending: true)
        .limit(10)
        .get();
    return querySnapshot.docs
        .map((doc) => DoctorModel.fromJson(doc.data()))
        .toList();
  }
}
