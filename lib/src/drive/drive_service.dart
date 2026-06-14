import 'dart:convert';

import '../common/base_service.dart';
import '../map/tianditu_map_models.dart';
import 'data/drive_result.dart';
import 'params/drive_params.dart';

/// 驾车规划服务类
/// 根据输入起点、终点和途经点规划查询驾车路线。
class DriveService extends BaseService {
  /// 创建DriveService实例
  /// [tk] 天地图密钥
  DriveService(super.tk, {super.client, super.baseUri, super.timeout});

  /// 根据输入起点、终点和途经点规划查询驾车路线
  /// [params] 驾车规划参数
  Future<DriveResult> getDriveRoutes(DriveParams params) async {
    return request(
      '/drive',
      DriveResult.fromJson,
      queryParameters: {
        'type': 'search',
        'postStr': jsonEncode(params.toJson()),
      },
    );
  }

  /// 规划驾车或步行路线。
  Future<DriveResult> plan({
    required TiandituLatLng origin,
    required TiandituLatLng destination,
    List<TiandituLatLng> waypoints = const [],
    DriveRouteStrategy strategy = DriveRouteStrategy.fastest,
  }) {
    return getDriveRoutes(
      DriveParams.coordinates(
        origin: origin,
        destination: destination,
        waypoints: waypoints,
        strategy: strategy,
      ),
    );
  }
}
