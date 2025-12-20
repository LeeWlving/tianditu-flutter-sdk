
import 'dart:convert';

import '../common/base_service.dart';
import 'data/place_search_result.dart';
import 'params/place_search_params.dart';

/// 地名搜索V2.0服务类
/// 
/// 支持以下搜索类型：
/// 1. 行政区划区域搜索服务
/// 2. 视野内搜索服务
/// 3. 周边搜索服务
/// 4. 多边形搜索服务
/// 5. 数据分类搜索服务
/// 6. 普通搜索服务
/// 7. 统计搜索服务
class PlaceSearchService extends BaseService {
  /// 创建PlaceSearchService实例
  /// [tk] 天地图密钥
  PlaceSearchService(String tk) : super(tk);

  /// 查询地址
  /// [params] 搜索参数
  Future<PlaceSearchResult> search(PlaceSearchParams params) async {
    return sendSearchRequest(params);
  }

  /// 发送搜索请求
  Future<PlaceSearchResult> sendSearchRequest(PlaceSearchParams params) async {
    final postStr = jsonEncode(params.toJson());
    final uri = '/v2/search?type=query&postStr=$postStr';
    return request(
      uri,
      (json) => PlaceSearchResult.fromJson(json as Map<String, dynamic>),
    );
  }
}
