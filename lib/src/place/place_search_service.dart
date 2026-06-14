import 'dart:convert';

import '../common/base_service.dart';
import '../map/tianditu_map_models.dart';
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
  PlaceSearchService(super.tk, {super.client, super.baseUri, super.timeout});

  /// 查询地址
  /// [params] 搜索参数
  Future<PlaceSearchResult> search(PlaceSearchParams params) async {
    return sendSearchRequest(params);
  }

  Future<PlaceSearchResult> searchKeyword({
    required String keyword,
    String? region,
    int page = 0,
    int pageSize = 20,
    String? dataTypes,
  }) {
    return search(
      PlaceSearchParams.keyword(
        keyword: keyword,
        region: region,
        page: page,
        pageSize: pageSize,
        dataTypes: dataTypes,
      ),
    );
  }

  Future<PlaceSearchResult> searchNearby({
    required String keyword,
    required TiandituLatLng center,
    required int radiusInMeters,
    int page = 0,
    int pageSize = 20,
    String? dataTypes,
  }) {
    return search(
      PlaceSearchParams.nearby(
        keyword: keyword,
        center: center,
        radiusInMeters: radiusInMeters,
        page: page,
        pageSize: pageSize,
        dataTypes: dataTypes,
      ),
    );
  }

  Future<PlaceSearchResult> searchInRegion({
    required String keyword,
    required String region,
    int page = 0,
    int pageSize = 20,
    String? dataTypes,
  }) {
    return search(
      PlaceSearchParams.inRegion(
        keyword: keyword,
        region: region,
        page: page,
        pageSize: pageSize,
        dataTypes: dataTypes,
      ),
    );
  }

  Future<PlaceSearchResult> searchInBounds({
    required String keyword,
    required TiandituLatLngBounds bounds,
    required double zoom,
    int page = 0,
    int pageSize = 20,
    String? dataTypes,
  }) {
    return search(
      PlaceSearchParams.inBounds(
        keyword: keyword,
        bounds: bounds,
        zoom: zoom,
        page: page,
        pageSize: pageSize,
        dataTypes: dataTypes,
      ),
    );
  }

  Future<PlaceSearchResult> searchInPolygon({
    required String keyword,
    required List<TiandituLatLng> points,
    int page = 0,
    int pageSize = 20,
    String? dataTypes,
  }) {
    return search(
      PlaceSearchParams.inPolygon(
        keyword: keyword,
        points: points,
        page: page,
        pageSize: pageSize,
        dataTypes: dataTypes,
      ),
    );
  }

  /// 发送搜索请求
  Future<PlaceSearchResult> sendSearchRequest(PlaceSearchParams params) async {
    return request(
      '/v2/search',
      PlaceSearchResult.fromJson,
      queryParameters: {
        'type': 'query',
        'postStr': jsonEncode(params.toJson()),
      },
    );
  }
}
