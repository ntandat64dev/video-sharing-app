import 'package:get_it/get_it.dart';
import 'package:video_sharing_app/data/repository_impl/auth_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/comment_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/fake/fake_auth_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/fake/fake_comment_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/fake/fake_follow_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/fake/fake_notification_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/fake/fake_preference_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/fake/fake_user_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/fake/fake_video_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/follow_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/notification_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/preference_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/auth_api.dart';
import 'package:video_sharing_app/data/source/remote/comment_api.dart';
import 'package:video_sharing_app/data/source/remote/follow_api.dart';
import 'package:video_sharing_app/data/source/remote/notification_api.dart';
import 'package:video_sharing_app/data/source/remote/user_api.dart';
import 'package:video_sharing_app/data/source/remote/video_api.dart';
import 'package:video_sharing_app/domain/repository/auth_repository.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';
import 'package:video_sharing_app/domain/repository/follow_repository.dart';
import 'package:video_sharing_app/domain/repository/notification_repository.dart';
import 'package:video_sharing_app/domain/repository/preference_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerSingletonAsync(() => PreferencesService.createAsync());
  final pref = await getIt.getAsync<PreferencesService>();

  getIt.registerFactory(() => AuthApi());
  getIt.registerFactory(() => CommentApi(token: pref.getToken()!));
  getIt.registerFactory(() => FollowApi(token: pref.getToken()!));
  getIt.registerFactory(() => UserApi(token: pref.getToken()!));
  getIt.registerFactory(() => VideoApi(token: pref.getToken()!));
  getIt.registerFactory(() => NotificationApi(token: pref.getToken()!));

  getIt.registerFactory<NotificationRepository>(
    () => NotificationRepositoryImpl(notificationApi: getIt<NotificationApi>()),
  );
  getIt.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      pref: pref,
      authApi: getIt<AuthApi>(),
    ),
  );
  getIt.registerFactory<CommentRepository>(
    () => CommentRepositoryImpl(
      pref: pref,
      commentApi: getIt<CommentApi>(),
    ),
  );
  getIt.registerFactory<FollowRepository>(
    () => FollowRepositoryImpl(
      pref: pref,
      followApi: getIt<FollowApi>(),
    ),
  );
  getIt.registerFactory<PreferenceRepository>(() => PreferenceRepositoryImpl(pref: pref));
  getIt.registerFactory<UserRepository>(() => UserRepositoryImpl(userApi: getIt<UserApi>(), pref: pref));
  getIt.registerFactory<VideoRepository>(
    () => VideoRepositoryImpl(
      pref: pref,
      videoApi: getIt<VideoApi>(),
    ),
  );
}

Future<void> configureDependenciesForTest() async {
  getIt.registerSingletonAsync(() => PreferencesService.createAsync());

  getIt.registerLazySingleton<AuthRepository>(() => FakeAuthRepositoryImpl());
  getIt.registerLazySingleton<CommentRepository>(() => FakeCommentRepositoryImpl());
  getIt.registerLazySingleton<FollowRepository>(() => FakeFollowRepositoryImpl());
  getIt.registerLazySingleton<NotificationRepository>(() => FakeNotificationRepositoryImpl());
  getIt.registerLazySingleton<PreferenceRepository>(() => FakePreferenceRepositoryImpl());
  getIt.registerLazySingleton<UserRepository>(() => FakeUserRepositoryImpl());
  getIt.registerLazySingleton<VideoRepository>(() => FakeVideoRepositoryImpl());
}
