
/// 经纬度地址模型
class Location {
  /// 匹配分
  final int? score;
  
  /// 关键字
  final String? keyWord;
  
  /// 坐标点显示经度
  final double? lon;
  
  /// 类别名称
  final String? level;
  
  /// 坐标点显示纬度
  final double? lat;

  /// 创建Location实例
  Location({
    this.score,
    this.keyWord,
    this.lon,
    this.level,
    this.lat,
  });

  /// 从JSON字符串解析Location
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      score: _asInt(json['score']),
      keyWord: json['keyWord'] as String?,
      lon: _asDouble(json['lon']),
      level: json['level'] as String?,
      lat: _asDouble(json['lat']),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'keyWord': keyWord,
      'lon': lon,
      'level': level,
      'lat': lat,
    };
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
