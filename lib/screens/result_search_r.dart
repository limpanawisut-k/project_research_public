import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:final_project_research/models/persons.dart';
import 'package:final_project_research/models/research.dart';
import 'package:final_project_research/models/todo_item.dart';
import 'package:final_project_research/screens/detail_person.dart';
import 'package:final_project_research/screens/detail_research.dart';
import 'package:final_project_research/screens/search_person.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';


class ResultSearchR extends StatefulWidget {

  const ResultSearchR({super.key});


  @override
  State<ResultSearchR> createState() => _ResultSearchR();
}

class _ResultSearchR extends State<ResultSearchR> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  Map<String, dynamic>? list;

  Future<List<Research>> fetchData(String search) async {
    final response = await Dio().get('http://10.0.2.2:8000/search/research',
      queryParameters: {'search': search},);
    debugPrint(response.data.toString());

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((item) => Research.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final String dataForSearchPerson = ModalRoute.of(context)!.settings.arguments as String;
    final Map<String, dynamic> arguments = json.decode(dataForSearchPerson) as Map<String, dynamic>;
    String searchText = arguments['searchText'];
    //String selectedValue = arguments['selectedValue'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('ผลการค้นหา',style: GoogleFonts.getFont('Prompt', fontSize: 20, color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          FutureBuilder<List<Research>>(
            future: fetchData(searchText),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Align(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Research> research = snapshot.data!;
                research.sort((a, b) => b.publication_year.compareTo(a.publication_year));
                return ListView.builder(
                  itemCount: research.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    research[index].title,
                                    style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.indigo),
                                  ),
                                  Text(
                                    research[index].publisher,
                                    style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                  ),
                                  Text(
                                    research[index].publication_year,
                                    style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.search, // ใช้ไอคอน search สำหรับแสดงเป็นแว่นขยาย
                                  size: 30.0, // ขนาดของไอคอน
                                  color: Colors.black, // สีของไอคอน
                                )
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailResearch(research: research[index])));
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );

  }

}