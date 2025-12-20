
import 'dart:convert';

import '../common/base_service.dart';
import 'params/bus_line_params.dart';

/// 公交规划服务类
/// 支持以下功能：
/// 1. 公交规划
/// 2. ID搜索线路详情
/// 3. 站点返程线路查询
class BusService extends BaseService {
  /// 创建BusService实例
  /// [tk] 天地图密钥
  BusService(String tk) : super(tk);

  /// 公交规划
  /// 根据输入起点和终点查询公交地铁规划线路
  /// [params] 公交规划参数
  Future<Map<String, dynamic>> getBusLine(BusLineParams params) async {
    final url = '/transit?type=busline&postStr=${jsonEncode(params.toJson())}';
    
    return request(
      url,
      (json) => json as Map<String, dynamic>,
    );
  }

  /// ID搜索请求
  /// 根据提供的uuid搜索内容，主要是根据前端给的id搜索公交站和公交线的详细信息
  /// [uuid] 线路的ID
  Future<Map<String, dynamic>> getLineDetail(String uuid) async {
    final url = '/transit?type=busline&postStr={"uuid":"$uuid"}';
    
    return request(
      url,
      (json) => json as Map<String, dynamic>,
    );
  }

  /// 站点返程线路查询
  /// 站点返程线路查询是查询经过一个站点的线路是否有反向的线路，即查询经过此战的此线路是否为双向成对的线路
  /// [uuid] 站点的ID
  Future<Map<String, dynamic>> getStationDetail(String uuid) async {
    final url = '/transit?type=busline&postStr={"uuid":"$uuid"}';
    
    return request(
      url,
      (json) => json as Map<String, dynamic>,
    );
  }

  /// 站点返程线路查询
  /// 站点返程线路查询是查询经过一个站点的线路是否有反向的线路，即查询经过此战的此线路是否为双向成对的线路
  /// [lineUuid] 线路的ID
  /// [stationUuid] 站点的ID
  Future<Map<String, dynamic>> getStationReturnRoute(String lineUuid, String stationUuid) async {
    final url = '/transit?type=busline&postStr={"lineUuid":"$lineUuid","stationUuid":"$stationUuid"}';
    
    return request(
      url,
      (json) => json as Map<String, dynamic>,
    );
  }
}
