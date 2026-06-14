import '../../common/data/address.dart';

/// 逆地理编码结果模型（坐标转地址）
class GeoCoderAddressResult {
  /// 返回状态：0：正常返回，101：结果为空，404：出错
  final String? status;

  /// 返回信息：OK：正常，其他异常
  final String? msg;

  /// 查询版本号
  final String? searchVersion;

  /// 地址对象
  final Address? result;

  /// 创建GeoCoderAddressResult实例
  GeoCoderAddressResult({
    this.status,
    this.msg,
    this.searchVersion,
    this.result,
  });

  /// 从JSON字符串解析GeoCoderAddressResult
  factory GeoCoderAddressResult.fromJson(Map<String, dynamic> json) {
    return GeoCoderAddressResult(
      status: json['status'] as String?,
      msg: json['msg'] as String?,
      searchVersion: json['searchVersion'] as String?,
      result: json['result'] != null
          ? Address.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'searchVersion': searchVersion,
      'result': result?.toJson(),
    };
  }
}
