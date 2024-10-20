import 'package:bloc/bloc.dart';
import 'package:register_appilcation/bloc/registration_state.dart';
import 'package:register_appilcation/data/repository/registration_repository.dart';
import 'package:register_appilcation/models/error_model.dart';
import 'package:register_appilcation/models/token_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationCubit extends Cubit<IRegistrationState>{

  final RegistrationRepository repository;
  final SharedPreferences prefs;

  RegistrationCubit({
    required this.repository, 
    required this.prefs,
  }) : super(const RegistrationInitialState());

  void register({
    required String email,
    required String firstName,
    required String secondName,
    required String password,
  }) async {
    emit(const RegistrationLoadingState());
    final (TokenModel?, ErrorModel?) result = await repository.register(
      email: email, 
      firstName: firstName, 
      secondName: secondName, 
      password: password,
    );
    if(result.$1!=null){
      prefs.setString('token', result.$1!.token);
      emit(const RegistrationSuccessState());
    }else if(result.$2!=null){
      emit(RegistrationErrorState(error: result.$2!));
    }
  }
  
}