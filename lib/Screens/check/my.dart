import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/main.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:excel/excel.dart';
import '../../StoreToken.dart';
import '../../constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final cls = TextEditingController();
final queryid = TextEditingController();

bool showtable = false;
bool showtableid = false;
List<Map<String,dynamic>> classcheckinfo = [];
List<Map<String,dynamic>> idcheckinfo = [];

class _MyHomePageState extends State<MyHomePage> {
  String username = currentInfo['userAccount'];
  final dio = Dio();

  Future<void> logout() async {
    String token = await getToken();
    var res = await dio.post(
      '$baseUrl/api/User/logout',
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Cookie': token,
        }
      ),
    );
    Map<String,dynamic> ret = res.data;
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    mySnackbar(ret['message'], context);
    if(ret['message'] == 'ok') {
      Navigator.of(context).pop();
    }
  }

  Future<void> checklog() async {
    setState(() {
      showtable = false;
    });
    String token = await getToken();
    var res = await dio.post(
      '$baseUrl/api/User/searchcheckinlogs',
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Cookie': token,
        }
      ),
      queryParameters: {
        'classes':cls.text,
      }
    );

    Map<String,dynamic> ret = res.data;
    classcheckinfo = List<Map<String,dynamic>>.from(ret['data']);
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    mySnackbar(ret['message'], context,3000);
    if(ret['data'].length > 0) {
      setState(() {
        showtable = true;
      });
    } else {
      setState(() {
        showtable = false;
      });
    }
  }

  Future<void> checkidlog() async {
    setState(() {
      showtableid = false;
    });
    String token = await getToken();
    var res = await dio.post(
      '$baseUrl/api/User/searchonechecklog',
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Cookie': token,
        }
      ),
      queryParameters: {
        'checkid':queryid.text,
      }
    );

    Map<String,dynamic> ret = res.data;
    idcheckinfo = List<Map<String,dynamic>>.from(ret['data']);

    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    mySnackbar(ret['message'], context,3000);
    if(idcheckinfo.length > 1) {
      setState(() {
        showtableid = true;
      });
    } else {
      setState(() {
        showtableid = false;
      });
    }
  }

  Future<void> deleteAccount() async {
    String token = await getToken();
    var res = await dio.post(
      '$baseUrl/api/User/delete',
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Cookie': token,
        }
      ),
    );

    Map<String,dynamic> ret = res.data['data'];
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;
    mySnackbar(ret['message'], context);
    if(ret['message'] == 'ok') {
      Navigator.of(context).pop();
    }
  }

  Future<void> createExcelAndOpen1() async {
    List<Map<String,dynamic>> data = List<Map<String,dynamic>>.from(classcheckinfo.cast<Map<String,dynamic>>());
    // 创建一个Excel文档
    var excel = Excel.createExcel();
    Sheet sheet = excel['已发布的签到'];

    // 添加列标题
    List<String> headers = ["checkid", "userid", "checkdate", "code", "classes", "length"];
    List<String> zhcn = ["签到ID", "用户ID", "签到时间", "签到码", "班级", "签到时长"];
    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(zhcn[i].toString());;
    }

    // 在Excel文档中添加数据
    for (int i = 0; i < data.length; i++) {
      Map<String,dynamic> item = data[i];
      int row = i + 1;
      for (int j = 0; j < headers.length; j++) {
        String key = headers[j];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: row)).value = TextCellValue(item[key].toString());
      }
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
    File file = File('$path/已发布的签到_$formattedDate.xlsx');
    await file.writeAsBytes(bytes!, flush: true);

    // 使用其他应用打开文件
    OpenFile.open(file.path);
  }

  Future<void> createExcelAndOpen2() async {
    List<Map<String,dynamic>> data = List<Map<String,dynamic>>.from(idcheckinfo.cast<Map<String,dynamic>>());
    // 创建一个Excel文档
    var excel = Excel.createExcel();
    Sheet sheet = excel['签到ID为 ${queryid.text} 的签到结果'];

    // 添加列标题
    List<String> headers = ['id','name','ischeckin'];
    List<String> zhcn = ['用户ID','姓名','是否签到'];
    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(zhcn[i].toString());
    }

    // 在Excel文档中添加数据
    for (int i = 1; i < data.length; i++) {
      Map<String,dynamic> item = data[i];
      int row = i;
      for (int j = 0; j < headers.length; j++) {
        String key = headers[j];
        if(headers[j] == 'ischeckin') {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: row)).value = TextCellValue(item[key] == 1 ? '是' : '否');
        } else {
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: row)).value = TextCellValue(item[key].toString());
        }
      }
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
    File file = File('$path/签到ID为 ${queryid.text} 的签到结果_$formattedDate.xlsx');
    await file.writeAsBytes(bytes!, flush: true);

    // 使用其他应用打开文件
    OpenFile.open(file.path);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '用户名: $username',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: defaultPadding),
            const Text('查询签到班级'),
            const SizedBox(height: defaultPadding),
            TextField(
              controller: cls,
              decoration: const InputDecoration(
                hintText: '请输入查询签到的班级',
              ),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () async {
                await checklog();
              },
              child: const Text('提交'),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: showtable ? () async {
                await createExcelAndOpen1();
              } : null,
              child: showtable ? const Text('查看结果') : const Text('无查询结果'),
            ),
            const SizedBox(height: defaultPadding),
            const Text('查询单次签到的结果'),
            const SizedBox(height: defaultPadding),
            TextField(
              controller: queryid,
              decoration: const InputDecoration(
                hintText: '请输入签到ID',
              ),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () async {
                await checkidlog();
              },
              child: const Text('提交'),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: showtableid ? () async {
                await createExcelAndOpen2();
              } : null,
              child: showtableid ? const Text('查看结果') : const Text('无查询结果'),
            ),
            const SizedBox(height: defaultPadding),
            CupertinoButton(
              onPressed: () async {
                await logout();
              },
              child: const Text('退出登录'),
            ),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    ));
  }
}
