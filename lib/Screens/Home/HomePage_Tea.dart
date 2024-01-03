// ignore_for_file: camel_case_types, file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/check/code2check.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/main.dart';

import '../check/my.dart';
import '../check/qr2check.dart';
void main() => runApp(const MaterialApp(home: HomePage_Tea()));

class HomePage_Tea extends StatefulWidget {
  const HomePage_Tea({super.key});

  @override
  HPT createState() => HPT(); 
}

class HPT extends State<HomePage_Tea> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    const code2check(),
    qr2check(),
    MyHomePage(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 182, 222, 255), Color.fromARGB(255, 179, 255, 235)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Align(
            alignment: const Alignment(0, -0.5),
            child: _children[_currentIndex],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '签到码签到',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: '二维码签到',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class Checkinmethods {
  final dio = Dio();
  bool quick = true;

  Future<void> checkin(String checkcode, int checkid, BuildContext context) async {
    var response = await dio.post(
      '$baseUrl/api/User/usercheckin',
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
      data: {
        'checkcode':checkcode,
        'checkid':checkid,
      },
    );

    Map<String,dynamic> ret = response.data;
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    mySnackbar(ret['message'], context, 2000, quick);
  }
}