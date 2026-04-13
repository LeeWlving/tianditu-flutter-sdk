# 天地图Flutter SDK

天地图Flutter SDK，封装了天地图WEB服务API，提供了丰富的地理空间数据服务。

## 功能特点

- 🌍 地名搜索服务 - 支持多种条件的POI搜索
- 📍 地理编码/逆地理编码服务 - 实现地址与坐标的相互转换
- 🗺️ 行政区划服务 - 获取各级行政区划信息
- 🚗 驾车规划服务 - 提供驾车路线规划
- 🚌 公交规划服务 - 提供公交路线规划
- 📷 静态地图服务 - 生成静态地图图片

## 安装

在你的Flutter项目的`pubspec.yaml`文件中添加以下依赖：

```yaml
dependencies:
  tianditu: ^0.0.1
```

然后运行：

```bash
flutter pub get
```

## 使用示例

### 初始化服务

```dart
import 'package:tianditu/tianditu.dart';

// 替换为你自己的天地图API密钥
final tiandituService = TiandituService('your_tian_di_tu_api_key');
```

### 地名搜索示例

```dart
final placeSearchService = tiandituService.getPlaceSearchService();

// 根据关键词搜索POI
final searchResult = await placeSearchService.search(
  keyword: '餐厅',
  city: '北京',
  pageSize: 10,
);

// 输出搜索结果
print('搜索到的餐厅数量: ${searchResult.pois.length}');
for (var poi in searchResult.pois) {
  print('${poi.name} - ${poi.address}');
}
```

### 地理编码示例

```dart
final geoCoderService = tiandituService.getGeoCoderService();

// 地址转坐标
final geocodeResult = await geoCoderService.geocode(
  address: '北京市海淀区中关村南大街5号',
);

print('坐标: ${geocodeResult.location.lat}, ${geocodeResult.location.lon}');
```

### 逆地理编码示例

```dart
// 坐标转地址
final reverseGeocodeResult = await geoCoderService.reverseGeocode(
  location: Location(lat: 39.908722, lon: 116.397496),
);

print('地址: ${reverseGeocodeResult.address}');
print('详细地址: ${reverseGeocodeResult.addressDetail}');
```

### 静态地图示例

```dart
final staticImageService = tiandituService.getStaticImageService();

// 获取静态地图URL
final mapUrl = staticImageService.getStaticImageUrl(
  location: Location(lat: 39.908722, lon: 116.397496),
  zoom: 15,
  width: 600,
  height: 400,
);

// 在Image组件中使用
Image.network(mapUrl);
```

## 服务说明

| 服务名称 | 描述 | 使用方法 |
|---------|------|--------|
| 地名搜索服务 | 支持关键词、分类、区域等多种条件的POI搜索 | `tiandituService.getPlaceSearchService()` |
| 地理编码服务 | 实现地址到坐标的转换 | `tiandituService.getGeoCoderService()` |
| 逆地理编码服务 | 实现坐标到地址的转换 | `tiandituService.getGeoCoderService()` |
| 行政区划服务 | 获取各级行政区划信息 | `tiandituService.getAdministrativeService()` |
| 驾车规划服务 | 提供驾车路线规划 | `tiandituService.getDriveService()` |
| 公交规划服务 | 提供公交路线规划 | `tiandituService.getBusService()` |
| 静态地图服务 | 生成静态地图图片 | `tiandituService.getStaticImageService()` |

## 获取API密钥

1. 访问[天地图开发者平台](https://console.tianditu.gov.cn/api/key)
2. 注册/登录账号
3. 创建新应用
4. 获取API密钥

## 注意事项

1. 本SDK仅封装了天地图WEB服务API，使用时需遵守天地图的使用条款
2. 不同服务的API调用次数限制不同，请合理使用
3. 部分服务需要额外开通权限，请在天地图控制台查看
4. 建议在生产环境中使用时，对API密钥进行安全管理

## 依赖库

- [http](https://pub.dev/packages/http) - 用于网络请求
- [xml](https://pub.dev/packages/xml) - 用于XML数据解析

## 许可证

MIT License

## 贡献

欢迎提交Issue和Pull Request！

## 联系方式

如有问题或建议，请通过以下方式联系：

- GitHub: [https://github.com/LeeWlving/tianditu-flutter-sdk](https://github.com/LeeWlving/tianditu-flutter-sdk)
- 邮箱: LeeWlving@gmail.com
