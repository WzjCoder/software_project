import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Signup/components/signup_form.dart';
import 'package:flutter_auth/main.dart';

class SignUpFunciton {
  final dio = Dio();
  Future<void> registerUser(BuildContext context,String cls) async {
    var response = await dio.post(
      "$baseUrl/api/User/register",
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
      data: {
        "checkPassword": passwordSure.text,
        'classes':cls,
        "userAccount": account.text,
        "userPassword": password.text,
        'userName':name.text,
      },
    );

    Map<String,dynamic> ret = response.data;
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    mySnackbar(ret['message'], context);
    if(ret['message'] == 'ok') {
      Navigator.of(context).pushNamed('/SignIn');
    }
  }
}
