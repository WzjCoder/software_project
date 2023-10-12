import 'package:flutter/material.dart';
import 'package:test1/start.dart';

void main() => runApp(Sign());

class Sign extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: HomePage(),
      routes: 
      {
        '/start':(context) => StartPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Sign Demo'),
      ),
      body: Center
      (
        child: ElevatedButton
        (
          onPressed: ()
          {
            Navigator.of(context).pushNamed('/start');
          },
          child: const Text('开始使用'),
        ),
      ),
    );
  }
}