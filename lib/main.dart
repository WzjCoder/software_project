import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/HomePage_Stu.dart';
import 'package:flutter_auth/Screens/Login/components/login_form.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/constants.dart';


const baseUrl = "http://localhost:8080";

void mySnackbar(String msg,BuildContext context,[int ms = 500, bool isquick = false]) {
  if(isquick) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: ms),
      behavior: SnackBarBehavior.floating,
      content: Text(msg),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {
          
        },
      ),
    ),
  );
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: const WelcomeScreen(),
      routes: {
        '/SignIn':(context) => const LoginScreen(),
        '/HomeStu':(context) => const HomePage_Stu(),
        '/HomeTea':(context) => const HomePage_Stu(),   //TOMODIFY
        '/HomeAdmin':(context) => const HomePage_Stu(), //TOMODIFY
      },
    );
  }
}
