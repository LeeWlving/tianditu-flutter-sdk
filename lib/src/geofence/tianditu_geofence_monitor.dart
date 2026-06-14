import '../location/tianditu_location_models.dart';
import 'tianditu_geofence.dart';

/// 基于前台定位流计算地理围栏进入和离开事件。
///
/// 后台被系统终止后的持续监控需要原生后台地理围栏能力。
class TiandituGeofenceMonitor {
  TiandituGeofenceMonitor(Iterable<TiandituGeofence> geofences)
    : geofences = List.unmodifiable(geofences) {
    final ids = <String>{};
    for (final geofence in this.geofences) {
      if (geofence.id.isEmpty) {
        throw ArgumentError.value(geofence.id, 'id', '围栏 ID 不能为空');
      }
      if (!ids.add(geofence.id)) {
        throw ArgumentError.value(geofence.id, 'id', '围栏 ID 不能重复');
      }
    }
  }

  final List<TiandituGeofence> geofences;
  final Map<String, bool> _states = {};

  /// 计算一个位置产生的围栏事件。
  List<TiandituGeofenceEvent> evaluate(TiandituPosition position) {
    final events = <TiandituGeofenceEvent>[];
    for (final geofence in geofences) {
      final isInside = geofence.contains(position.coordinate);
      final wasInside = _states[geofence.id];
      _states[geofence.id] = isInside;

      if (wasInside == null || wasInside == isInside) {
        continue;
      }
      events.add(
        TiandituGeofenceEvent(
          geofence: geofence,
          transition: isInside
              ? TiandituGeofenceTransition.enter
              : TiandituGeofenceTransition.exit,
          position: position.coordinate,
          timestamp: position.timestamp,
        ),
      );
    }
    return events;
  }

  /// 监听定位流并输出围栏事件。
  Stream<TiandituGeofenceEvent> monitor(
    Stream<TiandituPosition> positions,
  ) async* {
    await for (final position in positions) {
      yield* Stream.fromIterable(evaluate(position));
    }
  }

  void reset() => _states.clear();
}
