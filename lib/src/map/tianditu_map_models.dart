import 'package:flutter/widgets.dart';

/// 天地图底图类型。
enum TiandituMapType {
  /// 矢量底图。
  vector,

  /// 卫星影像。
  imagery,

  /// 地形晕渲。
  terrain,
}

/// 不依赖具体渲染引擎的经纬度坐标。
@immutable
class TiandituLatLng {
  const TiandituLatLng(this.latitude, this.longitude)
    : assert(latitude >= -90 && latitude <= 90),
      assert(longitude >= -180 && longitude <= 180);

  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) {
    return other is TiandituLatLng &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'TiandituLatLng($latitude, $longitude)';
}

/// 经纬度矩形范围。
@immutable
class TiandituLatLngBounds {
  const TiandituLatLngBounds({
    required this.southwest,
    required this.northeast,
  });

  final TiandituLatLng southwest;
  final TiandituLatLng northeast;

  String get tiandituValue =>
      '${southwest.longitude},${southwest.latitude},'
      '${northeast.longitude},${northeast.latitude}';
}

/// 地图相机状态。
@immutable
class TiandituCameraPosition {
  const TiandituCameraPosition({
    required this.target,
    this.zoom = 10,
    this.rotation = 0,
  });

  final TiandituLatLng target;
  final double zoom;
  final double rotation;
}

/// 地图上的用户当前位置。
@immutable
class TiandituUserLocation {
  const TiandituUserLocation({
    required this.position,
    this.accuracyInMeters = 0,
    this.heading = 0,
    this.showAccuracy = true,
    this.marker,
  });

  final TiandituLatLng position;
  final double accuracyInMeters;
  final double heading;
  final bool showAccuracy;
  final Widget? marker;
}

/// 地图标注。
@immutable
class TiandituMarker {
  const TiandituMarker({
    required this.position,
    required this.child,
    this.width = 40,
    this.height = 40,
    this.alignment = Alignment.center,
    this.rotate = false,
  });

  final TiandituLatLng position;
  final Widget child;
  final double width;
  final double height;
  final Alignment alignment;
  final bool rotate;
}

/// 地图折线。
@immutable
class TiandituPolyline {
  const TiandituPolyline({
    required this.points,
    this.color = const Color(0xFF1565C0),
    this.strokeWidth = 4,
  });

  final List<TiandituLatLng> points;
  final Color color;
  final double strokeWidth;
}

/// 地图多边形。
@immutable
class TiandituPolygon {
  const TiandituPolygon({
    required this.points,
    this.color = const Color(0x331565C0),
    this.borderColor = const Color(0xFF1565C0),
    this.borderStrokeWidth = 2,
  });

  final List<TiandituLatLng> points;
  final Color color;
  final Color borderColor;
  final double borderStrokeWidth;
}

/// 地图圆形覆盖物。
@immutable
class TiandituCircle {
  const TiandituCircle({
    required this.center,
    required this.radiusInMeters,
    this.color = const Color(0x331565C0),
    this.borderColor = const Color(0xFF1565C0),
    this.borderStrokeWidth = 2,
  });

  final TiandituLatLng center;
  final double radiusInMeters;
  final Color color;
  final Color borderColor;
  final double borderStrokeWidth;
}

typedef TiandituMapTapCallback = void Function(TiandituLatLng position);
typedef TiandituCameraChangedCallback =
    void Function(TiandituCameraPosition camera, bool hasGesture);
