import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:register_appilcation/data/rest_client.dart';
import 'package:register_appilcation/models/error_model.dart';
import 'package:register_appilcation/models/token_model.dart';

class RegistrationRepository{
  final ApiClient apiClient;

  const RegistrationRepository({
    required this.apiClient
  });
  
  Future<(TokenModel?, ErrorModel?)> register({
    required String email,
    required String firstName,
    required String secondName,
    required String password,
  }) async{
    try {
      final result = await apiClient.register(email: email, firstName: firstName, secondName: secondName, password: password);
      return (result, null); 
    } catch (obj) {
      
      if (obj is DioException) {
        return (null, ErrorModel(
          message: obj.response?.data is String ? jsonDecode((obj.response?.data as String))['message'] ?? 'An error occurred' : 'An error occurred', 
          statusCode: obj.response?.statusCode ?? 0
        ));
      } else {
        return (null, const ErrorModel(
          message: 'An unexpected error occurred', 
          statusCode: 0
        ));
      }
    }
  }


}