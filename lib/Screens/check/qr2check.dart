// ignore_for_file: camel_case_types

import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
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

List<dynamic> checkinfo = [];
String checkin_code = '无';
Map<String,dynamic> qr_code = {};

class qr2check extends StatefulWidget {
  @override
  _qr2checkState createState() => _qr2checkState();
}

class _qr2checkState extends State<qr2check> {
  final checkClass = TextEditingController();
  final time2check = TextEditingController();
  bool _isButtonDisabled = false;
  bool allow_export = false;
  final methods = qr2checkMethods();

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
      body: SingleChildScrollView( reverse: true,
        child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100,),
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
                _startTimer();
                setState(() {
                  
                });
                await Future.delayed(const Duration(milliseconds: 100));
                if (!context.mounted) return;
                await methods.start2check(context,checkClass.text,int.parse(time2check.text));
                setState(() {
                  allow_export = true;
                });
              },
              child: _isButtonDisabled ? const CircularProgressIndicator() : const Text('发起签到'),
            ),
            const SizedBox(height: defaultPadding),
            QrImageView(
              data: qr_code.isEmpty ? '签到未开始' : qr_code.toString(),
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: !allow_export ? null :() async {
                await methods.createExcelAndOpen();
              },
              child: !allow_export ? const Text('等待签到完成') : const Text('导出签到记录'),
            )
          ],
        ),
      ),
      )
    );
  }
}

class qr2checkMethods {
  final dio = Dio();
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
    qr_code['checkid'] = ret1['data']['checkid'];
    qr_code['checkcode'] = ret1['data']['code'];
  }

  Future<void> start2check(BuildContext context, String cls, int ti) async {
    checkin_code = ret1['data']['code'].toString();
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
        'checkid':ret1['data']['checkid'],
      },
    );

    Map<String,dynamic> ret2 = response1.data;
    checkinfo = ret2['data'];
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