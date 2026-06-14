/// 地址详情模型
class AddressDetail {
  /// 此点最近地点信息
  final String? address;

  /// 此点在最近地点信息方向
  final String? addressPosition;

  /// 此点距离最近地点信息距离
  final int? addressDistance;

  /// 国家
  final String? nation;

  /// 省份
  final String? province;

  /// 省份编码
  final String? provinceCode;

  /// 此点所在国家或城市或区县
  final String? city;

  /// 城市编码
  final String? cityCode;

  /// 区县
  final String? county;

  /// 区县编码
  final String? countyCode;

  /// 距离此点最近的路
  final String? road;

  /// 此点距离此路的距离
  final int? roadDistance;

  /// 距离此点最近poi点
  final String? poi;

  /// 此点在最近poi点的方向
  final String? poiPosition;

  /// 距离此点最近poi点的距离
  final int? poiDistance;

  /// 创建AddressDetail实例
  AddressDetail({
    this.address,
    this.addressPosition,
    this.addressDistance,
    this.nation,
    this.province,
    this.provinceCode,
    this.city,
    this.cityCode,
    this.county,
    this.countyCode,
    this.road,
    this.roadDistance,
    this.poi,
    this.poiPosition,
    this.poiDistance,
  });

  /// 从JSON字符串解析AddressDetail
  factory AddressDetail.fromJson(Map<String, dynamic> json) {
    return AddressDetail(
      address: json['address'] as String?,
      addressPosition: json['address_position'] as String?,
      addressDistance: _readDistance(json, 'address_distance'),
      nation: json['nation'] as String?,
      province: json['province'] as String?,
      provinceCode: json['province_code'] as String?,
      city: json['city'] as String?,
      cityCode: json['city_code'] as String?,
      county: json['county'] as String?,
      countyCode: json['county_code'] as String?,
      road: json['road'] as String?,
      roadDistance: _readDistance(json, 'road_distance'),
      poi: json['poi'] as String?,
      poiPosition: json['poi_position'] as String?,
      poiDistance: _readDistance(json, 'poi_distance'),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'address_position': addressPosition,
      'address_distance': addressDistance,
      'address_distince': addressDistance,
      'nation': nation,
      'province': province,
      'province_code': provinceCode,
      'city': city,
      'city_code': cityCode,
      'county': county,
      'county_code': countyCode,
      'road': road,
      'road_distance': roadDistance,
      'road_distince': roadDistance,
      'poi': poi,
      'poi_position': poiPosition,
      'poi_distance': poiDistance,
      'poi_distince': poiDistance,
    };
  }

  static int? _readDistance(Map<String, dynamic> json, String key) {
    final direct = _asInt(json[key]);
    if (direct != null) return direct;
    final altKey = key.replaceFirst('distance', 'distince');
    return _asInt(json[altKey]);
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
