/// 行政区数据模型，resultType=3时返回
class Area {
  /// 名称
  final String? name;

  /// 定位范围("minx,miny,maxx,maxy")
  final String? bound;

  /// 定位中心点坐标
  final String? lonlat;

  /// 行政区编码
  final int? adminCode;

  /// 显示级别，1-18级
  final int? level;

  /// 创建Area实例
  Area({this.name, this.bound, this.lonlat, this.adminCode, this.level});

  /// 从JSON字符串解析Area
  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      name: json['name'] as String?,
      bound: json['bound'] as String?,
      lonlat: json['lonlat'] as String?,
      adminCode: json['adminCode'] as int?,
      level: json['level'] as int?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bound': bound,
      'lonlat': lonlat,
      'adminCode': adminCode,
      'level': level,
    };
  }
}
