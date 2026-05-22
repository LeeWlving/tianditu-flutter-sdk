import 'dart:convert';

import '../common/base_service.dart';
import 'data/drive_result.dart';
import 'params/drive_params.dart';

/// 驾车规划服务类
/// 根据输入起点、终点和途经点规划查询驾车路线。
class DriveService extends BaseService {
  /// 创建DriveService实例
  /// [tk] 天地图密钥
  DriveService(super.tk);

  /// 根据输入起点、终点和途经点规划查询驾车路线
  /// [params] 驾车规划参数
  Future<DriveResult> getDriveRoutes(DriveParams params) async {
    final postStr = jsonEncode(params.toJson());
    final url = '/drive?type=search&postStr=$postStr';

    return request(url, (json) => DriveResult.fromJson(json));
  }
}
