
import '../common/base_service.dart';
import 'params/static_image_params.dart';

/// 静态地图服务类
/// 实现将天地图地图以图片形式嵌入到您的网页中
class StaticImageService extends BaseService {
  /// 创建StaticImageService实例
  /// [tk] 天地图密钥
  StaticImageService(super.tk);

  /// 获取静态地图图片
  /// [params] 静态地图参数
  /// 返回：图片的字节数组
  Future<List<int>> getImage(StaticImageParams params) async {
    final List<String> list = [];

    list.add('width=${params.width}');
    list.add('height=${params.height}');
    list.add('zoom=${params.zoom}');
    
    if (params.center != null && params.center!.isNotEmpty) {
      list.add('center=${params.center}');
    }
    
    if (params.markers != null && params.markers!.isNotEmpty) {
      list.add('markers=${params.markers}');
    }
    
    if (params.markerStyles != null && params.markerStyles!.isNotEmpty) {
      list.add('markerStyles=${params.markerStyles}');
    }
    
    if (params.paths != null && params.paths!.isNotEmpty) {
      list.add('paths=${params.paths}');
    }
    
    if (params.pathStyles != null && params.pathStyles!.isNotEmpty) {
      list.add('pathStyle=${params.pathStyles}');
    }
    
    if (params.layers != null && params.layers!.isNotEmpty) {
      list.add('layers=${params.layers}');
    }
    
    if (params.pixLocation != null && params.pixLocation!.isNotEmpty) {
      list.add('pixLocation=${params.pixLocation}');
    }

    final url = '/staticimage?${list.join('&')}';
    
    return requestBytes(url);
  }
}
