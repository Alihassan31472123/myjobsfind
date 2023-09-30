import 'dart:convert';
/// success : true
/// message : "countries"
/// data : [{"id":1,"name":"Afghanistan"},{"id":2,"name":"Åland Islands"},{"id":3,"name":"Albania"},{"id":4,"name":"Algeria"},{"id":5,"name":"American Samoa"},{"id":6,"name":"Andorra"},{"id":7,"name":"Angola"},{"id":8,"name":"Anguilla"},{"id":9,"name":"Antarctica"},{"id":10,"name":"Antigua & Barbuda"},{"id":11,"name":"Argentina"},{"id":12,"name":"Armenia"},{"id":13,"name":"Aruba"},{"id":14,"name":"Australia"},{"id":15,"name":"Austria"},{"id":16,"name":"Azerbaijan"},{"id":17,"name":"Bahrain"},{"id":18,"name":"Bangladesh"},{"id":19,"name":"Barbados"},{"id":20,"name":"Belarus"},{"id":21,"name":"Belgium"},{"id":22,"name":"Belize"},{"id":23,"name":"Benin"},{"id":24,"name":"Bermuda"},{"id":25,"name":"Bhutan"},{"id":26,"name":"Bolivia"},{"id":27,"name":"Caribbean Netherlands"},{"id":28,"name":"Bosnia & Herzegovina"},{"id":29,"name":"Botswana"},{"id":30,"name":"Bouvet Island"},{"id":31,"name":"Brazil"},{"id":32,"name":"British Indian Ocean Territory"},{"id":33,"name":"Brunei"},{"id":34,"name":"Bulgaria"},{"id":35,"name":"Burkina Faso"},{"id":36,"name":"Burundi"},{"id":37,"name":"Cambodia"},{"id":38,"name":"Cameroon"},{"id":39,"name":"Canada"},{"id":40,"name":"Cape Verde"},{"id":41,"name":"Cayman Islands"},{"id":42,"name":"Central African Republic"},{"id":43,"name":"Chad"},{"id":44,"name":"Chile"},{"id":45,"name":"China"},{"id":46,"name":"Christmas Island"},{"id":47,"name":"Cocos (Keeling) Islands"},{"id":48,"name":"Colombia"},{"id":49,"name":"Comoros"},{"id":50,"name":"Congo - Brazzaville"},{"id":51,"name":"Cook Islands"},{"id":52,"name":"Costa Rica"},{"id":53,"name":"Côte d’Ivoire"},{"id":54,"name":"Croatia"},{"id":55,"name":"Cuba"},{"id":56,"name":"Curaçao"},{"id":57,"name":"Cyprus"},{"id":58,"name":"Czechia"},{"id":59,"name":"Congo - Kinshasa"},{"id":60,"name":"Denmark"},{"id":61,"name":"Djibouti"},{"id":62,"name":"Dominica"},{"id":63,"name":"Dominican Republic"},{"id":64,"name":"Timor-Leste"},{"id":65,"name":"Ecuador"},{"id":66,"name":"Egypt"},{"id":67,"name":"El Salvador"},{"id":68,"name":"Equatorial Guinea"},{"id":69,"name":"Eritrea"},{"id":70,"name":"Estonia"},{"id":71,"name":"Ethiopia"},{"id":72,"name":"Falkland Islands"},{"id":73,"name":"Faroe Islands"},{"id":74,"name":"Fiji"},{"id":75,"name":"Finland"},{"id":76,"name":"France"},{"id":77,"name":"French Guiana"},{"id":78,"name":"French Polynesia"},{"id":79,"name":"French Southern Territories"},{"id":80,"name":"Gabon"},{"id":81,"name":"Gambia"},{"id":82,"name":"Georgia"},{"id":83,"name":"Germany"},{"id":84,"name":"Ghana"},{"id":85,"name":"Gibraltar"},{"id":86,"name":"Greece"},{"id":87,"name":"Greenland"},{"id":88,"name":"Grenada"},{"id":89,"name":"Guadeloupe"},{"id":90,"name":"Guam"},{"id":91,"name":"Guatemala"},{"id":92,"name":"Guernsey"},{"id":93,"name":"Guinea"},{"id":94,"name":"Guinea-Bissau"},{"id":95,"name":"Guyana"},{"id":96,"name":"Haiti"},{"id":97,"name":"Heard & McDonald Islands"},{"id":98,"name":"Honduras"},{"id":99,"name":"Hong Kong SAR China"},{"id":100,"name":"Hungary"},{"id":101,"name":"Iceland"},{"id":102,"name":"India"},{"id":103,"name":"Indonesia"},{"id":104,"name":"Iran"},{"id":105,"name":"Iraq"},{"id":106,"name":"Ireland"},{"id":107,"name":"Israel"},{"id":108,"name":"Italy"},{"id":109,"name":"Jamaica"},{"id":110,"name":"Japan"},{"id":111,"name":"Jersey"},{"id":112,"name":"Jordan"},{"id":113,"name":"Kazakhstan"},{"id":114,"name":"Kenya"},{"id":115,"name":"Kiribati"},{"id":116,"name":"Kosovo"},{"id":117,"name":"Kuwait"},{"id":118,"name":"Kyrgyzstan"},{"id":119,"name":"Laos"},{"id":120,"name":"Latvia"},{"id":121,"name":"Lebanon"},{"id":122,"name":"Lesotho"},{"id":123,"name":"Liberia"},{"id":124,"name":"Libya"},{"id":125,"name":"Liechtenstein"},{"id":126,"name":"Lithuania"},{"id":127,"name":"Luxembourg"},{"id":128,"name":"Macao SAR China"},{"id":129,"name":"North Macedonia"},{"id":130,"name":"Madagascar"},{"id":131,"name":"Malawi"},{"id":132,"name":"Malaysia"},{"id":133,"name":"Maldives"},{"id":134,"name":"Mali"},{"id":135,"name":"Malta"},{"id":136,"name":"Isle of Man"},{"id":137,"name":"Marshall Islands"},{"id":138,"name":"Martinique"},{"id":139,"name":"Mauritania"},{"id":140,"name":"Mauritius"},{"id":141,"name":"Mayotte"},{"id":142,"name":"Mexico"},{"id":143,"name":"Micronesia"},{"id":144,"name":"Moldova"},{"id":145,"name":"Monaco"},{"id":146,"name":"Mongolia"},{"id":147,"name":"Montenegro"},{"id":148,"name":"Montserrat"},{"id":149,"name":"Morocco"},{"id":150,"name":"Mozambique"},{"id":151,"name":"Myanmar (Burma)"},{"id":152,"name":"Namibia"},{"id":153,"name":"Nauru"},{"id":154,"name":"Nepal"},{"id":155,"name":"Netherlands"},{"id":156,"name":"New Caledonia"},{"id":157,"name":"New Zealand"},{"id":158,"name":"Nicaragua"},{"id":159,"name":"Niger"},{"id":160,"name":"Nigeria"},{"id":161,"name":"Niue"},{"id":162,"name":"Norfolk Island"},{"id":163,"name":"North Korea"},{"id":164,"name":"Northern Mariana Islands"},{"id":165,"name":"Norway"},{"id":166,"name":"Oman"},{"id":167,"name":"Pakistan"},{"id":168,"name":"Palau"},{"id":169,"name":"Palestinian Territories"},{"id":170,"name":"Panama"},{"id":171,"name":"Papua New Guinea"},{"id":172,"name":"Paraguay"},{"id":173,"name":"Peru"},{"id":174,"name":"Philippines"},{"id":175,"name":"Pitcairn Islands"},{"id":176,"name":"Poland"},{"id":177,"name":"Portugal"},{"id":178,"name":"Puerto Rico"},{"id":179,"name":"Qatar"},{"id":180,"name":"Réunion"},{"id":181,"name":"Romania"},{"id":182,"name":"Russia"},{"id":183,"name":"Rwanda"},{"id":184,"name":"St. Helena"},{"id":185,"name":"St. Kitts & Nevis"},{"id":186,"name":"St. Lucia"},{"id":187,"name":"St. Pierre & Miquelon"},{"id":188,"name":"St. Vincent & Grenadines"},{"id":189,"name":"St. Barthélemy"},{"id":190,"name":"St. Martin"},{"id":191,"name":"Samoa"},{"id":192,"name":"San Marino"},{"id":193,"name":"São Tomé & Príncipe"},{"id":194,"name":"Saudi Arabia"},{"id":195,"name":"Senegal"},{"id":196,"name":"Serbia"},{"id":197,"name":"Seychelles"},{"id":198,"name":"Sierra Leone"},{"id":199,"name":"Singapore"},{"id":200,"name":"Sint Maarten"},{"id":201,"name":"Slovakia"},{"id":202,"name":"Slovenia"},{"id":203,"name":"Solomon Islands"},{"id":204,"name":"Somalia"},{"id":205,"name":"South Africa"},{"id":206,"name":"South Georgia & South Sandwich Islands"},{"id":207,"name":"South Korea"},{"id":208,"name":"South Sudan"},{"id":209,"name":"Spain"},{"id":210,"name":"Sri Lanka"},{"id":211,"name":"Sudan"},{"id":212,"name":"Suriname"},{"id":213,"name":"Svalbard & Jan Mayen"},{"id":214,"name":"Eswatini"},{"id":215,"name":"Sweden"},{"id":216,"name":"Switzerland"},{"id":217,"name":"Syria"},{"id":218,"name":"Taiwan"},{"id":219,"name":"Tajikistan"},{"id":220,"name":"Tanzania"},{"id":221,"name":"Thailand"},{"id":222,"name":"Bahamas"},{"id":223,"name":"Togo"},{"id":224,"name":"Tokelau"},{"id":225,"name":"Tonga"},{"id":226,"name":"Trinidad & Tobago"},{"id":227,"name":"Tunisia"},{"id":228,"name":"Turkey"},{"id":229,"name":"Turkmenistan"},{"id":230,"name":"Turks & Caicos Islands"},{"id":231,"name":"Tuvalu"},{"id":232,"name":"Uganda"},{"id":233,"name":"Ukraine"},{"id":234,"name":"United Arab Emirates"},{"id":235,"name":"United Kingdom"},{"id":236,"name":"United States"},{"id":237,"name":"U.S. Outlying Islands"},{"id":238,"name":"Uruguay"},{"id":239,"name":"Uzbekistan"},{"id":240,"name":"Vanuatu"},{"id":241,"name":"Vatican City"},{"id":242,"name":"Venezuela"},{"id":243,"name":"Vietnam"},{"id":244,"name":"British Virgin Islands"},{"id":245,"name":"U.S. Virgin Islands"},{"id":246,"name":"Wallis & Futuna"},{"id":247,"name":"Western Sahara"},{"id":248,"name":"Yemen"},{"id":249,"name":"Zambia"},{"id":250,"name":"Zimbabwe"}]
/// response_time : "20 ms"

CountryModal countryModalFromJson(String str) => CountryModal.fromJson(json.decode(str));
String countryModalToJson(CountryModal data) => json.encode(data.toJson());
class CountryModal {
  CountryModal({
      bool? success, 
      String? message, 
      List<Data>? data, 
      String? responseTime,}){
    _success = success;
    _message = message;
    _data = data;
    _responseTime = responseTime;
}

  CountryModal.fromJson(dynamic json) {
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
CountryModal copyWith({  bool? success,
  String? message,
  List<Data>? data,
  String? responseTime,
}) => CountryModal(  success: success ?? _success,
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

/// id : 1
/// name : "Afghanistan"

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