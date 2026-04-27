import 'package:get_it/get_it.dart';
import '../../features/auth/data/repo/auth_repo.dart';
import '../../features/home/data/repo/home_repo.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo());
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo());
}
