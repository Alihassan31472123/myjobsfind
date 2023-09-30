import 'dart:convert';

Jobsmodal jobsmodalFromJson(String str) => Jobsmodal.fromJson(json.decode(str));
String jobsmodalToJson(Jobsmodal data) => json.encode(data.toJson());
class Jobsmodal {
  Jobsmodal({
      bool? success, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}
Jobsmodal.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _success;
  String? _message;
  List<Data>? _data;
Jobsmodal copyWith({  bool? success,
  String? message,
  List<Data>? data,
}) => Jobsmodal(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
  }
Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      num? id, 
      num? employerId, 
      String? jobCategorySlug, 
      String? companyName, 
      String? jobTitle, 
      String? fullName, 
      String? description, 
      String? jobsEmail, 
      String? phone, 
      String? salary, 
      dynamic role, 
      String? companyLogo, 
      String? country, 
      String? noOfHiring, 
      String? city, 
      String? deadline, 
      String? jobStatus,                                                                        
      String? jobType, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _employerId = employerId;
    _jobCategorySlug = jobCategorySlug;
    _companyName = companyName;
    _jobTitle = jobTitle;
    _fullName = fullName;
    _description = description;
    _jobsEmail = jobsEmail;
    _phone = phone;
    _salary = salary;
    _role = role;
    _companyLogo = companyLogo;
    _country = country;
    _noOfHiring = noOfHiring;
    _city = city;
    _deadline = deadline;
    _jobStatus = jobStatus;
    _jobType = jobType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}
Data.fromJson(dynamic json) {
    _id = json['id'];
    _employerId = json['employer_id'];
    _jobCategorySlug = json['job_category_slug'];
    _companyName = json['company_name'];
    _jobTitle = json['job_title'];
    _fullName = json['full_name'];
    _description = json['description'];
    _jobsEmail = json['jobs_email'];
    _phone = json['phone'];
    _salary = json['salary'];
    _role = json['role'];
    _companyLogo = json['company_logo'];
    _country = json['country'];
    _noOfHiring = json['no_of_hiring'];
    _city = json['city'];
    _deadline = json['deadline'];
    _jobStatus = json['job_status'];
    _jobType = json['job_type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _employerId;
  String? _jobCategorySlug;
  String? _companyName;
  String? _jobTitle;
  String? _fullName;
  String? _description;
  String? _jobsEmail;
  String? _phone;
  String? _salary;
  dynamic _role;
  String? _companyLogo;
  String? _country;
  String? _noOfHiring;
  String? _city;
  String? _deadline;
  String? _jobStatus;
  String? _jobType;
  String? _createdAt;
  String? _updatedAt;
Data copyWith({  num? id,
  num? employerId,
  String? jobCategorySlug,
  String? companyName,
  String? jobTitle,
  String? fullName,
  String? description,
  String? jobsEmail,
  String? phone,
  String? salary,
  dynamic role,
  String? companyLogo,
  String? country,
  String? noOfHiring,
  String? city,
  String? deadline,
  String? jobStatus,
  String? jobType,
  String? createdAt,
  String? updatedAt,
}) => Data(  id: id ?? _id,
  employerId: employerId ?? _employerId,
  jobCategorySlug: jobCategorySlug ?? _jobCategorySlug,
  companyName: companyName ?? _companyName,
  jobTitle: jobTitle ?? _jobTitle,
  fullName: fullName ?? _fullName,
  description: description ?? _description,
  jobsEmail: jobsEmail ?? _jobsEmail,
  phone: phone ?? _phone,
  salary: salary ?? _salary,
  role: role ?? _role,
  companyLogo: companyLogo ?? _companyLogo,
  country: country ?? _country,
  noOfHiring: noOfHiring ?? _noOfHiring,
  city: city ?? _city,
  deadline: deadline ?? _deadline,
  jobStatus: jobStatus ?? _jobStatus,
  jobType: jobType ?? _jobType,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get employerId => _employerId;
  String? get jobCategorySlug => _jobCategorySlug;
  String? get companyName => _companyName;
  String? get jobTitle => _jobTitle;
  String? get fullName => _fullName;
  String? get description => _description;
  String? get jobsEmail => _jobsEmail;
  String? get phone => _phone;
  String? get salary => _salary;
  dynamic get role => _role;
  String? get companyLogo => _companyLogo;
  String? get country => _country;
  String? get noOfHiring => _noOfHiring;
  String? get city => _city;
  String? get deadline => _deadline;
  String? get jobStatus => _jobStatus;
  String? get jobType => _jobType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['employer_id'] = _employerId;
    map['job_category_slug'] = _jobCategorySlug;
    map['company_name'] = _companyName;
    map['job_title'] = _jobTitle;
    map['full_name'] = _fullName;
    map['description'] = _description;
    map['jobs_email'] = _jobsEmail;
    map['phone'] = _phone;
    map['salary'] = _salary;
    map['role'] = _role;
    map['company_logo'] = _companyLogo;
    map['country'] = _country;
    map['no_of_hiring'] = _noOfHiring;
    map['city'] = _city;
    map['deadline'] = _deadline;
    map['job_status'] = _jobStatus;
    map['job_type'] = _jobType;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}