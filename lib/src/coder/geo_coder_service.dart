import 'dart:convert';

import '../common/base_service.dart';
import '../common/data/location.dart';
import '../map/tianditu_map_models.dart';
import 'data/geo_coder_address_result.dart';
import 'data/geo_coder_location_result.dart';

/// 地理编码/逆地理编码服务类
///
/// 提供两种主要功能：
/// 1. 地理编码：将结构化地址转换为坐标点（经纬度）
/// 2. 逆地理编码：将坐标点（经纬度）转换为结构化地址
class GeoCoderService extends BaseService {
  /// 创建GeoCoderService实例
  /// [tk] 天地图密钥
  GeoCoderService(super.tk, {super.client, super.baseUri, super.timeout});

  /// 地理编码
  /// 将结构化地址数据（如：北京市海淀区莲花池西路28号）转换为对应坐标点（经纬度）
  /// [address] 地址，如：北京市海淀区莲花池西路28号
  Future<GeoCoderLocationResult> addressToLocation(String address) async {
    return request(
      '/geocoder',
      GeoCoderLocationResult.fromJson,
      queryParameters: {
        'ds': jsonEncode({'keyWord': address}),
      },
    );
  }

  /// 逆地理编码查询
  /// 提供将坐标点（经纬度）转换为结构化的地址信息的功能
  /// [lon] 经度
  /// [lat] 纬度
  Future<GeoCoderAddressResult> locationToAddress(
    double lon,
    double lat,
  ) async {
    return request(
      '/geocoder',
      GeoCoderAddressResult.fromJson,
      queryParameters: {
        'type': 'geocode',
        'postStr': jsonEncode({'lon': lon, 'lat': lat, 'ver': 1}),
      },
    );
  }

  /// 地理编码
  /// [address] 地址，如：北京市海淀区莲花池西路28号
  Future<GeoCoderLocationResult> geocode({required String address}) async {
    return addressToLocation(address);
  }

  /// 逆地理编码
  /// [location] 坐标点（经纬度）
  Future<GeoCoderAddressResult> reverseGeocode({
    required Location location,
  }) async {
    final lon = location.lon;
    final lat = location.lat;
    if (lon == null || lat == null) {
      throw ArgumentError('location.lon and location.lat are required');
    }
    return locationToAddress(lon, lat);
  }

  /// 使用地图坐标进行逆地理编码。
  Future<GeoCoderAddressResult> reverseCoordinate(TiandituLatLng coordinate) {
    return locationToAddress(coordinate.longitude, coordinate.latitude);
  }
}
