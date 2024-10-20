import 'package:go_router/go_router.dart';
import 'package:register_appilcation/presentation/home_screen.dart';
import 'package:register_appilcation/presentation/registration_screen.dart';
import 'package:register_appilcation/sl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter{

  static GoRouter router = GoRouter(
    redirect: (context, state) {
      final String? token = DependencyInjectionManager.sl<SharedPreferences>().getString('token');
      if(token == null){
        return AppRoutes.register;
      }else{
        return AppRoutes.home;
      }
    },
    routes: routes,
    initialLocation: AppRoutes.register,
  );

  static List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.register,
      builder: (context, state) => const RegistrationScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    )
  ];

}

class AppRoutes {
  static const String register = "/register";
  static const String home = "/home";
}