import 'package:dio/dio.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/login.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

// Auth imports
import '../../features/auth/data/dataresource/auth_remote_data_source.dart';
import '../../features/auth/data/repo/auth_repo.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecase/register.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  try {
    await _setupCoreDependencies();
    _setupAuthDependencies();
    debugPrint('✅ Dependency injection setup completed');
  } catch (e, stack) {
    debugPrint('❌ DI setup error: $e\n$stack');
    rethrow;
  }
}

Future<void> _setupCoreDependencies() async {
  if (!getIt.isRegistered<SharedPreferences>()) {
    final prefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  }

  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(() => _createDio());
  }
}

Dio _createDio() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        error: true,
        requestHeader: false,
        responseHeader: false,
        requestBody: false,
        responseBody: false,
        logPrint: (msg) => debugPrint('🌐 $msg'),
      ),
    );
  }

  return dio;
}

void _setupAuthDependencies() {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => RegisterUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));

  getIt.registerFactory(() => AuthCubit(
        registerUseCase: getIt(),
        loginUseCase: getIt(),
      ));
}
