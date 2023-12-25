// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: HomePage_Stu()));

class HomePage_Stu extends StatefulWidget {
  const HomePage_Stu({super.key});

  @override
  HPS createState() => HPS(); 
}

class HPS extends State<HomePage_Stu> {
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is Home Page'),
    );
  }
}