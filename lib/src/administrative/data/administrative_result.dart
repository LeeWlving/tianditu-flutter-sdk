
/// 行政区查询结果模型
class AdministrativeResult {
  /// 状态码：200 正常，其他异常请看描述
  final int? status;
  
  /// 返回描述
  final String? message;
  
  /// 数据对象
  final DataDTO? data;

  /// 创建AdministrativeResult实例
  AdministrativeResult({
    this.status,
    this.message,
    this.data,
  });

  /// 从JSON字符串解析AdministrativeResult
  factory AdministrativeResult.fromJson(Map<String, dynamic> json) {
    return AdministrativeResult(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? DataDTO.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

/// 数据对象模型
class DataDTO {
  /// 建议搜索词
  /// 说明：模糊匹配结果列表，如果只匹配到一条，该字段值为空
  final dynamic suggestion;
  
  /// 行政区划信息
  final DistrictDTO? district;

  /// 创建DataDTO实例
  DataDTO({
    this.suggestion,
    this.district,
  });

  /// 从JSON字符串解析DataDTO
  factory DataDTO.fromJson(Map<String, dynamic> json) {
    return DataDTO(
      suggestion: json['suggestion'],
      district: json['district'] != null
          ? DistrictDTO.fromJson(json['district'] as Map<String, dynamic>)
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'suggestion': suggestion,
      'district': district?.toJson(),
    };
  }
}

/// 行政区划信息模型
class DistrictDTO {
  /// 行政区划编码
  final String? gb;
  
  /// 行政区划名称
  final String? name;
  
  /// 轮廓数据
  final String? boundary;
  
  /// 中心点坐标
  final CenterDTO? center;
  
  /// 行政区划级别
  final int? level;
  
  /// 下级行政区划信息
  final List<DistrictDTO>? children;

  /// 创建DistrictDTO实例
  DistrictDTO({
    this.gb,
    this.name,
    this.boundary,
    this.center,
    this.level,
    this.children,
  });

  /// 从JSON字符串解析DistrictDTO
  factory DistrictDTO.fromJson(Map<String, dynamic> json) {
    return DistrictDTO(
      gb: json['gb'] as String?,
      name: json['name'] as String?,
      boundary: json['boundary'] as String?,
      center: json['center'] != null
          ? CenterDTO.fromJson(json['center'] as Map<String, dynamic>)
          : null,
      level: json['level'] as int?,
      children: json['children'] != null
          ? (json['children'] as List<dynamic>)
              .map((e) => DistrictDTO.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'gb': gb,
      'name': name,
      'boundary': boundary,
      'center': center?.toJson(),
      'level': level,
      'children': children?.map((e) => e.toJson()).toList(),
    };
  }
}

/// 中心点坐标模型
class CenterDTO {
  /// 经度
  final double? lng;
  
  /// 纬度
  final double? lat;

  /// 创建CenterDTO实例
  CenterDTO({
    this.lng,
    this.lat,
  });

  /// 从JSON字符串解析CenterDTO
  factory CenterDTO.fromJson(Map<String, dynamic> json) {
    return CenterDTO(
      lng: json['lng'] as double?,
      lat: json['lat'] as double?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'lng': lng,
      'lat': lat,
    };
  }
}
