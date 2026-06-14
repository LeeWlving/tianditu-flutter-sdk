# 天地图 Flutter SDK 示例

示例展示以下能力：

- 矢量、影像和地形底图切换
- Marker 和 Circle 覆盖物
- 获取设备当前位置
- 用户位置蓝点和定位精度圈
- 使用控制器移动地图

## 运行

在天地图控制台申请客户端 Key，然后执行：

```bash
flutter pub get
flutter run --dart-define=TIANDITU_TK=你的Key
```

Web 示例：

```bash
flutter run -d chrome --dart-define=TIANDITU_TK=你的Key
```

未提供 Key 时，地图区域会显示配置提示，不会发起瓦片请求。

## 定位权限

运行定位功能前，需要在目标平台配置权限。完整配置见：

[平台定位权限配置](../doc/platform-setup.md)

示例工程目前是轻量 Dart 示例目录，没有提交完整 Android、iOS、macOS 和 Web
工程壳。需要真机运行时，可在 `example` 目录执行：

```bash
flutter create .
```

然后按照平台配置文档添加权限。该命令可能更新示例工程文件，执行前应先检查 Git
工作区。

## API Key

示例使用编译时环境变量读取 Key：

```dart
const apiKey = String.fromEnvironment('TIANDITU_TK');
```

这只能避免把 Key 直接写入源码，不能让客户端 Key 成为秘密。生产环境必须在天地图
控制台配置 Android 包名、iOS Bundle ID 或 Web 域名白名单，并限制 Key 权限。
