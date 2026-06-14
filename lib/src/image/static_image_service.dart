import 'dart:typed_data';

import '../common/base_service.dart';
import 'params/static_image_params.dart';

/// 静态地图服务类
/// 实现将天地图地图以图片形式嵌入到您的网页中
class StaticImageService extends BaseService {
  /// 创建StaticImageService实例
  /// [tk] 天地图密钥
  StaticImageService(super.tk, {super.client, super.baseUri, super.timeout});

  /// 获取静态地图图片
  /// [params] 静态地图参数
  /// 返回：图片的字节数组
  Future<Uint8List> getImage(StaticImageParams params) {
    return requestBytes(
      '/staticimage',
      queryParameters: {
        'width': params.width.toString(),
        'height': params.height.toString(),
        'zoom': params.zoom.toString(),
        'center': params.center,
        'markers': params.markers,
        'markerStyles': params.markerStyles,
        'paths': params.paths,
        'pathStyle': params.pathStyles,
        'layers': params.layers,
        'pixLocation': params.pixLocation,
      },
    );
  }
}
