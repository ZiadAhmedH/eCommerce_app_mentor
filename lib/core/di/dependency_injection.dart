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
  try {
    // Core dependencies first
    await _setupCoreDependencies();
    
    // Feature dependencies
    _setupAuthDependencies();
    
    debugPrint('✅ Dependency injection setup completed');
  } catch (e) {
    debugPrint('❌ DI setup error: $e');
    rethrow;
  }
}

Future<void> _setupCoreDependencies() async {
  // External dependencies - these can be slow, so we optimize them
  if (!getIt.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerLazySingleton(() => sharedPreferences);
  }
  
  // Dio setup with optimized configuration
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton(() => _createOptimizedDio());
  }
}

Dio _createOptimizedDio() {
  final dio = Dio();
  
  // Optimized configuration for better performance
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 10), // Reduced timeout
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );
  
  // Minimal logging in debug mode to reduce frame drops
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false, // Disable to reduce console spam
        responseBody: false, // Disable to reduce console spam
        requestHeader: false,
        responseHeader: false,
        request: true,
        error: true,
        logPrint: (obj) => debugPrint('🌐 $obj'), // Custom log prefix
      ),
    );
  }
  
  return dio;
}

void _setupAuthDependencies() {
  // Data sources
  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dio: getIt()),
    );
  }

  // Repositories  
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: getIt()),
    );
  }

  // Use cases
  if (!getIt.isRegistered<RegisterUseCase>()) {
    getIt.registerLazySingleton(() => RegisterUseCase(repository: getIt()));
  }

  // Cubits - Factory for better memory management
  getIt.registerFactory(() => RegisterCubit(registerUseCase: getIt()));
}