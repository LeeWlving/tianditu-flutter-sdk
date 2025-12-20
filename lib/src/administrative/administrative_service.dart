
import '../common/base_service.dart';
import 'data/administrative_result.dart';
import 'params/administrative_params.dart';

/// 行政区划服务V2.0
/// 提供由行政区划地名、行政区划编码查询中心点、轮廓、所属上级行政区划等信息。
class AdministrativeService extends BaseService {
  /// 创建AdministrativeService实例
  /// [tk] 天地图密钥
  AdministrativeService(String tk) : super(tk);

  /// 查询行政区划
  /// [params] 行政区划查询参数
  Future<AdministrativeResult> getAdministrative(AdministrativeParams params) async {
    final List<String> sb = [];
    
    if (params.keyword != null && params.keyword!.isNotEmpty) {
      sb.add('keyword=${params.keyword}');
    }
    
    sb.add('childLevel=${params.childLevel}');
    sb.add('extensions=${params.extensions ? 'all' : 'base'}');
    
    final url = '/v2/administrative?${sb.join('&')}';
    
    return request(
      url,
      (json) => AdministrativeResult.fromJson(json as Map<String, dynamic>),
    );
  }
}
