
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
      score: json['score'] as int?,
      keyWord: json['keyWord'] as String?,
      lon: json['lon'] as double?,
      level: json['level'] as String?,
      lat: json['lat'] as double?,
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
}
