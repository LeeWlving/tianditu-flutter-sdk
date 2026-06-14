import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
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
      expect(identical(service, tiandituService.placeSearch), isTrue);
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

    test('should provide device location service', () {
      expect(tiandituService.location, isA<TiandituLocationService>());
    });
  });

  group('HTTP client', () {
    test('encodes query values and appends the API key', () async {
      late Uri requestedUri;
      final client = MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({
            'status': '0',
            'msg': 'OK',
            'location': {'lon': 116.3, 'lat': 39.9},
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final service = TiandituService(
        'test key',
        client: client,
        baseUri: Uri.parse('https://example.test'),
      );

      await service.geocoder.geocode(address: '北京市 海淀区');

      expect(requestedUri.path, '/geocoder');
      expect(requestedUri.queryParameters['tk'], 'test key');
      expect(
        jsonDecode(requestedUri.queryParameters['ds']!)['keyWord'],
        '北京市 海淀区',
      );
    });

    test('reports HTTP status codes', () async {
      final client = MockClient((_) async => http.Response('failed', 503));
      final service = TiandituService(
        'test-key',
        client: client,
        baseUri: Uri.parse('https://example.test'),
      );

      await expectLater(
        service.geocoder.geocode(address: '北京'),
        throwsA(
          isA<TiandituException>().having(
            (error) => error.statusCode,
            'statusCode',
            503,
          ),
        ),
      );
    });
  });

  group('TiandituMap', () {
    testWidgets('shows a configuration message when the key is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TiandituMap(apiKey: '')),
        ),
      );

      expect(find.text('请配置天地图 API Key'), findsOneWidget);
    });

    testWidgets('accepts commercial map primitives', (tester) async {
      const center = TiandituLatLng(39.9042, 116.4074);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: TiandituMap(
                apiKey: 'test-key',
                showAttribution: false,
                markers: [
                  TiandituMarker(
                    position: center,
                    child: Icon(Icons.location_pin),
                  ),
                ],
                polylines: [
                  TiandituPolyline(
                    points: [center, TiandituLatLng(39.91, 116.42)],
                  ),
                ],
                polygons: [
                  TiandituPolygon(
                    points: [
                      center,
                      TiandituLatLng(39.91, 116.42),
                      TiandituLatLng(39.89, 116.43),
                    ],
                  ),
                ],
                circles: [TiandituCircle(center: center, radiusInMeters: 500)],
                userLocation: TiandituUserLocation(
                  position: center,
                  accuracyInMeters: 20,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TiandituMap), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Place search', () {
    test('builds a nearby search with typed coordinates', () {
      final params = PlaceSearchParams.nearby(
        keyword: '咖啡',
        center: const TiandituLatLng(39.9, 116.4),
        radiusInMeters: 1500,
        page: 2,
        pageSize: 20,
      );

      expect(params.queryType, PlaceSearchType.nearby.value);
      expect(params.pointLonlat, '116.4,39.9');
      expect(params.start, '40');
      expect(params.count, '20');
    });

    test('closes polygon search coordinates', () {
      final params = PlaceSearchParams.inPolygon(
        keyword: '学校',
        points: const [
          TiandituLatLng(39.9, 116.4),
          TiandituLatLng(39.91, 116.4),
          TiandituLatLng(39.91, 116.41),
        ],
      );

      expect(params.queryType, PlaceSearchType.polygon.value);
      expect(params.polygon, endsWith('116.4,39.9'));
    });
  });

  group('Route planning', () {
    test('builds coordinate based drive parameters', () {
      final params = DriveParams.coordinates(
        origin: const TiandituLatLng(39.9, 116.4),
        destination: const TiandituLatLng(39.92, 116.45),
        strategy: DriveRouteStrategy.walking,
      );

      expect(params.orig, '116.4,39.9');
      expect(params.dest, '116.45,39.92');
      expect(params.style, 3);
    });

    test('parses route coordinates for flutter_map rendering', () {
      final result = DriveResult.fromJson({
        'distance': '12.5',
        'duration': 600,
        'routelatlon': '116.4,39.9;116.45,39.92',
      });

      expect(result.distance, 12.5);
      expect(result.duration, 600);
      expect(result.path, const [
        TiandituLatLng(39.9, 116.4),
        TiandituLatLng(39.92, 116.45),
      ]);
      expect(result.toPolyline().points, result.path);
    });
  });

  group('Geofence', () {
    TiandituPosition position(double latitude, double longitude) {
      return TiandituPosition(
        coordinate: TiandituLatLng(latitude, longitude),
        timestamp: DateTime.utc(2026),
      );
    }

    test('evaluates circle and polygon containment', () {
      const circle = TiandituCircularGeofence(
        id: 'office',
        center: TiandituLatLng(39.9, 116.4),
        radiusInMeters: 1000,
      );
      final polygon = TiandituPolygonGeofence(
        id: 'district',
        points: [
          TiandituLatLng(39.89, 116.39),
          TiandituLatLng(39.91, 116.39),
          TiandituLatLng(39.91, 116.41),
          TiandituLatLng(39.89, 116.41),
        ],
      );

      expect(circle.contains(const TiandituLatLng(39.901, 116.401)), isTrue);
      expect(circle.contains(const TiandituLatLng(40.0, 116.5)), isFalse);
      expect(polygon.contains(const TiandituLatLng(39.9, 116.4)), isTrue);
      expect(polygon.contains(const TiandituLatLng(40.0, 116.5)), isFalse);
    });

    test('emits enter and exit transitions', () {
      final monitor = TiandituGeofenceMonitor([
        const TiandituCircularGeofence(
          id: 'office',
          center: TiandituLatLng(39.9, 116.4),
          radiusInMeters: 1000,
        ),
      ]);

      expect(monitor.evaluate(position(40.0, 116.5)), isEmpty);
      expect(
        monitor.evaluate(position(39.9, 116.4)).single.transition,
        TiandituGeofenceTransition.enter,
      );
      expect(
        monitor.evaluate(position(40.0, 116.5)).single.transition,
        TiandituGeofenceTransition.exit,
      );
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
