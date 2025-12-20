
/// 驾车规划参数模型
class DriveParams {
  /// 起点经纬度，格式：x,y，范围：-180,-90,180,90
  final String orig;
  
  /// 终点经纬度，格式：x,y，范围：-180,-90,180,90
  final String dest;
  
  /// 途径点经纬度字符串
  /// 格式：116.35506,39.92277;116.35506,39.92277
  /// 两个坐标之间以分号隔开，坐标xy之间用逗号隔开(都是半角)
  final String? mid;
  
  /// 导航路线类型，默认值：0
  /// 0：最快路线，1：最短路线，2：避开高速，3：步行
  final int style;

  /// 创建DriveParams实例
  DriveParams({
    required this.orig,
    required this.dest,
    this.mid,
    this.style = 0,
  });

  /// 从JSON字符串解析DriveParams
  factory DriveParams.fromJson(Map<String, dynamic> json) {
    return DriveParams(
      orig: json['orig'] as String,
      dest: json['dest'] as String,
      mid: json['mid'] as String?,
      style: json['style'] as int? ?? 0,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'orig': orig,
      'dest': dest,
      'mid': mid,
      'style': style,
    };
  }
}
