import '../../common/data/area.dart';
import '../../common/data/line.dart';
import '../../common/data/poi.dart';
import '../../common/data/status.dart';
import 'place_statistic.dart';

/// 地名搜索结果模型
class PlaceSearchResult {
  /// 返回结果类型
  /// 取值1-5，对应不同的响应类型：
  /// 1（普通POI），
  /// 2（统计），
  /// 3（行政区)，
  /// 4（建议词搜索），
  /// 5（线路结果）
  final int? resultType;

  /// 返回总条数
  final int? count;

  /// 搜索关键词
  final String? keyword;

  /// 针对点（类型1）集合返回： resultType=1
  final List<Poi>? pois;

  /// 针对统计（类型2）集合返回： resultType=2
  final List<PlaceStatistic>? statistics;

  /// 针对行政区省（类型3）集合点： resultType=3
  final List<Area>? area;

  /// 线路结果： resultType=5
  final List<Line>? lineData;

  /// 返回状态信息
  final Status? status;

  /// 创建PlaceSearchResult实例
  PlaceSearchResult({
    this.resultType,
    this.count,
    this.keyword,
    this.pois,
    this.statistics,
    this.area,
    this.lineData,
    this.status,
  });

  /// 从JSON字符串解析PlaceSearchResult
  factory PlaceSearchResult.fromJson(Map<String, dynamic> json) {
    return PlaceSearchResult(
      resultType: json['resultType'] as int?,
      count: json['count'] as int?,
      keyword: json['keyword'] as String?,
      pois: json['pois'] != null
          ? (json['pois'] as List<dynamic>)
                .map((e) => Poi.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      statistics: json['statistics'] != null
          ? (json['statistics'] as List<dynamic>)
                .map((e) => PlaceStatistic.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      area: json['area'] != null
          ? (json['area'] as List<dynamic>)
                .map((e) => Area.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      lineData: json['lineData'] != null
          ? (json['lineData'] as List<dynamic>)
                .map((e) => Line.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      status: json['status'] != null
          ? Status.fromJson(json['status'] as Map<String, dynamic>)
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'resultType': resultType,
      'count': count,
      'keyword': keyword,
      'pois': pois?.map((e) => e.toJson()).toList(),
      'statistics': statistics?.map((e) => e.toJson()).toList(),
      'area': area?.map((e) => e.toJson()).toList(),
      'lineData': lineData?.map((e) => e.toJson()).toList(),
      'status': status?.toJson(),
    };
  }
}
