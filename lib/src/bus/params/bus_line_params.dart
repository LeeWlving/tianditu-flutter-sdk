/// 公交规划请求参数模型
class BusLineParams {
  /// 出发点坐标，格式："经度，纬度"
  final String startposition;

  /// 终点坐标，格式："经度，纬度"
  final String endposition;

  /// 获取线路规划类型(按位判断规划类型，以支持同时获取多种规划结果)
  /// 第0位为1，较快捷；
  /// 第1位为1，少换乘；
  /// 第2位为1，少步行；
  /// 第3位为1，不坐地铁。
  /// 默认值：1（较快捷）
  final int linetype;

  /// 创建BusLineParams实例
  BusLineParams({
    required this.startposition,
    required this.endposition,
    this.linetype = 1,
  });

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'startposition': startposition,
      'endposition': endposition,
      'linetype': linetype,
    };
  }
}
