import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:final_project_research/models/persons.dart';
import 'package:final_project_research/models/research.dart';
import 'package:final_project_research/screens/detail_person.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RelationAuthor extends StatefulWidget {
  const RelationAuthor({Key? key}) : super(key: key);

  @override
  State<RelationAuthor> createState() => _RelationAuthorState();
}

class _RelationAuthorState extends State<RelationAuthor> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  Map<String, dynamic>? list;

  Future<List<Research>> fetchData(String search, String searchfromperson, String type, String publisher, String year) async {
    final response = await Dio().get('http://10.0.2.2:8000/search/research',
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
    final response = await Dio().get('http://10.0.2.2:8000/search_person_from_title',
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
    final response = await Dio().get('http://10.0.2.2:8000/find_articles_relation',
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
        title: Text('ผลการค้นหา', style: GoogleFonts.getFont('Prompt', fontSize: 20, color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                          if (person.full_name != nameAuthor) {
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
                                      ListTile(
                                        title: Text(
                                          person.full_name,
                                          style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.indigo),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPerson(person: person)));
                                        },
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: articles.map((article) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Text(
                                              article.title,
                                              style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      Divider(), // Add a divider between each person's articles
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
