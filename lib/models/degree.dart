class Degree {
  final String degree_name;
  Degree({required this.degree_name});

  factory Degree.fromJson(Map<String, dynamic> json) {
    return Degree(
      degree_name: json['degree']['degree_name'] ?? 'ไม่มีข้อมูล' ,
    );
  }
}