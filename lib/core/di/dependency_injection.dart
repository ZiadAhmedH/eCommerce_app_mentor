import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

// Auth
import '../../features/auth/data/dataresource/auth_remote_data_source.dart';
import '../../features/auth/data/repo/auth_repo.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecase/register.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  
  // Dio setup
  getIt.registerLazySingleton(() {
    final dio = Dio();
    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    );
    
    // Add logging interceptor in debug mode
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ));
    }
    
    return dio;
  });

  // Auth feature
  _setupAuthDependencies();
}

void _setupAuthDependencies() {
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );

  // Repositories  
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => RegisterUseCase(repository: getIt()));

  // Cubits
  getIt.registerFactory(() => RegisterCubit(registerUseCase: getIt()));
}