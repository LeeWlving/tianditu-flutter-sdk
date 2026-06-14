/// 简单分段线路信息模型
class SimpleItem {
  /// 序号
  final int? id;

  /// 每段线路文字描述
  final String? strguide;

  /// 当前行驶路段名称（含多个路段）
  final String? streetNames;

  /// 最后一段道路名称
  final String? lastStreetName;

  /// 合并段之间衔接的道路名称
  final String? linkStreetName;

  /// 路牌”引导提示/高速路收费站出口信息
  final String? signage;

  /// 道路收费信息：0=免费路段，1=收费路段，2=部分收费路段
  final int? tollStatus;

  /// 折点经纬度
  final String? turnlatlon;

  /// 线路经纬度
  final String? streetLatLon;

  /// 行驶总距离（单位：米）
  final String? streetDistance;

  /// 合并后的号段，对应详细描述中的号段
  final String? segmentNumber;

  /// 创建SimpleItem实例
  SimpleItem({
    this.id,
    this.strguide,
    this.streetNames,
    this.lastStreetName,
    this.linkStreetName,
    this.signage,
    this.tollStatus,
    this.turnlatlon,
    this.streetLatLon,
    this.streetDistance,
    this.segmentNumber,
  });

  /// 从JSON字符串解析SimpleItem
  factory SimpleItem.fromJson(Map<String, dynamic> json) {
    return SimpleItem(
      id: json['id'] as int?,
      strguide: json['strguide'] as String?,
      streetNames: json['streetNames'] as String?,
      lastStreetName: json['lastStreetName'] as String?,
      linkStreetName: json['linkStreetName'] as String?,
      signage: json['signage'] as String?,
      tollStatus: json['tollStatus'] as int?,
      turnlatlon: json['turnlatlon'] as String?,
      streetLatLon: json['streetLatLon'] as String?,
      streetDistance: json['streetDistance'] as String?,
      segmentNumber: json['segmentNumber'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'strguide': strguide,
      'streetNames': streetNames,
      'lastStreetName': lastStreetName,
      'linkStreetName': linkStreetName,
      'signage': signage,
      'tollStatus': tollStatus,
      'turnlatlon': turnlatlon,
      'streetLatLon': streetLatLon,
      'streetDistance': streetDistance,
      'segmentNumber': segmentNumber,
    };
  }
}
