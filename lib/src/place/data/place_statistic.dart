
import '../../common/data/priority_city.dart';
import '../../common/data/priority_province.dart';

/// 地名搜索统计结果模型
class PlaceStatistic {
  /// 本次统计POI总数量
  final int? count;
  
  /// 行政区数量
  final int? adminCount;
  
  /// 推荐行政区名称
  final List<PriorityCity>? priorityCitys;
  
  /// 各省包含信息集合
  final List<PriorityProvince>? allAdmins;

  /// 创建PlaceStatistic实例
  PlaceStatistic({
    this.count,
    this.adminCount,
    this.priorityCitys,
    this.allAdmins,
  });

  /// 从JSON字符串解析PlaceStatistic
  factory PlaceStatistic.fromJson(Map<String, dynamic> json) {
    return PlaceStatistic(
      count: json['count'] as int?,
      adminCount: json['adminCount'] as int?,
      priorityCitys: json['priorityCitys'] != null
          ? (json['priorityCitys'] as List<dynamic>)
              .map((e) => PriorityCity.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      allAdmins: json['allAdmins'] != null
          ? (json['allAdmins'] as List<dynamic>)
              .map((e) => PriorityProvince.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'adminCount': adminCount,
      'priorityCitys': priorityCitys?.map((e) => e.toJson()).toList(),
      'allAdmins': allAdmins?.map((e) => e.toJson()).toList(),
    };
  }
}
