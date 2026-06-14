import 'package:http/http.dart' as http;

import 'administrative/administrative_service.dart';
import 'bus/bus_service.dart';
import 'coder/geo_coder_service.dart';
import 'drive/drive_service.dart';
import 'image/static_image_service.dart';
import 'location/tianditu_location_service.dart';
import 'place/place_search_service.dart';

/// 天地图 WEB 服务入口类。
class TiandituService {
  /// 天地图API基础URL
  static const String defaultBaseUrl = 'https://api.tianditu.gov.cn';

  /// 兼容旧版本的 API 基础地址。
  @Deprecated('Use defaultBaseUrl instead.')
  static const String uri = defaultBaseUrl;

  /// 申请的密钥
  final String tk;

  final http.Client _client;
  final bool _ownsClient;
  final Uri _baseUri;
  final Duration _timeout;

  /// 设备定位服务。它使用操作系统定位能力，不消耗天地图 Key 配额。
  final TiandituLocationService location = const TiandituLocationService();

  late final PlaceSearchService placeSearch = PlaceSearchService(
    tk,
    client: _client,
    baseUri: _baseUri,
    timeout: _timeout,
  );
  late final GeoCoderService geocoder = GeoCoderService(
    tk,
    client: _client,
    baseUri: _baseUri,
    timeout: _timeout,
  );
  late final AdministrativeService administrative = AdministrativeService(
    tk,
    client: _client,
    baseUri: _baseUri,
    timeout: _timeout,
  );
  late final DriveService drive = DriveService(
    tk,
    client: _client,
    baseUri: _baseUri,
    timeout: _timeout,
  );
  late final StaticImageService staticImage = StaticImageService(
    tk,
    client: _client,
    baseUri: _baseUri,
    timeout: _timeout,
  );
  late final BusService bus = BusService(
    tk,
    client: _client,
    baseUri: _baseUri,
    timeout: _timeout,
  );

  /// 创建天地图WEB服务对象
  /// [tk] 申请的密钥
  TiandituService(
    this.tk, {
    http.Client? client,
    Uri? baseUri,
    Duration timeout = const Duration(seconds: 15),
  }) : _client = client ?? http.Client(),
       _ownsClient = client == null,
       _baseUri = baseUri ?? Uri.parse(defaultBaseUrl),
       _timeout = timeout {
    if (tk.trim().isEmpty) {
      throw ArgumentError.value(tk, 'tk', 'must not be empty');
    }
  }

  /// 获取地名搜索服务
  PlaceSearchService getPlaceSearchService() => placeSearch;

  /// 获取地理编码/逆地理编码服务
  GeoCoderService getGeoCoderService() => geocoder;

  /// 获取行政区划服务
  AdministrativeService getAdministrativeService() => administrative;

  /// 获取驾车规划服务
  DriveService getDriveService() => drive;

  /// 获取静态地图服务
  StaticImageService getStaticImageService() => staticImage;

  /// 获取公交规划服务
  BusService getBusService() => bus;

  /// 释放 SDK 创建的网络资源。
  void close() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
