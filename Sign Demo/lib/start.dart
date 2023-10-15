import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/main.dart';

class StartPage extends StatelessWidget 
{
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        automaticallyImplyLeading: false,
        title: const Text('Main Page'),
      ),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> 
          [
            ElevatedButton
            (
              onPressed: ()
              {
                // goto i'm stu
              },
              child: const Text('我是学生'),
            ),
            const SizedBox(height: 20),
            ElevatedButton
            (
              onPressed: ()
              {
                // goto i'm tea
              },
              child: const Text('我是教师'),
            ),
            const SizedBox(height: 20),
            ElevatedButton
            (
              onPressed: ()
              {
                Navigator.of(context).pop();
              },
              child: const Text('退出Demo演示'),
            ),
          ],
        )
      ),
    );
  }
}
