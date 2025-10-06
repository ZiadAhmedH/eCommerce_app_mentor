import 'package:get_it/get_it.dart';
import '../network/network_info.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

 
}

Future<void> resetDependencies() async {
  await getIt.reset();
}
