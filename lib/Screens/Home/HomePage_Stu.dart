// ignore_for_file: camel_case_types, file_names

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/QR.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../main.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:images_picker/images_picker.dart';
import 'package:scan/scan.dart';

import '../../StoreToken.dart';

void main() => runApp(const MaterialApp(home: HomePage_Stu()));

final Check_Methods = StuFunction();

class HomePage_Stu extends StatefulWidget {
  const HomePage_Stu({super.key});

  @override
  HPS createState() => HPS();
}

class HPS extends State<HomePage_Stu> {
  final checkCode = TextEditingController();
  final checkId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const Spacer(),
            const SizedBox(height: defaultPadding),
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () async {
                  // 跳转到扫码页面
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QRViewExample(),
                    ),
                  );
                },
                child: Text(
                  "扫码签到".toUpperCase(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: checkCode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (checkCode) {},
              decoration: const InputDecoration(
                hintText: "签到码",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  // child: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: checkId,
                textInputAction: TextInputAction.done,
                obscureText: true,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  hintText: "签到ID",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    // child: Icon(Icons.lock),
                  ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () async {
                await Check_Methods.goCheck(
                    context, checkCode.text, int.parse(checkId.text));
              },
              child: Text(
                "确认签到".toUpperCase(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            // 查看未签到记录
            const SizedBox(height: defaultPadding),
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  Check_Methods.getErrCheck(context);
                },
                child: Text(
                  "查看未签到情况".toUpperCase(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const MyApp();
                      },
                    ),
                  );
                },
                child: Text(
                  "返回首页".toUpperCase(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class StuFunction {
  final dio = Dio();
  Future<void> goCheck(BuildContext context, String code, int id) async {
    String session = await getToken();
    var response = await dio.post(
      "$baseUrl/api/User/usercheckin",
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Cookie': session,
        }
      ),
      data: {
        "checkcode": code,
        "checkid": id,
      },
    );
    Map<String, dynamic> ret = response.data;
    // print(ret);
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    mySnackbar(ret['message'], context, 3000);
    if (ret['code'] == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const MyApp();
          },
        ),
      );
    }
  }

  Future<void> getErrCheck(BuildContext context) async {
    String session = await getToken();
    var response = await dio.post(
      "$baseUrl/api/User/searcherrorlogs",
      options: Options(
        headers: {
          'Cookie': session,
        }
      )
    );
    Map<String, dynamic> ret = response.data;
    // print(ret);
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    List<Map<String, dynamic>> tmp =
        List<Map<String, dynamic>>.from(ret['data']);
    for (var element in tmp) {
      element.remove("logid");
      element.remove("userid");
      element.remove("errordate");
      element.remove("isop");
    }
    String ans = tmp.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(ans),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
