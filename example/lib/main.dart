import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tianditu/tianditu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = '天地图Flutter SDK示例';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // 测试地理编码功能
  Future<void> testGeocode() async {
    setState(() {
      _isLoading = true;
      _result = '正在测试地理编码...';
    });

    try {
      // 注意：这里需要替换为你自己的API密钥
      final tiandituService = TiandituService('your_tian_di_tu_api_key');
      final geoCoderService = tiandituService.getGeoCoderService();

      // 测试地址转坐标
      final result = await geoCoderService.addressToLocation('北京市海淀区中关村南大街5号');
      
      setState(() {
        if (result.location != null) {
          _result = '地理编码成功！\n' 
            '状态: ${result.status}\n' 
            '信息: ${result.msg}\n' 
            '坐标: ${result.location!.lon}, ${result.location!.lat}';
        } else {
          _result = '地理编码成功，但未返回坐标\n' 
            '状态: ${result.status}\n' 
            '信息: ${result.msg}';
        }
      });
    } catch (e) {
      setState(() {
        _result = '地理编码失败: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('天地图Flutter SDK示例')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_result),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: testGeocode,
                        child: const Text('测试地理编码'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
