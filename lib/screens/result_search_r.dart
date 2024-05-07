import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:final_project_research/models/persons.dart';
import 'package:final_project_research/models/research.dart';
import 'package:final_project_research/models/todo_item.dart';
import 'package:final_project_research/screens/detail_person.dart';
import 'package:final_project_research/screens/detail_research.dart';
import 'package:final_project_research/screens/home_page.dart';
import 'package:final_project_research/screens/search_person.dart';
import 'package:final_project_research/screens/search_research.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant.dart';


class ResultSearchR extends StatefulWidget {

  const ResultSearchR({super.key});


  @override
  State<ResultSearchR> createState() => _ResultSearchR();
}

class _ResultSearchR extends State<ResultSearchR> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  String? sortYear = 'ล่าสุด';
  Map<String, dynamic>? list;

  Future<List<Research>> fetchData(String search,String searchfromperson,String type,String publisher,String year) async {
    final response = await Dio().get('${Constants.apiUrl}/search/research',
      queryParameters: {'search': search,'searchfromperson': searchfromperson, 'type': type, 'publisher': publisher, 'year': year},);
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
    String searchFromPerson = arguments['searchFromPerson'];
    String typeValue = arguments['typeValue'];
    String publisherValue = arguments['publisherValue'];
    String yearValue = arguments['yearValue'];

    debugPrint('Personfrom: $searchFromPerson');
    List yearitems = [
      'ล่าสุด',
      'เก่าสุด',
    ];

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
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // สีเฉดเขียว
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'ปี   ',
                    style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                  ),
                  Container(
                    decoration: BoxDecoration(// เส้นขอบสีน้ำเงิน
                      color: Color.fromRGBO(240, 240, 240, 1),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: DropdownButton(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      underline: SizedBox(),
                      value: sortYear,
                      items: yearitems.map((item) => DropdownMenuItem(value: item ,child: Text(item))).toList(),
                      onChanged: (value) {
                        setState(() {
                          sortYear = value.toString();
                        });
                      },
                      style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Research>>(
              future: fetchData(searchText,searchFromPerson,typeValue,publisherValue,yearValue),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Align(
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                } else if (snapshot.hasError) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('assets/pictures/not_found.png'),
                            width: 150, // กำหนดความกว้างของรูปภาพ
                            height: 150, ),
                          Text(
                            "ไม่พบข้อมูล",
                            style: GoogleFonts.getFont('Prompt', fontSize: 24, color: Colors.red),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0,0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo,
                                  fixedSize: Size(180, 50)
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchResearchPage(),
                                    settings: RouteSettings(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text(
                                  'กลับไปยังหน้าค้นหา',
                                  style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.white,),
                                ),
                              ),
                            ),
                          ),
                          /*Text('ไม่พบข้อมูล: ${snapshot.error}'),*/
                        ],
                      ),
                    ],
                  );
                } else {
                  List<Research> research = snapshot.data!;
                  if(sortYear=='ล่าสุด')
                    research.sort((a, b) => b.publication_year.compareTo(a.publication_year));
                  else
                    research.sort((a, b) => a.publication_year.compareTo(b.publication_year));
                  return ListView.builder(
                    itemCount: research.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: Color.fromRGBO(240, 240, 240, 1),
                          shape: RoundedRectangleBorder(
                            /*side: BorderSide(width: 2),*/
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
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
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
                                        SizedBox(width: 20,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              children: [
                                                if (research[index].content_type == "Journals")
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: AssetImage('assets/pictures/journal_icon.png'),
                                                  )
                                                else
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: AssetImage('assets/pictures/conference_icon.png'),
                                                  ),
                                              ],
                                            ),
                                            SizedBox(width: 10,),
                                            Column(
                                              children: [
                                                Text(
                                                  research[index].content_type,
                                                  style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
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
          ),
        ],
      ),
    );

  }

}