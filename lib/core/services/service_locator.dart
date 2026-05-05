import 'package:dio/dio.dart';
import 'package:dx/core/api/dio_consumer.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:dx/Social-Media/feed/services/feed_service.dart';
import 'package:dx/Social-Media/user/services/user_profile_service.dart';
import 'package:dx/Social-Media/brand/services/brand_profile_service.dart';
import 'package:dx/Social-Media/search/services/search_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  //registerLazySingleton => create just one when it needed
  getIt.registerLazySingleton(() => Dio());

  getIt.registerLazySingleton(() => DioConsumer(dio: getIt<Dio>()));

  getIt.registerLazySingleton(() => UserRepository(api: getIt<DioConsumer>()));

  getIt.registerLazySingleton(() => FeedService());

  getIt.registerLazySingleton(() => UserProfileService());

  getIt.registerLazySingleton(() => BrandProfileService());

  getIt.registerLazySingleton(() => SearchService());
}
