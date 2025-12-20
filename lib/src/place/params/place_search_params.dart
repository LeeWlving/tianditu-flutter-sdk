
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
  });

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'keyWord': keyWord,
      'queryType': queryType,
      'specify': specify,
      'queryRadius': queryRadius,
      'pointLonlat': pointLonlat,
      'mapBound': mapBound,
      'level': level,
      'polygon': polygon,
      'start': start,
      'count': count,
      'dataTypes': dataTypes,
      'show': show,
    };
  }
}
