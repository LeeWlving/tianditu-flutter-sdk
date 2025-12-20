
import '../../common/data/location.dart';

/// 地理编码结果模型（地址转坐标）
class GeoCoderLocationResult {
  /// 返回状态：0：正常返回，101：结果为空，404：出错
  final String? status;
  
  /// 返回信息：OK：正常，其他异常
  final String? msg;
  
  /// 查询版本号
  final String? searchVersion;
  
  /// 地址坐标对象
  final Location? location;

  /// 创建GeoCoderLocationResult实例
  GeoCoderLocationResult({
    this.status,
    this.msg,
    this.searchVersion,
    this.location,
  });

  /// 从JSON字符串解析GeoCoderLocationResult
  factory GeoCoderLocationResult.fromJson(Map<String, dynamic> json) {
    return GeoCoderLocationResult(
      status: json['status'] as String?,
      msg: json['msg'] as String?,
      searchVersion: json['searchVersion'] as String?,
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'searchVersion': searchVersion,
      'location': location?.toJson(),
    };
  }
}
