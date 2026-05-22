import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../tianditu_service.dart';
import 'tianditu_exception.dart';

/// 基础服务类，所有服务类的基类
class BaseService {
  /// HTTP客户端
  final http.Client client = http.Client();

  /// 天地图密钥
  final String tk;

  /// 创建BaseService实例
  /// [tk] 天地图密钥
  BaseService(this.tk);

  String _buildHttpErrorMessage(http.Response response) {
    final body = response.body.trim();
    final statusMessage = 'HTTP请求失败: ${response.statusCode}';

    if (body.isEmpty) {
      return statusMessage;
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final message =
            decoded['resolve'] ??
            decoded['msg'] ??
            decoded['message'] ??
            decoded['error'];

        if (message != null && message.toString().trim().isNotEmpty) {
          return '$statusMessage, ${message.toString().trim()}';
        }
      }
    } catch (_) {
      // 非 JSON 错误响应时，直接使用响应体作为服务端提示。
    }

    const maxBodyLength = 200;
    final bodyMessage = body.length > maxBodyLength
        ? '${body.substring(0, maxBodyLength)}...'
        : body;

    return '$statusMessage, $bodyMessage';
  }

  /// 发送请求，返回指定类型的对象
  /// [uri] 接口路径
  /// [fromJson] JSON转换函数
  /// [fromXml] XML转换函数（可选）
  Future<T> request<T>(
    String uri,
    T Function(Map<String, dynamic>) fromJson, {
    T Function(XmlDocument)? fromXml,
  }) async {
    final url = '${TiandituService.uri}$uri&tk=$tk';

    // 发送HTTP请求
    final response = await client.get(Uri.parse(url));
    debugPrint('response:${response.body}');
    // 检查响应状态
    if (response.statusCode != 200) {
      throw TiandituException(_buildHttpErrorMessage(response));
    }

    final body = response.body;
    final contentType = response.headers['content-type'] ?? '';

    // 根据Content-Type选择解析方式
    if (contentType.contains('application/json') ||
        contentType.contains('text/json')) {
      // JSON响应处理
      final json = jsonDecode(body) as Map<String, dynamic>;

      // 检查错误码
      if (json.containsKey('code') && json['code'] != 0) {
        throw TiandituException(
          'API错误: ${json['cndesc'] ?? json['msg'] ?? '未知错误'}',
        );
      }

      return fromJson(json);
    } else if (body.startsWith('<?xml')) {
      // XML响应处理
      if (fromXml == null) {
        throw TiandituException('XML响应但未提供fromXml解析函数');
      }

      final document = XmlDocument.parse(body);
      return fromXml(document);
    } else {
      // 默认处理为JSON
      final json = jsonDecode(body) as Map<String, dynamic>;
      return fromJson(json);
    }
  }

  /// 发送请求，返回字节数组
  /// [uri] 接口路径
  Future<Uint8List> requestBytes(String uri) async {
    final url = '${TiandituService.uri}$uri&tk=$tk';

    // 发送HTTP请求
    final response = await client.get(Uri.parse(url));

    // 检查响应状态
    if (response.statusCode != 200) {
      throw TiandituException(_buildHttpErrorMessage(response));
    }

    return response.bodyBytes;
  }
}
