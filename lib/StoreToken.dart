import 'package:shared_preferences/shared_preferences.dart';

// 保存token
Future<void> saveToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

// 获取token
Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  if (token == null) {
    throw Exception('Token not found');
  }
  return token;
}