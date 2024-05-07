import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:final_project_research/models/persons.dart';
import 'package:final_project_research/models/research.dart';
import 'package:final_project_research/screens/detail_person.dart';
import 'package:final_project_research/screens/detail_research.dart';
import 'package:final_project_research/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant.dart';

class RelationAuthor extends StatefulWidget {
  const RelationAuthor({Key? key}) : super(key: key);

  @override
  State<RelationAuthor> createState() => _RelationAuthorState();
}

class _RelationAuthorState extends State<RelationAuthor> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  Map<String, dynamic>? list;

  Future<List<Research>> fetchData(String search, String searchfromperson, String type, String publisher, String year) async {
    final response = await Dio().get('${Constants.apiUrl}/search/research',
      queryParameters: {'search': search, 'searchfromperson': searchfromperson, 'type': type, 'publisher': publisher, 'year': year},);
    debugPrint(response.data.toString());

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((item) => Research.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Person>> fetchDataRelation(String search) async {
    final response = await Dio().get('${Constants.apiUrl}/search_person_from_title',
        queryParameters: {'searchFromTitle': search});
    debugPrint(response.data.toString());

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((item) => Person.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Research>> fetchDataArticleRelation(String author1, String author2) async {
    final response = await Dio().get('${Constants.apiUrl}/find_articles_relation',
      queryParameters: {'Author1': author1, 'Author2': author2},);
    debugPrint(response.data.toString());

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((item) => Research.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<String> uniqueNames = Set<String>();
    final String dataForSearchPerson = ModalRoute.of(context)!.settings.arguments as String;
    final Map<String, dynamic> arguments = json.decode(dataForSearchPerson) as Map<String, dynamic>;
    String searchText = arguments['searchText'];
    String searchFromPerson = arguments['searchFromPerson'];
    String typeValue = arguments['typeValue'];
    String publisherValue = arguments['publisherValue'];
    String yearValue = arguments['yearValue'];
    String nameAuthor = arguments['nameAuthor'];

    debugPrint('Personfrom: $searchFromPerson');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('บุคคลที่มีความสัมพันธ์ร่วม', style: GoogleFonts.getFont('Prompt', fontSize: 20, color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
                settings: RouteSettings(),
              ),
            );
          }, icon: Icon(Icons.home,color: Colors.white,size: 40,))
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<List<Research>>(
        future: fetchData(searchText, searchFromPerson, typeValue, publisherValue, yearValue),
        builder: (context, researchSnapshot) {
          if (researchSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (researchSnapshot.hasError) {
            return Center(child: Text('Error: ${researchSnapshot.error}'));
          } else {
            List<Research> research = researchSnapshot.data!;
            return ListView.builder(
              itemCount: research.length,
              itemBuilder: (context, index) {
                return FutureBuilder<List<Person>>(
                  future: fetchDataRelation(research[index].title),
                  builder: (context, personSnapshot) {
                    if (personSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (personSnapshot.hasError) {
                      return Center(child: Text('Error: ${personSnapshot.error}'));
                    } else {
                      List<Person> persons = personSnapshot.data!;
                      return Column(
                        children: persons.map((person) {
                          if (!uniqueNames.contains(person.full_name) && person.full_name != nameAuthor) {
                            uniqueNames.add(person.full_name);
                            return FutureBuilder<List<Research>>(
                              future: fetchDataArticleRelation(nameAuthor, person.full_name),
                              builder: (context, articleSnapshot) {
                                if (articleSnapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (articleSnapshot.hasError) {
                                  return Text('Error: ${articleSnapshot.error}');
                                } else {
                                  List<Research> articles = articleSnapshot.data!;
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          tileColor: Color.fromRGBO(240, 240, 240, 1),
                                          shape: RoundedRectangleBorder(
                                            /*side: BorderSide(width: 1),*/
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          title: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  if (person.pic_name == "ไม่มีข้อมูล")
                                                    CircleAvatar(
                                                      radius: 40,
                                                      backgroundImage: AssetImage('assets/pictures/person_icon.png'),
                                                    )
                                                  else
                                                    CircleAvatar(
                                                      radius: 40,
                                                      backgroundImage: NetworkImage(person.pic_name),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(width: 10,),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      person.full_name,
                                                      style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.indigo),
                                                    ),
                                                    if(person.name_th != 'ไม่พบชื่อภาษาไทย')
                                                      Text(
                                                        person.name_th,
                                                        style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                                      )
                                                    else
                                                      Text(
                                                        "ชื่อ: - ",
                                                        style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                                      )
                                                    ,
                                                    Row(
                                                      children: [
                                                        if(person.office != '-')
                                                          Text(
                                                            person.office,
                                                            style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                                          )
                                                        else
                                                          Text(
                                                            "หน่วยงาน: - ",
                                                            style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                                          )
                                                        ,
                                                        if(person.province != '-')
                                                          Text(
                                                            " ${person.province}",
                                                            style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                                          )
                                                        else
                                                          Text(
                                                            "จังหวัด: - ",
                                                            style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                                          )
                                                        ,
                                                      ],
                                                    ),
                                                  ]
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.search,
                                                    size: 30.0,
                                                    color: Colors.black,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPerson(person: person)));
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'งานวิจัยที่ทำร่วมกัน',
                                              style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: articles.map((article) {
                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(32, 0, 8, 8),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailResearch(research: article)));
                                                    },
                                                    child: Text(
                                                      article.title,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.indigo,),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailResearch(research: article)));
                                                  },
                                                  child: Icon(
                                                      Icons.arrow_forward),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                      Divider(
                                        color: Colors.grey, // สีของเส้น
                                        thickness: 1, // ความหนาของเส้น
                                        indent: 0, // ระยะห่างด้านซ้ายของเส้น
                                        endIndent: 4, // ระยะห่างด้านขวาของเส้น
                                      ), // Add a divider between each person's articles
                                    ],
                                  );
                                }
                              },
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }).toList(),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
