
/// 省份信息模型
class PriorityProvince {
  /// 行政名称
  final String? name;
  
  /// 包含数量
  final String? count;
  
  /// 行政区经纬度，坐标x,y
  final String? lonlat;
  
  /// 省国标码
  final String? adminCode;
  
  /// 英文行政名称
  final String? ename;
  
  /// 有无下一级行政区，有则false，无则true
  final String? isleaf;

  /// 创建PriorityProvince实例
  PriorityProvince({
    this.name,
    this.count,
    this.lonlat,
    this.adminCode,
    this.ename,
    this.isleaf,
  });

  /// 从JSON字符串解析PriorityProvince
  factory PriorityProvince.fromJson(Map<String, dynamic> json) {
    return PriorityProvince(
      name: json['name'] as String?,
      count: json['count'] as String?,
      lonlat: json['lonlat'] as String?,
      adminCode: json['adminCode'] as String?,
      ename: json['ename'] as String?,
      isleaf: json['isleaf'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
      'lonlat': lonlat,
      'adminCode': adminCode,
      'ename': ename,
      'isleaf': isleaf,
    };
  }
}
