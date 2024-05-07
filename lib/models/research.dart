class Research {
  final String abstract_url;
  final String abstract;
  final String article_number;
  final String content_type;
  final String doi;
  final String end_page;
  final String publication_title;
  final String publication_year;
  final String publisher;
  final String start_page;
  final String title;

  Research({required this.abstract_url ,required this.abstract ,required this.article_number, required this.content_type
    ,  required this.doi
    ,  required this.end_page
    ,  required this.publication_title
    ,  required this.publication_year
    ,  required this.publisher
    ,  required this.start_page
    ,  required this.title
  });

  factory Research.fromJson(Map<String, dynamic> json) {
    return Research(
      abstract_url: json['research']['abstract_url'].toString() ?? 'ไม่มีข้อมูล' ,
      abstract: json['research']['abstract'].toString() ?? 'ไม่มีข้อมูล' ,
      article_number: json['research']['article_number'].toString() ?? 'ไม่มีข้อมูล' ,
      content_type: json['research']['content_type'].toString() ?? 'ไม่มีข้อมูล' ,
      doi: json['research']['doi'].toString() ?? 'ไม่มีข้อมูล' ,
      end_page: json['research']['end_page'].toString() ?? 'ไม่มีข้อมูล' ,
      publication_title: json['research']['publication_title'].toString() ?? 'ไม่มีข้อมูล',
      publication_year: json['research']['publication_year'].toString() ?? 'ไม่มีข้อมูล',
      publisher: json['research']['publisher'].toString() ?? 'ไม่มีข้อมูล',
      start_page: json['research']['start_page'].toString() ?? 'ไม่มีข้อมูล',
      title: json['research']['title'].toString() ?? 'ไม่มีข้อมูล',
    );
  }
}