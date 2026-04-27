import 'package:dartz/dartz.dart';
import 'package:se7ty/core/services/firebase/errors/failure.dart';
import 'package:se7ty/core/services/firebase/firestore_provider.dart';
import 'package:se7ty/features/auth/data/model/doctor_model.dart';

class HomeRepo {
  Future<Either<Failure, List<DoctorModel>>> getTopRatedDoctors() async {
    try {
      final doctors = await FirestoreProvider.getTopRatedDoctors();
      return right(doctors);
    } catch (e) {
      return left(Failure(message: 'حدث خطأ أثناء تحميل البيانات.'));
    }
  }
}
