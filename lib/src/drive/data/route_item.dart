/// 路径分段模型
class RouteItem {
  /// 序号
  final int? id;

  /// 每段线路文字描述
  final String? strguide;

  /// “路牌”引导提示/高速路收费站出口信息
  final String? signage;

  /// 当前路段名称
  final String? streetName;

  /// 下一段道路名称
  final String? nextStreetName;

  /// 道路收费信息：0=免费路段，1=收费路段，2=部分收费路段
  final int? tollStatus;

  /// 转折点经纬度
  final String? turnlatlon;

  /// 创建RouteItem实例
  RouteItem({
    this.id,
    this.strguide,
    this.signage,
    this.streetName,
    this.nextStreetName,
    this.tollStatus,
    this.turnlatlon,
  });

  /// 从JSON字符串解析RouteItem
  factory RouteItem.fromJson(Map<String, dynamic> json) {
    return RouteItem(
      id: json['id'] as int?,
      strguide: json['strguide'] as String?,
      signage: json['signage'] as String?,
      streetName: json['streetName'] as String?,
      nextStreetName: json['nextStreetName'] as String?,
      tollStatus: json['tollStatus'] as int?,
      turnlatlon: json['turnlatlon'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'strguide': strguide,
      'signage': signage,
      'streetName': streetName,
      'nextStreetName': nextStreetName,
      'tollStatus': tollStatus,
      'turnlatlon': turnlatlon,
    };
  }
}
