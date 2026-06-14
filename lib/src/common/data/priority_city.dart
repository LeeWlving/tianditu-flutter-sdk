/// 推荐行政区城市模型
class PriorityCity {
  /// 行政区名称
  final String? name;

  /// 城市数量
  final int? count;

  /// 行政区经纬度，坐标 x，y
  final String? lonlat;

  /// 英文行政名称
  final String? ename;

  /// 城市国标码，9位国标码
  final String? adminCode;

  /// 创建PriorityCity实例
  PriorityCity({
    this.name,
    this.count,
    this.lonlat,
    this.ename,
    this.adminCode,
  });

  /// 从JSON字符串解析PriorityCity
  factory PriorityCity.fromJson(Map<String, dynamic> json) {
    return PriorityCity(
      name: json['name'] as String?,
      count: json['count'] as int?,
      lonlat: json['lonlat'] as String?,
      ename: json['ename'] as String?,
      adminCode: json['adminCode'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
      'lonlat': lonlat,
      'ename': ename,
      'adminCode': adminCode,
    };
  }
}
