import 'package:get_it/get_it.dart';
import 'package:register_appilcation/bloc/registration_cubit.dart';
import 'package:register_appilcation/data/repository/registration_repository.dart';
import 'package:register_appilcation/data/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjectionManager {

  static final GetIt sl = GetIt.instance;

  static Future<void> initDependencies() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(prefs);

    sl.registerSingleton<ApiClient>(
      RestClient.createClient(),
    );

   sl.registerLazySingleton<RegistrationRepository>(
      () => RegistrationRepository(
        apiClient: sl<ApiClient>(),
      ), 
    );

    sl.registerFactory<RegistrationCubit>(
      () => RegistrationCubit(
        prefs: sl<SharedPreferences>(),
        repository: sl<RegistrationRepository>(),
      ), 
    );

  }

}