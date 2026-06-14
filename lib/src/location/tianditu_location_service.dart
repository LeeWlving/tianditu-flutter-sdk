import 'package:geolocator/geolocator.dart';

import '../map/tianditu_map_models.dart';
import 'tianditu_location_models.dart';

/// 跨平台设备定位服务。
///
/// 天地图不提供终端 GPS 定位，此服务使用操作系统的位置能力。
class TiandituLocationService {
  const TiandituLocationService();

  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  Future<TiandituLocationPermission> checkPermission() async {
    return _permission(await Geolocator.checkPermission());
  }

  Future<TiandituLocationPermission> requestPermission() async {
    return _permission(await Geolocator.requestPermission());
  }

  /// 确保定位服务和权限可用。
  Future<TiandituLocationPermission> ensurePermission() async {
    if (!await isServiceEnabled()) {
      throw const TiandituLocationException('系统定位服务未开启');
    }

    var permission = await checkPermission();
    if (permission == TiandituLocationPermission.denied) {
      permission = await requestPermission();
    }
    if (permission == TiandituLocationPermission.deniedForever) {
      throw const TiandituLocationException('定位权限被永久拒绝，请在系统设置中开启');
    }
    if (permission == TiandituLocationPermission.denied ||
        permission == TiandituLocationPermission.unableToDetermine) {
      throw const TiandituLocationException('没有可用的定位权限');
    }
    return permission;
  }

  Future<TiandituPosition> getCurrentPosition({
    TiandituLocationOptions options = const TiandituLocationOptions(),
    bool requestPermission = true,
  }) async {
    if (requestPermission) {
      await ensurePermission();
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: _settings(options),
    );
    return _position(position);
  }

  Stream<TiandituPosition> getPositionStream({
    TiandituLocationOptions options = const TiandituLocationOptions(),
  }) {
    return Geolocator.getPositionStream(
      locationSettings: _settings(options),
    ).map(_position);
  }

  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  static LocationSettings _settings(TiandituLocationOptions options) {
    return LocationSettings(
      accuracy: switch (options.accuracy) {
        TiandituLocationAccuracy.lowest => LocationAccuracy.lowest,
        TiandituLocationAccuracy.low => LocationAccuracy.low,
        TiandituLocationAccuracy.medium => LocationAccuracy.medium,
        TiandituLocationAccuracy.high => LocationAccuracy.high,
        TiandituLocationAccuracy.best => LocationAccuracy.best,
        TiandituLocationAccuracy.navigation =>
          LocationAccuracy.bestForNavigation,
      },
      distanceFilter: options.distanceFilter,
      timeLimit: options.timeLimit,
    );
  }

  static TiandituPosition _position(Position position) {
    return TiandituPosition(
      coordinate: TiandituLatLng(position.latitude, position.longitude),
      timestamp: position.timestamp,
      accuracy: position.accuracy,
      altitude: position.altitude,
      heading: position.heading,
      speed: position.speed,
      speedAccuracy: position.speedAccuracy,
      isMocked: position.isMocked,
    );
  }

  static TiandituLocationPermission _permission(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.denied => TiandituLocationPermission.denied,
      LocationPermission.deniedForever =>
        TiandituLocationPermission.deniedForever,
      LocationPermission.whileInUse => TiandituLocationPermission.whileInUse,
      LocationPermission.always => TiandituLocationPermission.always,
      LocationPermission.unableToDetermine =>
        TiandituLocationPermission.unableToDetermine,
    };
  }
}
