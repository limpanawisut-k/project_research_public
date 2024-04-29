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
      full_name: json['n']['full_name'] ?? '-' ,
      name_th: json['n']['name_th'] ?? 'ไม่พบชื่อภาษาไทย' ,
      email: json['n']['email'] ?? '-' ,
      website: json['n']['website'] ?? '-' ,
      authorUrl: json['n']['authorUrl'] ?? '-',
      office: json['n']['office'] ?? '-',
      province: json['n']['province'] ?? '-',
      country: json['n']['country'] ?? '-',
      pic_name: json['n']['pic_name'] ?? 'ไม่มีข้อมูล',
      );
  }
}