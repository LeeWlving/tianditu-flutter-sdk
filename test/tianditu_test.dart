import 'package:flutter_test/flutter_test.dart';
import 'package:tianditu/tianditu.dart';

void main() {
  // 创建测试用的天地图服务实例
  final tiandituService = TiandituService('test_api_key');

  group('TiandituService', () {
    test('should create instance with api key', () {
      expect(tiandituService, isInstanceOf<TiandituService>());
    });

    test('should provide PlaceSearchService', () {
      final service = tiandituService.getPlaceSearchService();
      expect(service, isNotNull);
    });

    test('should provide GeoCoderService', () {
      final service = tiandituService.getGeoCoderService();
      expect(service, isNotNull);
    });

    test('should provide AdministrativeService', () {
      final service = tiandituService.getAdministrativeService();
      expect(service, isNotNull);
    });

    test('should provide DriveService', () {
      final service = tiandituService.getDriveService();
      expect(service, isNotNull);
    });

    test('should provide StaticImageService', () {
      final service = tiandituService.getStaticImageService();
      expect(service, isNotNull);
    });

    test('should provide BusService', () {
      final service = tiandituService.getBusService();
      expect(service, isNotNull);
    });
  });

  group('Data Models', () {
    test('Location should be created correctly', () {
      final location = Location(
        score: 90,
        keyWord: '北京',
        lon: 116.397428,
        level: 'city',
        lat: 39.90923,
      );
      
      expect(location.score, 90);
      expect(location.keyWord, '北京');
      expect(location.lon, 116.397428);
      expect(location.level, 'city');
      expect(location.lat, 39.90923);
    });

    test('Location should parse numeric strings', () {
      final location = Location.fromJson({
        'score': '90',
        'keyWord': '北京',
        'lon': '116.397428',
        'level': 'city',
        'lat': '39.90923',
      });

      expect(location.score, 90);
      expect(location.lon, 116.397428);
      expect(location.lat, 39.90923);
    });

    test('Address should be created correctly', () {
      final location = Location(lon: 116.397428, lat: 39.90923);
      final addressDetail = AddressDetail(
        province: '北京市',
        city: '北京市',
        county: '东城区',
      );
      
      final address = Address(
        formattedAddress: '北京市东城区天安门',
        location: location,
        addressComponent: addressDetail,
      );
      
      expect(address.formattedAddress, '北京市东城区天安门');
      expect(address.location?.lon, 116.397428);
      expect(address.addressComponent?.province, '北京市');
    });

    test('AddressDetail should accept *_distince and string distances', () {
      final detail = AddressDetail.fromJson({
        'address_distince': '45',
        'road_distince': 30,
        'poi_distince': '120',
      });

      expect(detail.addressDistance, 45);
      expect(detail.roadDistance, 30);
      expect(detail.poiDistance, 120);
    });
  });
}
