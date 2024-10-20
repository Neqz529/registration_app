import 'package:flutter/material.dart';
import 'package:register_appilcation/router.dart';
import 'package:register_appilcation/sl.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjectionManager.initDependencies();
  runApp(const RegistrationApp());

}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Register Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      routerDelegate: AppRouter.router.routerDelegate,
    );
  }
}

