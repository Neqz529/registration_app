import 'package:equatable/equatable.dart';
import 'package:register_appilcation/models/error_model.dart';

abstract class IRegistrationState extends Equatable{
  const IRegistrationState();
}

class RegistrationInitialState extends IRegistrationState {

  const RegistrationInitialState();
  
  @override
  List<Object?> get props => [];

}

class RegistrationLoadingState extends IRegistrationState {

  const RegistrationLoadingState();

  @override
  List<Object?> get props => [];

}

class RegistrationSuccessState extends IRegistrationState {

  const RegistrationSuccessState();

  @override
  List<Object?> get props => [];

}

class RegistrationErrorState extends IRegistrationState {

  final ErrorModel error;

  const RegistrationErrorState({required this.error});

  @override
  List<Object?> get props => [error];
  
}