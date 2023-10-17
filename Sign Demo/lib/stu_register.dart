import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:test1/start.dart';
import 'package:flutter/cupertino.dart';

class stu_resister extends StatefulWidget {
  @override
  _stu_resisterState createState() => _stu_resisterState();
}

class _stu_resisterState extends State<stu_resister>{
  final TextEditingController mailCtrl = TextEditingController();
  final TextEditingController idCtrl = TextEditingController();
  final TextEditingController pwdCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController capCtrl = TextEditingController();

  bool isButtonEnabled = false;

  void send_captcha(BuildContext context)async
  {
    var url = Uri.parse('http://localhost/student/register');
    var response = await http.post(url,body: {
      "email": mailCtrl.text,
      "name": nameCtrl.text,
      "password": pwdCtrl.text,
      "phone": phoneCtrl.text,
    });
    
    if (response.statusCode == 200) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('Request Successful'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('Request Failed'),
          content: Text('Request failed with status: ${response.statusCode}'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  void finish(BuildContext context)
  {

  }

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
                onPressed: () => send_captcha(context),
                child: const Text('发送'),
              ),
              CupertinoButton(
                onPressed: isButtonEnabled ? () => finish(context) : null,
                child: const Text('完成注册'),
              )
            ],
          ),
        ),
      ),
    );
  }

}