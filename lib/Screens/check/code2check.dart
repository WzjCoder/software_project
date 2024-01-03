// ignore_for_file: camel_case_types, non_constant_identifier_names, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:excel/excel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/main.dart';

import '../../StoreToken.dart';
import '../../constants.dart';

String checkin_code = '无';
String checkin_id = '无';
List<dynamic> checkinfo = [];
final methods = code2checkMethods();

class code2check extends StatefulWidget {
  const code2check({super.key});

  @override
  _code2checkState createState() => _code2checkState();
}

class _code2checkState extends State<code2check> {
  bool recheck = false;
  final checkClass = TextEditingController();
  final time2check = TextEditingController();
  final recheckid = TextEditingController();
  final recheckuserid = TextEditingController();
  bool _isButtonDisabled = false;
  bool allow_export = false;

  void _startTimer() {
    int _countdownTime = int.parse(time2check.text);
    Timer(Duration(seconds: _countdownTime), () {
      setState(() {
        _isButtonDisabled = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView (
        reverse: true,
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding / 20),
              child: TextFormField(
                controller: checkClass,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  hintText: "发起签到的班级",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.class_rounded),
                  ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding / 20),
              child: TextFormField(
                controller: time2check,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  hintText: "签到时长(s)",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.timer_rounded),
                  ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: _isButtonDisabled ? null : () async {
                setState(() {
                  _isButtonDisabled = true;
                  allow_export = false;
                });
                await methods.post2check(checkClass.text,int.parse(time2check.text));
                setState(() {
                  
                });
                await Future.delayed(const Duration(milliseconds: 100));
                if (!context.mounted) return;
                await methods.start2check(context,checkClass.text,int.parse(time2check.text));
                setState(() {
                  allow_export = true;
                });
                _startTimer();
              },
              child: _isButtonDisabled ? const CircularProgressIndicator() : const Text('发起签到'),
            ),
            const SizedBox(height: defaultPadding),
            Text('签到码为 $checkin_code',style: const TextStyle(fontSize: 18),),
            Text('签到id为 $checkin_id',style: const TextStyle(fontSize: 18),),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: !allow_export ? null :() async {
                await methods.createExcelAndOpen();
              },
              child: !allow_export ? const Text('等待签到完成') : const Text('导出签到记录'),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  recheck = !recheck;
                });
              },
              child: !recheck ? const Text('补签') : const Text('收起补签'),
            ),
            const SizedBox(height: defaultPadding),
            recheck ? TextFormField(
              controller: recheckid,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "补签id",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.event),
                ),
              ),
            ): const Text(''),
            const SizedBox(height: defaultPadding),
            recheck ? TextFormField(
              controller: recheckuserid,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "用户id",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person_2_rounded),
                ),
              ),
            ): const Text(''),
            const SizedBox(height: defaultPadding),
            recheck ? ElevatedButton(
              onPressed: () async {
                await methods.recheck(context, int.parse(recheckid.text), int.parse(recheckuserid.text));
              },
              child: const Text('确认补签'),
            ): const Text(''),
          ],
        ),
      ),)
    );
  }
}


class code2checkMethods {
  final dio = Dio(BaseOptions(receiveTimeout: const Duration(seconds: 10000)));
  late Map<String,dynamic> ret1;

  Future<void> post2check(String cls, int ti) async {
    String token = await getToken();
    var response = await dio.post(
      '$baseUrl/api/User/postcheckin',
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Cookie': token,
        }
      ),
      data: {
        'classes':cls,
        'length':ti,
      },
    );
    ret1 = response.data;
    checkin_code = ret1['data']['code'].toString();
    checkin_id = ret1['data']['checkid'].toString();
  }

  Future<void> start2check(BuildContext context, String cls, int ti) async {
    // print('$checkin_id, $cls, $ti');
    String token = await getToken();
    var response1 = await dio.post(
      '$baseUrl/api/User/startcheckin',
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Cookie': token,
        }
      ),
      queryParameters: {
        'classes':cls,
        'length':ti,
        'checkid':checkin_id,
      },
    );

    Map<String,dynamic> ret2 = response1.data;
    checkinfo = ret2['data'];
    // print(checkinfo);

    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    mySnackbar(ret2['message'], context);
  }

  Future<void> recheck(BuildContext context, int ckid, int usrid) async {
    String token = await getToken();
    var response1 = await dio.post(
      '$baseUrl/api/User/recheckin',
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Cookie': token,
        }
      ),
      data: {
        'checkid':ckid,
        'userid':usrid,
      },
    );

    Map<String,dynamic> ret2 = response1.data;

    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    mySnackbar(ret2['message'], context);
  }

  Future<void> createExcelAndOpen() async {
    // 确保checkinfo是List<String>类型
    List<String> data = List<String>.from(checkinfo.cast<String>());
    data.insert(0, '未签到人员名单');
    // 创建一个Excel文档
    var excel = Excel.createExcel();
    Sheet sheet = excel['SheetName'];

    // 在Excel文档中添加数据
    for (int i = 0; i < data.length; i++) {
      String item = data[i];
      int row = i + 1;
      sheet.cell(CellIndex.indexByString('A$row')).value = TextCellValue(item);
    }

    // 获取当前时间
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMddHHmm').format(now);

    // 保存并关闭文档
    var bytes = excel.save();

    // 获取应用支持目录
    Directory appDocDir = await getApplicationSupportDirectory();
    String path = appDocDir.path;

    // 创建一个文件来保存Excel文档
    File file = File('$path/未签到人员名单_$formattedDate.xlsx');
    await file.writeAsBytes(bytes!, flush: true);

    // 使用其他应用打开文件
    OpenFile.open(file.path);
  }
}