import 'package:flutter/foundation.dart';

import '../map/tianditu_map_models.dart';

/// 定位权限状态。
enum TiandituLocationPermission {
  denied,
  deniedForever,
  whileInUse,
  always,
  unableToDetermine,
}

/// 定位精度。
enum TiandituLocationAccuracy { lowest, low, medium, high, best, navigation }

/// 设备定位结果。
@immutable
class TiandituPosition {
  const TiandituPosition({
    required this.coordinate,
    required this.timestamp,
    this.accuracy = 0,
    this.altitude = 0,
    this.heading = 0,
    this.speed = 0,
    this.speedAccuracy = 0,
    this.isMocked = false,
  });

  final TiandituLatLng coordinate;
  final DateTime timestamp;
  final double accuracy;
  final double altitude;
  final double heading;
  final double speed;
  final double speedAccuracy;
  final bool isMocked;
}

/// 持续定位配置。
@immutable
class TiandituLocationOptions {
  const TiandituLocationOptions({
    this.accuracy = TiandituLocationAccuracy.high,
    this.distanceFilter = 0,
    this.timeLimit,
  });

  final TiandituLocationAccuracy accuracy;
  final int distanceFilter;
  final Duration? timeLimit;
}

/// 定位功能异常。
class TiandituLocationException implements Exception {
  const TiandituLocationException(this.message);

  final String message;

  @override
  String toString() => 'TiandituLocationException: $message';
}
