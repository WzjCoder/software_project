// ignore_for_file: camel_case_types, library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class stu_resister extends StatefulWidget {
  const stu_resister({super.key});

  @override
  _stu_resisterState createState() => _stu_resisterState();
}

class _stu_resisterState extends State<stu_resister>{

  late BuildContext dialogContext;

  final TextEditingController mailCtrl = TextEditingController();
  final TextEditingController idCtrl = TextEditingController();
  final TextEditingController pwdCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController capCtrl = TextEditingController();

  bool isButtonEnabled = false;

  void send_captcha() async {
    var url = Uri.parse('http://192.168.1.104:8080/student/send-code');
    var response = await http.post(url,body: {
      'email': mailCtrl.text,
    });

    Map<String, dynamic> data = json.decode(response.body);
    

    if (data['code'] == 200) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return CupertinoAlertDialog(
            title: const Text('发送成功'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return CupertinoAlertDialog(
            title: const Text('ERROR'),
            content: Text(data['msg']),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void finish() async
  {
    var url = Uri.parse('http://192.168.1.104:8080/student/register');
    var response = await http.post(url,body: {
      'email': mailCtrl.text,
      'name': nameCtrl.text,
      'password': pwdCtrl.text,
      'phone': phoneCtrl.text,
      'code': capCtrl.text,
    });

    Map<String, dynamic> data = json.decode(response.body);

    if (data['code'] == 200) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            dialogContext = context;
            return CupertinoAlertDialog(
              title: const Text('注册成功'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(data['msg']),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            dialogContext = context;
            return CupertinoAlertDialog(
              title: const Text('ERROR'),
              content: Text(data['msg']),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学生注册'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('邮箱 :'),
                  const SizedBox(width: 5),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Flexible(
                      child: CupertinoTextField(
                        controller: mailCtrl,
                        placeholder: '邮箱地址',
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('姓名 :'),
                  const SizedBox(width: 5),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Flexible(
                      child: CupertinoTextField(
                        controller: nameCtrl,
                        placeholder: '请输入姓名',
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('密码 :'),
                  const SizedBox(width: 5),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Flexible(
                      child: CupertinoTextField(
                        controller: pwdCtrl,
                        obscureText: true,
                        placeholder: '请输入密码',
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('手机号 :'),
                  const SizedBox(width: 5),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Flexible(
                      child: CupertinoTextField(
                        controller: phoneCtrl,
                        placeholder: '请输入手机号',
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('验证码 :'),
                  const SizedBox(width: 5),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Flexible(
                      child: CupertinoTextField(
                        controller: capCtrl,
                        placeholder: '请输入收到的邮箱验证码',
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 0),
              CupertinoButton(
                onPressed: () => send_captcha(),
                child: const Text('发送'),
              ),
              CupertinoButton(
                onPressed: isButtonEnabled ? () => finish() : null,
                child: const Text('完成注册'),
              )
            ],
          ),
        ),
      ),
    );
  }

}