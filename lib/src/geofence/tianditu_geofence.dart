import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../map/tianditu_map_models.dart';

/// 地理围栏的基础类型。
@immutable
sealed class TiandituGeofence {
  const TiandituGeofence({required this.id});

  final String id;

  bool contains(TiandituLatLng point);
}

/// 圆形地理围栏。
class TiandituCircularGeofence extends TiandituGeofence {
  const TiandituCircularGeofence({
    required super.id,
    required this.center,
    required this.radiusInMeters,
  }) : assert(radiusInMeters > 0);

  final TiandituLatLng center;
  final double radiusInMeters;

  @override
  bool contains(TiandituLatLng point) {
    const distance = Distance();
    return distance.as(
          LengthUnit.Meter,
          LatLng(center.latitude, center.longitude),
          LatLng(point.latitude, point.longitude),
        ) <=
        radiusInMeters;
  }
}

/// 多边形地理围栏。
class TiandituPolygonGeofence extends TiandituGeofence {
  TiandituPolygonGeofence({
    required super.id,
    required List<TiandituLatLng> points,
  }) : points = List.unmodifiable(points) {
    if (points.length < 3) {
      throw ArgumentError.value(points, 'points', '至少需要三个坐标点');
    }
  }

  final List<TiandituLatLng> points;

  @override
  bool contains(TiandituLatLng point) {
    var inside = false;
    var previous = points.last;
    for (final current in points) {
      final intersects =
          (current.latitude > point.latitude) !=
              (previous.latitude > point.latitude) &&
          point.longitude <
              (previous.longitude - current.longitude) *
                      (point.latitude - current.latitude) /
                      (previous.latitude - current.latitude) +
                  current.longitude;
      if (intersects) {
        inside = !inside;
      }
      previous = current;
    }
    return inside;
  }
}

enum TiandituGeofenceTransition { enter, exit }

/// 地理围栏进入或离开事件。
@immutable
class TiandituGeofenceEvent {
  const TiandituGeofenceEvent({
    required this.geofence,
    required this.transition,
    required this.position,
    required this.timestamp,
  });

  final TiandituGeofence geofence;
  final TiandituGeofenceTransition transition;
  final TiandituLatLng position;
  final DateTime timestamp;
}
