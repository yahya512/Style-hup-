import 'package:dio/dio.dart';
import 'package:dx/core/api/dio_consumer.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  //registerLazySingleton => create just one when it needed
  getIt.registerLazySingleton(() => Dio());

  getIt.registerLazySingleton(() => DioConsumer(dio: getIt<Dio>()));

  getIt.registerLazySingleton(() => UserRepository(api: getIt<DioConsumer>()));
}
