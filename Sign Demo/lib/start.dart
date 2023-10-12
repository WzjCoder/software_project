import 'package:flutter/material.dart';

class StartPage extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Second Page'),
      ),
      body: const Center
      (
        child: Text('This is the second page.'),
      ),
    );
  }
}
