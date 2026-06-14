import 'station_data.dart';

/// POI对象模型
class Poi {
  /// Poi点名称
  final String? name;

  /// 电话
  final String? phone;

  /// 地址
  final String? address;

  /// 坐标，格式：x,y
  final String? lonlat;

  /// poi类型：101:POI数据 102:公交站点
  final int? poiType;

  /// 英文地址
  final String? eaddress;

  /// poi点英文名称
  final String? ename;

  /// poi热点ID
  final String? hotPointID;

  /// 所属省名称
  final String? province;

  /// 省行政区编码
  final String? provinceCode;

  /// 所属城市名称
  final String? city;

  /// 市行政区编码
  final String? cityCode;

  /// 所属区县名称
  final String? county;

  /// 区县行政区编码
  final String? countyCode;

  /// 数据信息来源
  final String? source;

  /// 分类编码
  final String? typeCode;

  /// 分类名称
  final String? typeName;

  /// 车站信息结构体，数据poiType=102
  final List<StationData>? stationData;

  /// 创建Poi实例
  Poi({
    this.name,
    this.phone,
    this.address,
    this.lonlat,
    this.poiType,
    this.eaddress,
    this.ename,
    this.hotPointID,
    this.province,
    this.provinceCode,
    this.city,
    this.cityCode,
    this.county,
    this.countyCode,
    this.source,
    this.typeCode,
    this.typeName,
    this.stationData,
  });

  /// 从JSON字符串解析Poi
  factory Poi.fromJson(Map<String, dynamic> json) {
    return Poi(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      lonlat: json['lonlat'] as String?,
      poiType: json['poiType'] as int?,
      eaddress: json['eaddress'] as String?,
      ename: json['ename'] as String?,
      hotPointID: json['hotPointID'] as String?,
      province: json['province'] as String?,
      provinceCode: json['provinceCode'] as String?,
      city: json['city'] as String?,
      cityCode: json['cityCode'] as String?,
      county: json['county'] as String?,
      countyCode: json['countyCode'] as String?,
      source: json['source'] as String?,
      typeCode: json['typeCode'] as String?,
      typeName: json['typeName'] as String?,
      stationData: json['stationData'] != null
          ? (json['stationData'] as List<dynamic>)
                .map((e) => StationData.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'lonlat': lonlat,
      'poiType': poiType,
      'eaddress': eaddress,
      'ename': ename,
      'hotPointID': hotPointID,
      'province': province,
      'provinceCode': provinceCode,
      'city': city,
      'cityCode': cityCode,
      'county': county,
      'countyCode': countyCode,
      'source': source,
      'typeCode': typeCode,
      'typeName': typeName,
      'stationData': stationData?.map((e) => e.toJson()).toList(),
    };
  }
}
