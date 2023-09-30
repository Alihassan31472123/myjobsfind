import 'dart:convert';
/// success : true
/// job_type : ["full time","part time","Remote"]

Jobtypemodaldart jobtypemodaldartFromJson(String str) => Jobtypemodaldart.fromJson(json.decode(str));
String jobtypemodaldartToJson(Jobtypemodaldart data) => json.encode(data.toJson());
class Jobtypemodaldart {
  Jobtypemodaldart({
      bool? success, 
      List<String>? jobType,}){
    _success = success;
    _jobType = jobType;
}

  Jobtypemodaldart.fromJson(dynamic json) {
    _success = json['success'];
    _jobType = json['job_type'] != null ? json['job_type'].cast<String>() : [];
  }
  bool? _success;
  List<String>? _jobType;
Jobtypemodaldart copyWith({  bool? success,
  List<String>? jobType,
}) => Jobtypemodaldart(  success: success ?? _success,
  jobType: jobType ?? _jobType,
);
  bool? get success => _success;
  List<String>? get jobType => _jobType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['job_type'] = _jobType;
    return map;
  }

}