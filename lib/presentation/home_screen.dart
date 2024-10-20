import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:register_appilcation/router.dart';
import 'package:register_appilcation/sl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Welcome'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          DependencyInjectionManager.sl<SharedPreferences>().remove('token');
          GoRouter.of(context).goNamed(AppRoutes.home);
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
