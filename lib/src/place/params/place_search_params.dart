import '../../map/tianditu_map_models.dart';

/// 天地图地名搜索类型。
enum PlaceSearchType {
  administrativeArea(1),
  mapBounds(2),
  nearby(3),
  suggestion(4),
  keyword(7),
  polygon(10);

  const PlaceSearchType(this.value);
  final int value;
}

/// 地名搜索参数模型
class PlaceSearchParams {
  /// 【必填】搜索的关键字
  final String keyWord;

  /// 服务查询类型参数，默认值：3
  final int queryType;

  /// 指定行政区的国标码
  /// 下载行政区划编码表: https://download.tianditu.gov.cn/download/xzqh/AdminCode.csv
  /// 9位国标码，如：北京：156110000或北京。
  final String? specify;

  /// 周边搜索相关：查询半径，单位:米 （10公里内）
  final int? queryRadius;

  /// 周边搜索相关：点坐标，中心点，经纬度坐标
  final String? pointLonlat;

  /// 视野范围相关：地图视野范围("minx,miny,maxx,maxy")，范围：-180,-90至180,90
  final String? mapBound;

  /// 视野范围相关：目前查询的级别，范围：1-18级
  final String? level;

  /// 多边形范围数据(经纬度坐标对)
  /// 经度和纬度用","分割，首尾坐标对需相同。实例(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x1,y1)
  final String? polygon;

  /// 【必填】返回结果起始位（用于分页和缓存）默认0 ： 0-300，表示返回结果的起始位置。
  final String start;

  /// 【必填】返回的结果数量（用于分页和缓存）：1-300，返回结果的条数。
  final String count;

  /// 【可选】数据分类（分类编码表）
  /// 下载分类编码表：https://download.tianditu.gov.cn/download/xzqh/Type.csv
  /// 参数可以分类名称或分类编码。多个分类用","隔开(英文逗号)。
  final String? dataTypes;

  /// 【可选】返回poi结果信息类别：取值为1，则返回基本poi信息； 取值为2，则返回详细poi信息
  final String? show;

  /// 创建PlaceSearchParams实例
  PlaceSearchParams({
    required this.keyWord,
    this.queryType = 3,
    this.specify,
    this.queryRadius,
    this.pointLonlat,
    this.mapBound,
    this.level,
    this.polygon,
    this.start = '0',
    this.count = '10',
    this.dataTypes,
    this.show,
  }) : assert(keyWord != ''),
       assert(queryRadius == null || (queryRadius > 0 && queryRadius <= 10000));

  /// 普通关键词或 POI 搜索。
  factory PlaceSearchParams.keyword({
    required String keyword,
    String? region,
    int page = 0,
    int pageSize = 20,
    String? dataTypes,
    bool detailed = true,
  }) {
    _validatePage(page, pageSize);
    return PlaceSearchParams(
      keyWord: keyword,
      queryType: PlaceSearchType.keyword.value,
      specify: region,
      start: (page * pageSize).toString(),
      count: pageSize.toString(),
      dataTypes: dataTypes,
      show: detailed ? '2' : '1',
    );
  }

  /// 指定行政区域内搜索。
  factory PlaceSearchParams.inRegion({
    required String keyword,
    required String region,
    int page = 0,
    int pageSize = 20,
    String? dataTypes,
  }) {
    _validatePage(page, pageSize);
    return PlaceSearchParams(
      keyWord: keyword,
      queryType: PlaceSearchType.administrativeArea.value,
      specify: region,
      start: (page * pageSize).toString(),
      count: pageSize.toString(),
      dataTypes: dataTypes,
      show: '2',
    );
  }

  /// 以一个坐标为中心进行周边搜索。
  factory PlaceSearchParams.nearby({
    required String keyword,
    required TiandituLatLng center,
    required int radiusInMeters,
    int page = 0,
    int pageSize = 20,
    String? dataTypes,
  }) {
    _validatePage(page, pageSize);
    if (radiusInMeters <= 0 || radiusInMeters > 10000) {
      throw RangeError.range(radiusInMeters, 1, 10000, 'radiusInMeters');
    }
    return PlaceSearchParams(
      keyWord: keyword,
      queryType: PlaceSearchType.nearby.value,
      pointLonlat: '${center.longitude},${center.latitude}',
      queryRadius: radiusInMeters,
      start: (page * pageSize).toString(),
      count: pageSize.toString(),
      dataTypes: dataTypes,
      show: '2',
    );
  }

  /// 在地图视野范围内搜索。
  factory PlaceSearchParams.inBounds({
    required String keyword,
    required TiandituLatLngBounds bounds,
    required double zoom,
    int page = 0,
    int pageSize = 20,
    String? dataTypes,
  }) {
    _validatePage(page, pageSize);
    return PlaceSearchParams(
      keyWord: keyword,
      queryType: PlaceSearchType.mapBounds.value,
      mapBound: bounds.tiandituValue,
      level: zoom.round().clamp(1, 18).toString(),
      start: (page * pageSize).toString(),
      count: pageSize.toString(),
      dataTypes: dataTypes,
      show: '2',
    );
  }

  /// 在多边形范围内搜索。
  factory PlaceSearchParams.inPolygon({
    required String keyword,
    required List<TiandituLatLng> points,
    int page = 0,
    int pageSize = 20,
    String? dataTypes,
  }) {
    _validatePage(page, pageSize);
    if (points.length < 3) {
      throw ArgumentError.value(points, 'points', '至少需要三个坐标点');
    }
    final closed = points.first == points.last
        ? points
        : [...points, points.first];
    return PlaceSearchParams(
      keyWord: keyword,
      queryType: PlaceSearchType.polygon.value,
      polygon: closed
          .map((point) => '${point.longitude},${point.latitude}')
          .join(','),
      start: (page * pageSize).toString(),
      count: pageSize.toString(),
      dataTypes: dataTypes,
      show: '2',
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'keyWord': keyWord,
      'queryType': queryType,
      if (specify != null) 'specify': specify,
      if (queryRadius != null) 'queryRadius': queryRadius,
      if (pointLonlat != null) 'pointLonlat': pointLonlat,
      if (mapBound != null) 'mapBound': mapBound,
      if (level != null) 'level': level,
      if (polygon != null) 'polygon': polygon,
      'start': start,
      'count': count,
      if (dataTypes != null) 'dataTypes': dataTypes,
      if (show != null) 'show': show,
    };
  }

  static void _validatePage(int page, int pageSize) {
    if (page < 0) {
      throw RangeError.value(page, 'page', 'must be at least 0');
    }
    if (pageSize < 1 || pageSize > 300) {
      throw RangeError.range(pageSize, 1, 300, 'pageSize');
    }
  }
}
