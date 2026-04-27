import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/services/firebase/errors/failure.dart';
import '../../../../core/services/firebase/firestore_provider.dart';
import '../../../../core/utils/prefs_helper.dart';
import '../model/auth_params.dart';
import '../model/doctor_model.dart';
import '../model/patient_model.dart';
import '../model/user_type_enum.dart';

class AuthRepo {
  // Login and cache info
  Future<Either<Failure, Unit>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Role is stored in photoURL
        String role = user.photoURL ?? '';
        String name = user.displayName ?? '';

        // If data missing in Auth profile, fetch from Firestore as fallback/enhancement
        if (role.isEmpty) {
          // Check both collections if role is unknown
          var doctorDoc = await FirebaseFirestore.instance.collection('doctor').doc(user.uid).get();
          if (doctorDoc.exists) {
            role = 'doctor';
            name = doctorDoc.data()?['name'] ?? '';
            await user.updatePhotoURL('doctor');
          } else {
            var patientDoc = await FirebaseFirestore.instance.collection('patient').doc(user.uid).get();
            if (patientDoc.exists) {
              role = 'patient';
              name = patientDoc.data()?['name'] ?? '';
              await user.updatePhotoURL('patient');
            }
          }
        }

        // Cache locally
        await PrefsHelper.saveUserData(
          uid: user.uid,
          name: name,
          role: role,
        );
      }

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left(Failure(message: 'المستخدم غير موجود.'));
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return left(Failure(message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.'));
      } else {
        return left(Failure(message: 'حدث خطأ في عملية تسجيل الدخول:\n${e.message}'));
      }
    } catch (e) {
      return left(Failure(message: 'حدث خطأ غير متوقع:\n$e'));
    }
  }

  // Register Doctor and cache info
  Future<Either<Failure, Unit>> registerDoctor(AuthParams params) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      await credential.user?.updateDisplayName(params.name);
      
      // add role (Use PhotoURL as role)
      await credential.user?.updatePhotoURL(UserTypeEnum.doctor.name);

      // Create model instance
      var doctorData = DoctorModel(
        name: params.name,
        email: params.email,
        uid: credential.user!.uid,
        specialization: params.specialization ?? 'General',
      );

      // Save to Firestore using static Provider call
      await FirebaseProvider.addDoctor(doctorData);

      // Cache locally
      await PrefsHelper.saveUserData(
        uid: credential.user!.uid,
        name: params.name,
        role: UserTypeEnum.doctor.name,
      );

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(Failure(message: 'كلمة المرور ضعيفة جداً.'));
      } else if (e.code == 'email-already-in-use') {
        return left(Failure(message: 'هذا البريد الإلكتروني مسجل بالفعل.'));
      } else {
        return left(Failure(message: 'حدث خطأ في عملية التسجيل.'));
      }
    } catch (e) {
      return left(Failure(message: 'حدث خطأ غير متوقع.'));
    }
  }

  // Register Patient and cache info
  Future<Either<Failure, Unit>> registerPatient(AuthParams params) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      await credential.user?.updateDisplayName(params.name);

      // add role (Use PhotoURL as role)
      await credential.user?.updatePhotoURL(UserTypeEnum.patient.name);

      // Create model instance
      var patientData = PatientModel(
        name: params.name,
        email: params.email,
        uid: credential.user!.uid,
      );

      // Save to Firestore using static Provider call
      await FirebaseProvider.addPatient(patientData);

      // Cache locally
      await PrefsHelper.saveUserData(
        uid: credential.user!.uid,
        name: params.name,
        role: UserTypeEnum.patient.name,
      );

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(Failure(message: 'كلمة المرور ضعيفة جداً.'));
      } else if (e.code == 'email-already-in-use') {
        return left(Failure(message: 'هذا البريد الإلكتروني مسجل بالفعل.'));
      } else {
        return left(Failure(message: 'حدث خطأ في عملية التسجيل.'));
      }
    } catch (e) {
      return left(Failure(message: 'حدث خطأ غير متوقع.'));
    }
  }

  // Logout and clear cache
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await PrefsHelper.logout();
  }

  // Update Doctor Profile (The logic from instructor screenshots)
  Future<Either<Failure, Unit>> updateDoctorProfile(DoctorModel doctor) async {
    try {
      await FirebaseProvider.updateDoctor(doctor);
      return right(unit);
    } catch (e) {
      return left(Failure(message: 'حدث خطأ أثناء تحديث البيانات.'));
    }
  }

  // Upload Image to Firebase Storage
  Future<String> uploadImage(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('doctors')
        .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
