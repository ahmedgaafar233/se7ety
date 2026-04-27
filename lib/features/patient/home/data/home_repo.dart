import 'package:dartz/dartz.dart';
import 'package:se7ty/core/services/firebase/errors/failure.dart';
import 'package:se7ty/core/services/firebase/firestore_provider.dart';

class HomeRepo {
  Future<Either<Failure, List<DoctorModel>>> getTopRatedDoctors() async {
    try {
      final snapshot = await FirebaseProvider.sortingDoctors();
      final doctors = snapshot.docs
          .map((doc) => DoctorModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return right(doctors);
    } catch (e) {
      return left(Failure(message: 'حدث خطأ أثناء تحميل البيانات.'));
    }
  }
}
