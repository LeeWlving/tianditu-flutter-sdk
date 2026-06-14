/// 天地图服务异常
class TiandituException implements Exception {
  /// 异常消息
  final String message;

  /// HTTP 状态码。
  final int? statusCode;

  /// 发生异常的请求地址。
  final Uri? uri;

  /// 原始异常。
  final Object? cause;

  /// 创建TiandituException实例
  const TiandituException(
    this.message, {
    this.statusCode,
    this.uri,
    this.cause,
  });

  @override
  String toString() {
    final status = statusCode == null ? '' : ' ($statusCode)';
    return 'TiandituException$status: $message';
  }
}
