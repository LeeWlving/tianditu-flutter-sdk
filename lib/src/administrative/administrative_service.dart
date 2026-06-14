import '../common/base_service.dart';
import 'data/administrative_result.dart';
import 'params/administrative_params.dart';

/// 行政区划服务V2.0
/// 提供由行政区划地名、行政区划编码查询中心点、轮廓、所属上级行政区划等信息。
class AdministrativeService extends BaseService {
  /// 创建AdministrativeService实例
  /// [tk] 天地图密钥
  AdministrativeService(super.tk, {super.client, super.baseUri, super.timeout});

  /// 查询行政区划
  /// [params] 行政区划查询参数
  Future<AdministrativeResult> getAdministrative(
    AdministrativeParams params,
  ) async {
    return request(
      '/v2/administrative',
      AdministrativeResult.fromJson,
      queryParameters: {
        'keyword': params.keyword,
        'childLevel': params.childLevel.toString(),
        'extensions': params.extensions ? 'all' : 'base',
      },
    );
  }
}
