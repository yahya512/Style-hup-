import 'package:dio/dio.dart';
import 'package:dx/core/api/dio_consumer.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:dx/Social-Media/feed/services/feed_service.dart';
import 'package:dx/Social-Media/user/services/user_profile_service.dart';
import 'package:dx/Social-Media/user/services/other_user_profile_service.dart';
import 'package:dx/Social-Media/brand/services/brand_profile_service.dart';
import 'package:dx/Social-Media/interactions/services/interaction_service.dart';
import 'package:dx/Social-Media/search/services/search_service.dart';
import 'package:dx/Social-Media/profile_posts/services/my_posts_service.dart';
import 'package:dx/Social-Media/follow/services/follow_service.dart';
import 'package:dx/Social-Media/notifications/cubit/notification_cubit.dart';
import 'package:dx/Social-Media/notifications/services/notification_service.dart';
import 'package:dx/Social-Media/notifications/services/socket_service.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton(() => Dio());

  getIt.registerLazySingleton(() => DioConsumer(dio: getIt<Dio>()));

  getIt.registerLazySingleton(() => UserRepository(api: getIt<DioConsumer>()));

  getIt.registerLazySingleton(() => FeedService());

  getIt.registerLazySingleton(() => UserProfileService());

  getIt.registerLazySingleton(() => BrandProfileService());

  getIt.registerLazySingleton(() => SearchService());

  getIt.registerLazySingleton(() => InteractionService());

  getIt.registerLazySingleton(() => MyPostsService());

  getIt.registerLazySingleton(() => FollowService());

  getIt.registerLazySingleton(() => OtherUserProfileService());

  getIt.registerLazySingleton(() => NotificationService());

  getIt.registerLazySingleton(
    () => SocketService(baseUrl: Endpoints.baseUrl),
  );

  getIt.registerFactory(
    () => NotificationCubit(
      service: getIt<NotificationService>(),
      socket: getIt<SocketService>(),
    ),
  );

  // Force DioConsumer to initialize now so the shared Dio instance gets
  // baseUrl and ApiInterceptors configured before any API call is made.
  getIt<DioConsumer>();
}
