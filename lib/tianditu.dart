/// 天地图 Flutter SDK。
///
/// 导出服务入口、请求参数、响应数据模型和 SDK 异常类型。
library;

// 服务入口
export 'src/tianditu_service.dart';

// 异常
export 'src/common/tianditu_exception.dart';

// 通用数据模型
export 'src/common/data/location.dart';
export 'src/common/data/address.dart';
export 'src/common/data/address_detail.dart';
export 'src/common/data/poi.dart';
export 'src/common/data/status.dart';
export 'src/common/data/area.dart';
export 'src/common/data/line.dart';
export 'src/common/data/station_data.dart';
export 'src/common/data/priority_city.dart';
export 'src/common/data/priority_province.dart';

// 地名搜索
export 'src/place/place_search_service.dart';
export 'src/place/params/place_search_params.dart';
export 'src/place/data/place_search_result.dart';
export 'src/place/data/place_statistic.dart';

// 地理编码
export 'src/coder/geo_coder_service.dart';
export 'src/coder/data/geo_coder_address_result.dart';
export 'src/coder/data/geo_coder_location_result.dart';

// 行政区划
export 'src/administrative/administrative_service.dart';
export 'src/administrative/params/administrative_params.dart';
export 'src/administrative/data/administrative_result.dart';

// 驾车规划
export 'src/drive/drive_service.dart';
export 'src/drive/params/drive_params.dart';
export 'src/drive/data/drive_mapinfo.dart';
export 'src/drive/data/drive_result.dart';
export 'src/drive/data/route_item.dart';
export 'src/drive/data/simple_item.dart';

// 静态地图
export 'src/image/static_image_service.dart';
export 'src/image/params/static_image_params.dart';

// 公交规划
export 'src/bus/bus_service.dart';
export 'src/bus/params/bus_line_params.dart';
