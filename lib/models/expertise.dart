class Expertise {
  final String expertise_name;
  Expertise({required this.expertise_name});

  factory Expertise.fromJson(Map<String, dynamic> json) {
    return Expertise(
      expertise_name: json['expertise']['expertise_name'] ?? 'ไม่มีข้อมูล' ,
    );
  }
}