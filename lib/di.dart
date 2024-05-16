import 'package:get_it/get_it.dart';
import 'package:video_sharing_app/data/repository_impl/auth_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/comment_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/follow_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/preference_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/auth_api.dart';
import 'package:video_sharing_app/data/source/remote/comment_api.dart';
import 'package:video_sharing_app/data/source/remote/fake/fake_auth_api.dart';
import 'package:video_sharing_app/data/source/remote/fake/fake_comment_api.dart';
import 'package:video_sharing_app/data/source/remote/fake/fake_follow_api.dart';
import 'package:video_sharing_app/data/source/remote/fake/fake_user_api.dart';
import 'package:video_sharing_app/data/source/remote/fake/fake_video_api.dart';
import 'package:video_sharing_app/data/source/remote/follow_api.dart';
import 'package:video_sharing_app/data/source/remote/user_api.dart';
import 'package:video_sharing_app/data/source/remote/video_api.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerSingletonAsync(() => PreferencesService.createAsync());
  final pref = await getIt.getAsync<PreferencesService>();

  getIt.registerLazySingleton(() => FakeAuthApi());
  getIt.registerLazySingleton(() => FakeCommentApi(token: ''));
  getIt.registerLazySingleton(() => FakeFollowApi(token: ''));
  getIt.registerLazySingleton(() => FakeUserApi(token: ''));
  getIt.registerLazySingleton(() => FakeVideoApi(token: ''));

  getIt.registerFactory(() => AuthApi());
  getIt.registerFactoryParam((param1, param2) => CommentApi(token: param1 as String));
  getIt.registerFactoryParam((param1, param2) => FollowApi(token: param1 as String));
  getIt.registerFactoryParam((param1, param2) => UserApi(token: param1 as String));
  getIt.registerFactoryParam((param1, param2) => VideoApi(token: param1 as String));

  getIt.registerLazySingleton(
    () => AuthRepositoryImpl(pref: pref, authApi: getIt<AuthApi>()),
  );
  getIt.registerLazySingleton(
    () => CommentRepositoryImpl(pref: pref, commentApi: getIt<CommentApi>(param1: pref.getToken())),
  );
  getIt.registerLazySingleton(
    () => FollowRepositoryImpl(pref: pref, followApi: getIt<FollowApi>(param1: pref.getToken())),
  );
  getIt.registerLazySingleton(() => PreferenceRepositoryImpl(pref: pref));
  getIt.registerLazySingleton(
    () => UserRepositoryImpl(userApi: getIt<UserApi>(param1: pref.getToken())),
  );
  getIt.registerLazySingleton(
    () => VideoRepositoryImpl(pref: pref, videoApi: getIt<VideoApi>(param1: pref.getToken())),
  );
}

Future<void> configureDependenciesForTest() async {
  getIt.registerSingletonAsync(() => PreferencesService.createAsync());
  final pref = await getIt.getAsync<PreferencesService>();

  getIt.registerFactory(() => FakeAuthApi());
  getIt.registerFactoryParam((param1, param2) => FakeCommentApi(token: param1 as String));
  getIt.registerFactoryParam((param1, param2) => FakeFollowApi(token: param1 as String));
  getIt.registerFactoryParam((param1, param2) => FakeUserApi(token: param1 as String));
  getIt.registerFactoryParam((param1, param2) => FakeVideoApi(token: param1 as String));

  getIt.registerLazySingleton(
    () => AuthRepositoryImpl(pref: pref, authApi: getIt<FakeAuthApi>()),
  );
  getIt.registerLazySingleton(
    () => CommentRepositoryImpl(pref: pref, commentApi: getIt<FakeCommentApi>(param1: pref.getToken())),
  );
  getIt.registerLazySingleton(
    () => FollowRepositoryImpl(pref: pref, followApi: getIt<FakeFollowApi>(param1: pref.getToken())),
  );
  getIt.registerLazySingleton(() => PreferenceRepositoryImpl(pref: pref));
  getIt.registerLazySingleton(
    () => UserRepositoryImpl(userApi: getIt<FakeUserApi>(param1: pref.getToken())),
  );
  getIt.registerLazySingleton(
    () => VideoRepositoryImpl(pref: pref, videoApi: getIt<FakeVideoApi>(param1: pref.getToken())),
  );
}
