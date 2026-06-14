import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'tianditu_map_models.dart';

/// 以编程方式控制 [TiandituMap]。
class TiandituMapController {
  final MapController _delegate = MapController();

  MapController get delegate => _delegate;

  /// 移动地图中心并设置缩放级别。
  bool move(TiandituLatLng target, double zoom) {
    return _delegate.move(LatLng(target.latitude, target.longitude), zoom);
  }

  /// 旋转地图，单位为角度。
  bool rotate(double degrees) => _delegate.rotate(degrees);

  /// 调整地图，使全部坐标可见。
  bool fitCoordinates(
    Iterable<TiandituLatLng> coordinates, {
    EdgeInsets padding = const EdgeInsets.all(48),
    double maxZoom = 18,
  }) {
    final points = coordinates
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList(growable: false);
    if (points.isEmpty) {
      return false;
    }
    if (points.length == 1) {
      return _delegate.move(points.single, maxZoom);
    }
    return _delegate.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(points),
        padding: padding,
        maxZoom: maxZoom,
      ),
    );
  }

  void dispose() => _delegate.dispose();
}
