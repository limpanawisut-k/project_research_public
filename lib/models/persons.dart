class Person {
  final int id;
  final String full_name;
  final String name_th;
  final String email;
  final String website;
  final String authorUrl;
  final String pic_name;
  /*final String name_en;
  final String degree_sum;
  final String expertise;
  final String email;
  final String website;*/

  Person({required this.id ,required this.full_name, required this.name_th, required this.authorUrl,  required this.pic_name
    ,  required this.email
    ,  required this.website});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['n']['id'] ?? 'ไม่มีข้อมูล' ,
      full_name: json['n']['full_name'] ?? 'ไม่มีข้อมูล' ,
      name_th: json['n']['name_th'] ?? 'ไม่พบชื่อภาษาไทย' ,
      email: json['n']['email'] ?? 'ไม่มีข้อมูล' ,
      website: json['n']['website'] ?? 'ไม่มีข้อมูล' ,
      authorUrl: json['n']['authorUrl'] ?? 'ไม่มีข้อมูล',
      pic_name: json['n']['pic_name'] ?? 'ไม่มีข้อมูล',
      /*degree_sum: json['n']['degree_sum'] ?? 'ไม่มีข้อมูล',
      expertise: json['n']['expertise'] ?? 'ไม่มีข้อมูล',
      email: json['n']['email'] ?? 'ไม่มีข้อมูล',
      website: json['n']['website'] ?? 'ไม่มีข้อมูล',*/);
  }
}