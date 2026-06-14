/// 线路数据模型
class Line {
  /// 站数量
  final String? stationNum;

  /// 类型为"103"
  final String? poiType;

  /// 线路名称
  final String? name;

  /// 线路id
  final String? uuid;

  /// 创建Line实例
  Line({this.stationNum, this.poiType, this.name, this.uuid});

  /// 从JSON字符串解析Line
  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      stationNum: json['stationNum'] as String?,
      poiType: json['poiType'] as String?,
      name: json['name'] as String?,
      uuid: json['uuid'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'stationNum': stationNum,
      'poiType': poiType,
      'name': name,
      'uuid': uuid,
    };
  }
}
