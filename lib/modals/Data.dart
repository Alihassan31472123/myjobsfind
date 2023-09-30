class Data {
  Data({
      this.id, 
      this.employerId, 
      this.jobCategorySlug, 
      this.companyName, 
      this.jobTitle, 
      this.fullName, 
      this.description, 
      this.jobsEmail, 
      this.phone, 
      this.salary, 
      this.role, 
      this.companyLogo, 
      this.country, 
      this.noOfHiring, 
      this.city, 
      this.deadline, 
      this.jobStatus, 
      this.jobType, 
      this.createdAt, 
      this.updatedAt,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    employerId = json['employer_id'];
    jobCategorySlug = json['job_category_slug'];
    companyName = json['company_name'];
    jobTitle = json['job_title'];
    fullName = json['full_name'];
    description = json['description'];
    jobsEmail = json['jobs_email'];
    phone = json['phone'];
    salary = json['salary'];
    role = json['role'];
    companyLogo = json['company_logo'];
    country = json['country'];
    noOfHiring = json['no_of_hiring'];
    city = json['city'];
    deadline = json['deadline'];
    jobStatus = json['job_status'];
    jobType = json['job_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int id;
  int employerId;
  String jobCategorySlug;
  String companyName;
  String jobTitle;
  String fullName;
  String description;
  String jobsEmail;
  String phone;
  String salary;
  dynamic role;
  String companyLogo;
  String country;
  String noOfHiring;
  String city;
  String deadline;
  String jobStatus;
  String jobType;
  String createdAt;
  String updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['employer_id'] = employerId;
    map['job_category_slug'] = jobCategorySlug;
    map['company_name'] = companyName;
    map['job_title'] = jobTitle;
    map['full_name'] = fullName;
    map['description'] = description;
    map['jobs_email'] = jobsEmail;
    map['phone'] = phone;
    map['salary'] = salary;
    map['role'] = role;
    map['company_logo'] = companyLogo;
    map['country'] = country;
    map['no_of_hiring'] = noOfHiring;
    map['city'] = city;
    map['deadline'] = deadline;
    map['job_status'] = jobStatus;
    map['job_type'] = jobType;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}