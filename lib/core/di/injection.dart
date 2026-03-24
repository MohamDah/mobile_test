import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/shared_preferences_datasource.dart';
import '../../data/datasources/remote/firebase_auth_datasource.dart';
import '../../data/datasources/remote/firebase_storage_datasource.dart';
import '../../data/datasources/remote/firestore_gym_datasource.dart';
import '../../data/datasources/remote/firestore_user_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/gym_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/gym_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/auth/auth_usecases.dart';
import '../../domain/usecases/gym/get_gyms_stream_usecase.dart';
import '../../domain/usecases/gym/gym_usecases.dart';
import '../../domain/usecases/user/user_usecases.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/gym/gym_bloc.dart';
import '../../presentation/blocs/saved_gyms/saved_gyms_cubit.dart';
import '../../presentation/blocs/settings/settings_cubit.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';

/// Global [GetIt] service locator instance.
final GetIt sl = GetIt.instance;

/// Registers every dependency in the correct order:
///   1. External services (Firebase, SharedPreferences)
///   2. Data sources
///   3. Repositories
///   4. Use-cases
///   5. BLoC / Cubit factories
Future<void> initDependencies() async {
  // ── 1. External services ──────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<GoogleSignIn>(
    GoogleSignIn(
      // Web OAuth client ID from google-services.json (oauth_client type 3).
      // Required on Android so that googleAuth.idToken is non-null.
      serverClientId:
          '425684716113-l5tt2q32t15842ptrl44q855ecgucgde.apps.googleusercontent.com',
    ),
  );

  // ── 2. Data sources ───────────────────────────────────────────────────────
  sl.registerLazySingleton<SharedPreferencesDataSource>(
    () => SharedPreferencesDataSource(sl()),
  );
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(sl(), sl()),
  );
  sl.registerLazySingleton<FirestoreGymDataSource>(
    () => FirestoreGymDataSource(sl()),
  );
  sl.registerLazySingleton<CloudinaryDataSource>(
    () => CloudinaryDataSource(),
  );
  sl.registerLazySingleton<FirestoreUserDataSource>(
    () => FirestoreUserDataSource(sl()),
  );

  // ── 3. Repositories ───────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GymRepository>(
    () => GymRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  // ── 4. Use-cases ──────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetGymsStreamUseCase(sl()));
  sl.registerLazySingleton(() => FilterGymsByDistrictUseCase());
  sl.registerLazySingleton(() => CreateGymUseCase(sl()));
  sl.registerLazySingleton(() => UpdateGymUseCase(sl()));
  sl.registerLazySingleton(() => DeleteGymUseCase(sl()));
  sl.registerLazySingleton(() => SaveGymUseCase(sl()));
  sl.registerLazySingleton(() => UnsaveGymUseCase(sl()));

  // ── 5. BLoC / Cubits ──────────────────────────────────────────────────────
  sl.registerFactory<ThemeCubit>(() => ThemeCubit(sl()));
  sl.registerFactory<SettingsCubit>(() => SettingsCubit(sl()));
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      signIn: sl(),
      register: sl(),
      googleSignIn: sl(),
      resetPassword: sl(),
      signOut: sl(),
      authRepository: sl(),
      userRepository: sl(),
    ),
  );
  sl.registerFactory<GymBloc>(
    () => GymBloc(
      getGymsStream: sl(),
      filterGyms: sl(),
      createGym: sl(),
      updateGym: sl(),
      deleteGym: sl(),
    ),
  );
  sl.registerFactory<SavedGymsCubit>(
    () => SavedGymsCubit(
      saveGym: sl(),
      unsaveGym: sl(),
      userRepository: sl(),
    ),
  );
}
