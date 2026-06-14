import 'package:flutter/widgets.dart';

import '../params/drive_params.dart';
import '../../map/tianditu_map_models.dart';
import 'drive_mapinfo.dart';
import 'route_item.dart';
import 'simple_item.dart';

/// 驾车规划结果模型
class DriveResult {
  /// 请求参数
  final DriveParams? parameters;

  /// 全长（单位：公里）
  final double? distance;

  /// 行驶总时间（单位：秒）
  final double? duration;

  /// 线路经纬度字符串
  final String? routelatlon;

  /// 地图显示信息
  final DriveMapinfo? mapinfo;

  /// 分段线路信息
  final List<RouteItem>? routes;

  /// 分段线路信息（简化版）
  final List<SimpleItem>? simple;

  /// 创建DriveResult实例
  DriveResult({
    this.parameters,
    this.distance,
    this.duration,
    this.routelatlon,
    this.mapinfo,
    this.routes,
    this.simple,
  });

  /// 从JSON字符串解析DriveResult
  factory DriveResult.fromJson(Map<String, dynamic> json) {
    return DriveResult(
      parameters: json['parameters'] != null
          ? DriveParams.fromJson(json['parameters'] as Map<String, dynamic>)
          : null,
      distance: _asDouble(json['distance']),
      duration: _asDouble(json['duration']),
      routelatlon: json['routelatlon'] as String?,
      mapinfo: json['mapinfo'] != null
          ? DriveMapinfo.fromJson(json['mapinfo'] as Map<String, dynamic>)
          : null,
      routes: json['routes'] != null
          ? (json['routes'] as List<dynamic>)
                .map((e) => RouteItem.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      simple: json['simple'] != null
          ? (json['simple'] as List<dynamic>)
                .map((e) => SimpleItem.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'parameters': parameters?.toJson(),
      'distance': distance,
      'duration': duration,
      'routelatlon': routelatlon,
      'mapinfo': mapinfo?.toJson(),
      'routes': routes?.map((e) => e.toJson()).toList(),
      'simple': simple?.map((e) => e.toJson()).toList(),
    };
  }

  /// 可直接传给 [TiandituPolyline] 的路线坐标。
  List<TiandituLatLng> get path {
    final values = <TiandituLatLng>[];
    _appendCoordinates(values, routelatlon);
    if (values.isEmpty) {
      for (final item in simple ?? const <SimpleItem>[]) {
        _appendCoordinates(values, item.streetLatLon);
      }
    }
    return List.unmodifiable(values);
  }

  TiandituPolyline toPolyline({
    Color color = const Color(0xFF1565C0),
    double strokeWidth = 6,
  }) {
    return TiandituPolyline(
      points: path,
      color: color,
      strokeWidth: strokeWidth,
    );
  }

  static void _appendCoordinates(List<TiandituLatLng> output, String? encoded) {
    if (encoded == null || encoded.isEmpty) {
      return;
    }
    final numbers = RegExp(r'-?\d+(?:\.\d+)?')
        .allMatches(encoded)
        .map((match) => double.parse(match.group(0)!))
        .toList();
    for (var index = 0; index + 1 < numbers.length; index += 2) {
      final longitude = numbers[index];
      final latitude = numbers[index + 1];
      if (longitude >= -180 &&
          longitude <= 180 &&
          latitude >= -90 &&
          latitude <= 90) {
        output.add(TiandituLatLng(latitude, longitude));
      }
    }
  }

  static double? _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
