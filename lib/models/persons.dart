class Person {
  final int id;
  final String full_name;
  final String name_th;
  final String email;
  final String website;
  final String authorUrl;
  final String office;
  final String province;
  final String country;
  final String pic_name;

  Person({required this.id ,required this.full_name, required this.name_th
    ,  required this.email
    ,  required this.website
    ,  required this.authorUrl
    ,  required this.office
    ,  required this.province
    ,  required this.country
    ,  required this.pic_name
    });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['n']['id'] ?? 'ไม่มีข้อมูล' ,
      full_name: json['n']['full_name'] ?? 'ไม่มีข้อมูล' ,
      name_th: json['n']['name_th'] ?? 'ไม่พบชื่อภาษาไทย' ,
      email: json['n']['email'] ?? 'ไม่มีข้อมูล' ,
      website: json['n']['website'] ?? 'ไม่มีข้อมูล' ,
      authorUrl: json['n']['authorUrl'] ?? 'ไม่มีข้อมูล',
      office: json['n']['office'] ?? 'ไม่มีข้อมูล',
      province: json['n']['province'] ?? 'ไม่มีข้อมูล',
      country: json['n']['country'] ?? 'ไม่มีข้อมูล',
      pic_name: json['n']['pic_name'] ?? 'ไม่มีข้อมูล',
      );
  }
}