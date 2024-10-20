import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:register_appilcation/bloc/registration_cubit.dart';
import 'package:register_appilcation/bloc/registration_state.dart';
import 'package:register_appilcation/router.dart';
import 'package:register_appilcation/sl.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _secondNameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _secondaryPasswordController;
  late final RegistrationCubit cubit;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _firstNameController = TextEditingController();
    _secondNameController = TextEditingController();
    _passwordController = TextEditingController();
    _secondaryPasswordController = TextEditingController();
    cubit = DependencyInjectionManager.sl<RegistrationCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _secondNameController.dispose();
    _passwordController.dispose();
    _secondaryPasswordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: BlocConsumer<RegistrationCubit, IRegistrationState>(
            bloc: cubit,
            listener: (context, state) {
              if(state is RegistrationErrorState){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${state.error.statusCode} ${state.error.message}")),
                );
              }
              if(state is RegistrationSuccessState){
                GoRouter.of(context).goNamed(AppRoutes.home);
              }
            },
            builder: (context, state) {
              return ListView(
                padding: const EdgeInsets.all(24),
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                    ),
                    controller: _emailController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a E-mail';
                      }
                      RegExp regExp = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                      if (!regExp.hasMatch(value)) {
                        return 'Please enter a valid E-mail';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'First name',
                    ),
                    controller: _firstNameController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your name';
                      }
                      if (value.length < 3) {
                        return 'The name must contain at least 3 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Second name',
                    ),
                    controller: _secondNameController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    controller: _passwordController,
                    obscureText: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Password can not be absent';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Repeat password',
                    ),
                    controller: _secondaryPasswordController,
                    obscureText: true,
                    validator: (String? value) {
                      if (_passwordController.text != value){
                        return 'Passwords must match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        cubit.register(
                          email: _emailController.text, 
                          firstName: _firstNameController.text, 
                          secondName: _secondNameController.text, 
                          password: _passwordController.text
                        );
                      } 
                    },
                    child: state is RegistrationLoadingState 
                      ? const CircularProgressIndicator.adaptive() 
                      : const Text('Register')
                  ),
                ]
              );
            }
          ),
        ),
      ),
    );
  }
}