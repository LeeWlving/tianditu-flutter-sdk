
/// 天地图WEB服务入口类
import 'administrative/administrative_service.dart';
import 'bus/bus_service.dart';
import 'coder/geo_coder_service.dart';
import 'drive/drive_service.dart';
import 'image/static_image_service.dart';
import 'place/place_search_service.dart';

class TiandituService {
  /// 天地图API基础URL
  static const String uri = 'https://api.tianditu.gov.cn';

  /// 申请的密钥
  final String tk;

  /// 创建天地图WEB服务对象
  /// [tk] 申请的密钥
  TiandituService(this.tk);

  /// 获取地名搜索服务
  PlaceSearchService getPlaceSearchService() => PlaceSearchService(tk);

  /// 获取地理编码/逆地理编码服务
  GeoCoderService getGeoCoderService() => GeoCoderService(tk);

  /// 获取行政区划服务
  AdministrativeService getAdministrativeService() => AdministrativeService(tk);

  /// 获取驾车规划服务
  DriveService getDriveService() => DriveService(tk);

  /// 获取静态地图服务
  StaticImageService getStaticImageService() => StaticImageService(tk);

  /// 获取公交规划服务
  BusService getBusService() => BusService(tk);
}
