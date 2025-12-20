
/// 天地图服务异常
class TiandituException implements Exception {
  /// 异常消息
  final String message;

  /// 创建TiandituException实例
  TiandituException(this.message);

  @override
  String toString() => 'TiandituException: $message';
}
