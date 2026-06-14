/// 车站信息结构体
class StationData {
  /// 线路名称
  final String? lineName;

  /// 线路的id
  final String? uuid;

  /// 公交站uuid
  final String? stationUuid;

  /// 创建StationData实例
  StationData({this.lineName, this.uuid, this.stationUuid});

  /// 从JSON字符串解析StationData
  factory StationData.fromJson(Map<String, dynamic> json) {
    return StationData(
      lineName: json['lineName'] as String?,
      uuid: json['uuid'] as String?,
      stationUuid: json['stationUuid'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {'lineName': lineName, 'uuid': uuid, 'stationUuid': stationUuid};
  }
}
