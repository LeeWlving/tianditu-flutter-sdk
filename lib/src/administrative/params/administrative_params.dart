
/// 行政区划查询参数模型
class AdministrativeParams {
  /// 关键词
  /// 规则：只支持单个关键词语搜索
  /// 关键词支持：行政区划名称、行政区划编码
  /// 例如，keyword='北京'或keyword='156110000'
  /// 说明：支持模糊查询
  final String? keyword;
  
  /// 设置显示下级行政区级数（行政区级别包括：国家、省/直辖市、市、区/县、乡镇/街道多级数据
  /// 可选值：0、1、2、3
  /// 0：不返回下级行政区
  /// 1：返回下一级行政区
  /// 2：返回下两级行政区
  /// 3：返回下三级行政区
  /// 需要在此特殊说明，目前部分城市和省直辖县因为没有区县的概念，故在市级下方直接显示街道。
  /// 例如：河南-济源
  final int childLevel;
  
  /// 是否需要轮廓数据
  /// 可选值：true、false
  /// true: 返回轮廓数据
  /// false：不返回轮廓数据
  final bool extensions;

  /// 创建AdministrativeParams实例
  AdministrativeParams({
    this.keyword,
    this.childLevel = 0,
    this.extensions = false,
  });
}
