import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:register_appilcation/models/token_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:register_appilcation/data/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) => _ApiClient(dio);

  @POST('/register')
  Future<TokenModel> register({
    @Field('email') required String email,
    @Field('first_name') required String firstName,
    @Field('second_name') required String secondName,
    @Field('password') required String password,
  });

}

class RestClient {

  const RestClient();

  static ApiClient createClient(){
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      )
    );
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
        filter: (options, args){
            // don't print requests with uris containing '/posts' 
            if(options.path.contains('/posts')){
              return false;
            }
            // don't print responses with unit8 list data
            return !args.isResponse || !args.hasUint8ListData;
          }
      ));
    return ApiClient(dio);
  }
  
}