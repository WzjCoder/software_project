import 'package:flutter/material.dart';
import 'package:test1/start.dart';
import 'package:flutter/cupertino.dart';

// class CustomPageRoute<T> extends PageRouteBuilder<T> 
// {
//   final Widget child;

//   CustomPageRoute({required this.child})
//       : super(
//           pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
//             return child;
//           },
//           transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
//             return FadeTransition(
//               opacity: animation,
//               child: child,
//             );
//           },
//         );
// }

void main() => runApp(const Sign());

class Sign extends StatelessWidget
{
  const Sign({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: const HomePage(),
      routes: 
      {
        '/start':(context) => const StartPage(),
        '/main':(context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget
{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        automaticallyImplyLeading: false,
        title: const Text('Sign Demo'),
      ),
      body: Center
      (
        child: ElevatedButton
        (
          onPressed: ()
          {
            Navigator.of(context).push(CupertinoPageRoute(builder:(context) => const StartPage()));
          },
          child: const Text('开始使用'),
        ),
      ),
    );
  }
}