import 'dart:convert';
Citymodal citymodalFromJson(String str) => Citymodal.fromJson(json.decode(str));
String citymodalToJson(Citymodal data) => json.encode(data.toJson());
class Citymodal {
  Citymodal({
      bool? success, 
      String? message, 
      List<Data>? data, 
      String? responseTime,}){
    _success = success;
    _message = message;
    _data = data;
    _responseTime = responseTime;
}

  Citymodal.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _responseTime = json['response_time'];
  }
  bool? _success;
  String? _message;
  List<Data>? _data;
  String? _responseTime;
Citymodal copyWith({  bool? success,
  String? message,
  List<Data>? data,
  String? responseTime,
}) => Citymodal(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
  responseTime: responseTime ?? _responseTime,
);
  bool? get success => _success;
  String? get message => _message;
  List<Data>? get data => _data;
  String? get responseTime => _responseTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['response_time'] = _responseTime;
    return map;
  }

}



Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      num? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  num? _id;
  String? _name;
Data copyWith({  num? id,
  String? name,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
);
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}