
import 'location.dart';
import 'address_detail.dart';

/// 地址对象模型
class Address {
  /// 详细地址
  final String? formattedAddress;
  
  /// 坐标
  final Location? location;
  
  /// 此点的具体信息（分类）
  final AddressDetail? addressComponent;

  /// 创建Address实例
  Address({
    this.formattedAddress,
    this.location,
    this.addressComponent,
  });

  /// 从JSON字符串解析Address
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      formattedAddress: json['formatted_address'] as String?,
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      addressComponent: json['addressComponent'] != null
          ? AddressDetail.fromJson(json['addressComponent'] as Map<String, dynamic>)
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'formatted_address': formattedAddress,
      'location': location?.toJson(),
      'addressComponent': addressComponent?.toJson(),
    };
  }
}
