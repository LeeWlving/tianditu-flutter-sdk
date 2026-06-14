# 平台定位权限配置

天地图提供地图数据和 Web Service，但设备定位由操作系统提供。本 SDK 通过
`geolocator` 访问系统定位能力。

只申请业务实际需要的权限。普通“定位到当前位置”通常只需要前台定位权限。

## Android

在 `android/app/src/main/AndroidManifest.xml` 的 `<application>` 外添加：

```xml
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

只有业务确实需要后台定位时才添加：

```xml
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

后台定位还涉及 Android 版本差异、前台服务和应用商店合规要求；当前 SDK 的地理围栏
实现是前台定位流计算，不依赖也不保证后台定位。

## iOS

在 `ios/Runner/Info.plist` 中添加：

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>用于在地图上显示你的位置并提供周边搜索</string>
```

如果应用确实需要后台持续定位，还需要相应的 Always 权限说明和 Background Modes。
当前 SDK 不要求也不默认启用后台定位。

## macOS

在 `macos/Runner/Info.plist` 添加：

```xml
<key>NSLocationUsageDescription</key>
<string>用于在地图上显示你的位置</string>
```

并在 Runner 的 entitlements 中启用定位能力。具体 entitlement 名称和签名要求应以
当前 Flutter 与 Apple 文档为准。

## Web

浏览器定位要求：

- 页面通过 HTTPS 提供，或运行在 localhost
- 用户在浏览器权限提示中允许位置访问
- 页面不能处于禁止定位权限的 iframe 策略中

浏览器拒绝权限后，应用应捕获 `TiandituLocationException` 并给出设置指引。

## Windows

Windows 用户需要在系统“位置”设置中允许桌面应用访问位置。SDK 可调用：

```dart
await tianditu.location.openLocationSettings();
await tianditu.location.openAppSettings();
```

不同平台对设置页面跳转的支持程度不同，调用结果应作为提示能力处理。

## 权限处理建议

```dart
try {
  await tianditu.location.ensurePermission();
  final position = await tianditu.location.getCurrentPosition(
    requestPermission: false,
  );
} on TiandituLocationException catch (error) {
  debugPrint(error.message);
}
```

不要在应用启动时无条件申请定位权限。应在用户触发“我的位置”、周边搜索或围栏功能时
解释用途并申请。
