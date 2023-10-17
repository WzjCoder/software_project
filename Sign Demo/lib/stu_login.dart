import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:test1/stu_register.dart';

class Stu_login extends StatelessWidget
{
  final TextEditingController idCtrl = TextEditingController();
  final TextEditingController pwdCtrl = TextEditingController();

  void _login(BuildContext context) //Unfinish
  {
    
  }

  void _register(BuildContext context)
  {
    Navigator.of(context).push(CupertinoPageRoute(builder:(context) => stu_resister()));
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('学生登陆（待开启统一认证登陆）'),
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
                const Text('学号 :'),
                const SizedBox(width: 5),
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: Flexible(
                    child: CupertinoTextField(
                      controller: idCtrl,
                      placeholder: '请输入学号',
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
            const SizedBox(height: 0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  onPressed: () => _register(context),
                  // padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 2),
                  child: const Text('还没有账号？点此注册',style: TextStyle(fontSize: 10),),
                ),
                CupertinoButton(
                  onPressed: () => _login(context),
                  child: const Text('登陆',style: TextStyle(fontSize: 16)),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
}