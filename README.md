# 天地图 Flutter SDK

面向 Flutter 的天地图地图组件与 Web Service 客户端。地图组件使用纯 Flutter
渲染，支持 Android、iOS、Web、macOS、Windows 和 Linux。

## 当前能力

- 天地图矢量、影像、地形底图及中文注记
- 地图拖动、缩放、旋转、范围自适应和控制器
- Marker、Polyline、Polygon、Circle 覆盖物
- 一次定位、持续定位、用户位置蓝点和精度圈
- 圆形和多边形前台地理围栏
- 点击、长按和相机变化回调
- 普通、区域、周边、视野和多边形 POI 搜索
- 地理编码、行政区划、驾车、步行、公交和静态地图服务
- 可注入 HTTP Client、请求超时、结构化异常和统一资源释放

## 安装

```yaml
dependencies:
  tianditu: ^0.1.0
```

```bash
flutter pub get
```

在[天地图控制台](https://console.tianditu.gov.cn/api/key)创建应用并获取 Key。
生产应用应配置平台和域名白名单，不要把具备服务端权限的 Key 放入客户端。

## 文档导航

- [示例应用](example/README.md)
- [平台定位权限配置](doc/platform-setup.md)
- [功能支持矩阵](doc/capabilities.md)

## 地图组件

```dart
import 'package:flutter/material.dart';
import 'package:tianditu/tianditu.dart';

const apiKey = String.fromEnvironment('TIANDITU_TK');
const beijing = TiandituLatLng(39.9042, 116.4074);

TiandituMap(
  apiKey: apiKey,
  mapType: TiandituMapType.vector,
  initialCamera: const TiandituCameraPosition(
    target: beijing,
    zoom: 12,
  ),
  markers: const [
    TiandituMarker(
      position: beijing,
      alignment: Alignment.bottomCenter,
      child: Icon(Icons.location_pin, color: Colors.red, size: 40),
    ),
  ],
  onTap: (position) => debugPrint('$position'),
);
```

运行示例：

```bash
cd example
flutter run --dart-define=TIANDITU_TK=你的Key
```

### 控制地图

```dart
final controller = TiandituMapController();

TiandituMap(
  apiKey: apiKey,
  controller: controller,
);

controller.move(const TiandituLatLng(31.2304, 121.4737), 14);
controller.rotate(30);
```

## 定位

定位来自 Android、iOS、Web、macOS 和 Windows 的系统能力，不是天地图服务。

```dart
final tianditu = TiandituService(apiKey);
final position = await tianditu.location.getCurrentPosition();

TiandituMap(
  apiKey: apiKey,
  controller: controller,
  userLocation: TiandituUserLocation(
    position: position.coordinate,
    accuracyInMeters: position.accuracy,
  ),
);
```

持续定位：

```dart
final positions = tianditu.location.getPositionStream(
  options: const TiandituLocationOptions(
    accuracy: TiandituLocationAccuracy.high,
    distanceFilter: 10,
  ),
);
```

应用侧必须配置平台权限：

- Android：`ACCESS_COARSE_LOCATION` 或 `ACCESS_FINE_LOCATION`
- iOS：`NSLocationWhenInUseUsageDescription`
- macOS：位置权限描述及 Location entitlement
- Web：必须使用 HTTPS 或 localhost，由浏览器授权

完整配置见[平台定位权限配置](doc/platform-setup.md)。

只有确实需要后台定位时才应申请后台权限。当前 SDK 不承诺应用被系统终止后的后台持续定位。

## 搜索

```dart
final result = await tianditu.placeSearch.searchNearby(
  keyword: '充电站',
  center: position.coordinate,
  radiusInMeters: 3000,
);

final visibleResult = await tianditu.placeSearch.searchInBounds(
  keyword: '医院',
  bounds: const TiandituLatLngBounds(
    southwest: TiandituLatLng(39.8, 116.2),
    northeast: TiandituLatLng(40.0, 116.6),
  ),
  zoom: 12,
);
```

也可使用 `PlaceSearchParams.keyword`、`inRegion`、`nearby`、`inBounds` 和
`inPolygon` 构造复杂请求。

## 路线规划

```dart
final route = await tianditu.drive.plan(
  origin: const TiandituLatLng(39.9042, 116.4074),
  destination: const TiandituLatLng(39.9911, 116.3103),
  strategy: DriveRouteStrategy.fastest,
);

final routeLine = route.toPolyline();
controller.fitCoordinates(route.path);

TiandituMap(
  apiKey: apiKey,
  polylines: [routeLine],
);
```

`DriveRouteStrategy.walking` 可用于步行规划。公交接口目前仍返回天地图原始 JSON，
后续需要根据真实响应样本补齐稳定的数据模型。

这里的“路线规划”是获取路线几何和分段描述，不包括导航状态机、道路匹配、实时路况、
偏航重算或语音播报。

## 地理围栏

```dart
final monitor = TiandituGeofenceMonitor([
  const TiandituCircularGeofence(
    id: 'office',
    center: TiandituLatLng(39.9042, 116.4074),
    radiusInMeters: 500,
  ),
]);

final events = monitor.monitor(
  tianditu.location.getPositionStream(),
);

events.listen((event) {
  debugPrint('${event.geofence.id}: ${event.transition}');
});
```

该实现适合应用在前台运行期间的业务围栏。Android Geofencing API、iOS
Region Monitoring 一类系统级后台围栏需要单独的原生插件和后台权限。

## Web Service

`TiandituService` 会复用一个 HTTP Client。由 SDK 创建服务时，应在不再使用后调用
`close()`。

```dart
final tianditu = TiandituService(apiKey);

try {
  final result = await tianditu.geocoder.geocode(address: '北京市天安门');
  debugPrint('${result.location?.lon}, ${result.location?.lat}');

  final places = await tianditu.placeSearch.search(
    PlaceSearchParams(
      keyWord: '餐厅',
      specify: '北京',
      count: '20',
    ),
  );
  debugPrint('结果数量: ${places.count}');
} on TiandituException catch (error) {
  debugPrint('${error.statusCode}: ${error.message}');
} finally {
  tianditu.close();
}
```

旧版 `getGeoCoderService()` 等方法仍可使用，但推荐直接使用 `geocoder`、
`placeSearch`、`administrative`、`drive`、`bus` 和 `staticImage` 属性。

## 天地图不能单独提供的能力

| 功能 | 当前实现 | 限制 |
|---|---|---|
| 设备定位 | 系统定位服务 | 不是天地图 API |
| 天气 | 未内置 | 需要中国天气、和风天气等独立供应商及其 Key |
| 前台地理围栏 | SDK 几何计算 | 应用停止后不会继续触发 |
| 后台地理围栏 | 未内置 | 需要 Android/iOS 原生后台能力 |
| 路线规划 | 天地图 Web Service | 可获得路线数据，但不是实时导航引擎 |
| 实时导航 | 未内置 | 缺少道路匹配、偏航重算、路况和语音播报 |

天气供应商应由业务应用选择，SDK 不会伪造或从地图瓦片推导天气。建议通过独立的
`WeatherRepository` 在业务层接入，避免把另一家服务的 Key 和配额耦合进地图 SDK。
完整支持情况见[功能支持矩阵](doc/capabilities.md)。

## 其他能力边界

当前版本提供的是天地图 WMTS 栅格底图组件，不等同于 Mapbox 的客户端矢量渲染
引擎。以下能力尚未实现：

- 矢量瓦片样式表达式和运行时换肤
- 聚合标注、热力图、海量点和 3D 地形
- 离线地图包、磁盘缓存策略和请求配额治理
- 轨迹吸附、实时路况、偏航重算和导航播报
- 原生 Android/iOS 天地图 SDK 适配

向商业级 SDK 演进时，建议按“稳定 API 与可观测性、缓存与海量覆盖物、定位与轨迹、
离线能力、矢量渲染与导航”的顺序迭代，并为每项能力建立性能基线和真机集成测试。

## 许可证

MIT。地图数据和服务的使用仍须遵守天地图平台条款及配额限制。
