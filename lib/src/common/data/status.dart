/// 状态模型
class Status {
  /// 信息码 	Int 	必返回 	服务状态码表
  final int? infocode;

  /// 返回中文描述 	String 	必返回 	服务状态码表
  final String? cndesc;

  /// 创建Status实例
  Status({this.infocode, this.cndesc});

  /// 从JSON字符串解析Status
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      infocode: json['infocode'] as int?,
      cndesc: json['cndesc'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {'infocode': infocode, 'cndesc': cndesc};
  }
}
