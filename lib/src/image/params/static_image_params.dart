/// 静态地图参数模型
class StaticImageParams {
  /// 图片宽度，默认值：512，取值范围：[1, 1024]
  final int width;

  /// 图片高度，默认值：512，取值范围：[1, 1024]
  final int height;

  /// 地图中心点位置，参数为经纬度坐标，格式：lng,lat
  /// 默认值：116.39127,39.90712
  final String? center;

  /// 地图级别，默认值：10，取值范围：[3,18]
  final int zoom;

  /// 标注，为经纬度格式
  /// 多个标注之间用竖线隔开，如: lng1,lat1|lng2,lat2|lng3,lat3
  final String? markers;

  /// 设置默认图标样式和自定义图标样式
  /// 同一个点的描述参数之间用逗号","隔开，
  /// 不同点之间的风格描述用竖线"|"隔开,
  /// 风格描述主要有size,label,url[,sLabel,fontColor,fontSize]
  final String? markerStyles;

  /// 折线
  /// 可通过经纬度描述；折线之间用竖线"|"分隔；
  /// 每条折线的点之间用分号";"分隔;
  /// 点坐标用逗号","分隔。坐标格式：lng,lat
  final String? paths;

  /// 折线样式
  /// color,weight,opacity[,fillColor]取值范围：
  /// 颜色color：16进制表示的数值,如默认值蓝色0xff0000,
  /// 线宽weight：[1-40]，默认值6，
  /// 透明度opacity：[0-1]，默认值0.6，
  /// 填充图颜色fillColor：16进制表示的数值
  final String? pathStyles;

  /// 静态图叠加层的类型
  /// 如："vec_c,cva_c" 或者 "img_c,cva_c" 等类型组合
  /// img_c--影像图
  /// vec_c--矢量底图
  /// ter_c--地形图
  /// cva_c--中文注记
  /// eva_c--英文注记
  /// cta_c--地形注记
  final String? layers;

  /// 特别说明参数
  /// 此参数是为了获得当前给定中心点经纬度、宽度、和高度范围后，
  /// 用户自己想在生成的静态图上标注，
  /// 本参数就是将指定的经纬度坐标转换成静态图上相对于静态图左上角（0,0）的屏幕坐标，返回的字符串为双竖线隔开的坐标对。
  /// 当请求中有此参数时，优先处理此参数。markers,markerStyles,paths,pathStyles参数都不起作用，
  /// 参数格式为：lng0,lat0|lng1,lat1|lng2,lat2
  final String? pixLocation;

  /// 创建StaticImageParams实例
  StaticImageParams({
    this.width = 512,
    this.height = 512,
    this.center,
    this.zoom = 10,
    this.markers,
    this.markerStyles,
    this.paths,
    this.pathStyles,
    this.layers,
    this.pixLocation,
  });
}
