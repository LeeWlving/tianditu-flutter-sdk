
/// 地图显示范围模型
class DriveMapinfo {
  /// 全部结果同时显示的适宜中心经纬度
  final String? center;
  
  /// 全部结果同时显示的适宜缩放比例
  final double? scale;

  /// 创建DriveMapinfo实例
  DriveMapinfo({
    this.center,
    this.scale,
  });

  /// 从JSON字符串解析DriveMapinfo
  factory DriveMapinfo.fromJson(Map<String, dynamic> json) {
    return DriveMapinfo(
      center: json['center'] as String?,
      scale: json['scale'] as double?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'center': center,
      'scale': scale,
    };
  }
}
