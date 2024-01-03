// ignore_for_file: non_constant_identifier_names
import 'package:flutter_auth/StoreToken.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../../Signup/signup_screen.dart';

final Login_Methods = SignInFunction();

class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);
  final account = TextEditingController();
  final pwd = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Padding(
        padding: EdgeInsets.all(defaultPadding),
        child:SingleChildScrollView(
        reverse: true,
      child: Column(
        children: [
          TextFormField(
            controller: account,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (account) {},
            decoration: const InputDecoration(
              hintText: "账号",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: pwd,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "密码",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () async {
              await Login_Methods.goLogin(context, account.text, pwd.text);
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    )));
  }
}

class SignInFunction {
  final dio = Dio();
  Future<void> goLogin(BuildContext context,String account,String pwd) async {
    var response = await dio.post(
      "$baseUrl/api/User/login",
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
      data: {
        "userAccount": account,
        "userPassword": pwd,
      },
    );
    String rawHeaders= response.headers.toString();
    // print('ok');
    // print(rawHeaders);

    List<String> headerLines = rawHeaders.split('\n');
    for (var line in headerLines) {
      if (line.startsWith('set-cookie:')) {
        List<String> parts = line.split(':');
        String cookieHeader = parts[1].trim();
        List<String> cookies = cookieHeader.split(';');
        String session = cookies[0]; // 'JSESSIONID=32D6818312B6BAB17F4C9BC5F0D2A46B'
        // print(session);
        saveToken(session);
      }
    }

    String session = await getToken();
    currentname = account;
    
    var current = await dio.get(
      "$baseUrl/api/User/current",
      options: Options(
        headers: {
          'Cookie': session,
        }
      )
    );

    // var allInfo = await dio.get(
    //   "$baseUrl/api/User/search",
    //   options: Options(
    //     headers: {
    //       'Cookie': session,
    //     }
    //   )
    // );

    // print(allInfo);
    // Map<String,dynamic> allIn = allInfo.data['data'];

    // for (var user in allIn['data']) {
    //   var classes = user['classes'];
    //   if (classes != null) {
    //     classesInfo.add(classes);
    //   }
    // }

    currentInfo = current.data['data'];

    Map<String,dynamic> ret = response.data;
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    mySnackbar(ret['message'], context);
    if(ret['message'] == 'ok') {
      if(ret['data']['userRole'] == 1) {
        Navigator.of(context).pushNamed('/HomeStu');  //学生身份
      } else{
        Navigator.of(context).pushNamed('/HomeTea');  //教师身份
      }
    }
  }
}