import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../tianditu_service.dart';
import 'tianditu_exception.dart';

/// 基础服务类，所有服务类的基类
class BaseService {
  /// HTTP客户端
  final http.Client client;

  /// 天地图密钥
  final String tk;

  /// API 根地址。
  final Uri baseUri;

  /// 单次请求超时时间。
  final Duration timeout;

  final bool _ownsClient;

  /// 创建BaseService实例
  /// [tk] 天地图密钥
  BaseService(
    this.tk, {
    http.Client? client,
    Uri? baseUri,
    this.timeout = const Duration(seconds: 15),
  }) : client = client ?? http.Client(),
       baseUri = baseUri ?? Uri.parse(TiandituService.defaultBaseUrl),
       _ownsClient = client == null {
    if (tk.trim().isEmpty) {
      throw ArgumentError.value(tk, 'tk', 'must not be empty');
    }
  }

  /// 发送请求，返回指定类型的对象
  /// [uri] 接口路径
  /// [fromJson] JSON转换函数
  /// [fromXml] XML转换函数（可选）
  Future<T> request<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, String?> queryParameters = const {},
    T Function(XmlDocument)? fromXml,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final http.Response response;
    try {
      response = await client.get(uri).timeout(timeout);
    } catch (error) {
      throw TiandituException('网络请求失败', uri: uri, cause: error);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw TiandituException(
        'HTTP 请求失败',
        statusCode: response.statusCode,
        uri: uri,
      );
    }

    final body = utf8.decode(response.bodyBytes);
    final contentType = response.headers['content-type'] ?? '';

    try {
      if (contentType.contains('xml') || body.trimLeft().startsWith('<')) {
        if (fromXml == null) {
          throw TiandituException('接口返回 XML，但没有提供 XML 解析器', uri: uri);
        }
        return fromXml(XmlDocument.parse(body));
      }

      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw TiandituException('接口返回了无效的 JSON 对象', uri: uri);
      }
      final code = decoded['code'] ?? decoded['infocode'];
      if (code != null && code.toString() != '0' && code.toString() != '1000') {
        throw TiandituException(
          (decoded['cndesc'] ?? decoded['msg'] ?? '天地图接口返回错误').toString(),
          uri: uri,
        );
      }
      return fromJson(decoded);
    } on TiandituException {
      rethrow;
    } catch (error) {
      throw TiandituException('响应解析失败', uri: uri, cause: error);
    }
  }

  /// 发送请求，返回字节数组
  /// [uri] 接口路径
  Future<Uint8List> requestBytes(
    String path, {
    Map<String, String?> queryParameters = const {},
  }) async {
    final uri = _buildUri(path, queryParameters);
    final http.Response response;
    try {
      response = await client.get(uri).timeout(timeout);
    } catch (error) {
      throw TiandituException('网络请求失败', uri: uri, cause: error);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw TiandituException(
        'HTTP 请求失败',
        statusCode: response.statusCode,
        uri: uri,
      );
    }

    return response.bodyBytes;
  }

  Uri _buildUri(String path, Map<String, String?> queryParameters) {
    final parameters = <String, String>{
      for (final entry in queryParameters.entries)
        if (entry.value != null) entry.key: entry.value!,
      'tk': tk,
    };
    return baseUri.resolve(path).replace(queryParameters: parameters);
  }

  /// 释放此服务自行创建的 HTTP 客户端。
  void close() {
    if (_ownsClient) {
      client.close();
    }
  }
}
