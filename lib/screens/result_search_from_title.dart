import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:final_project_research/models/persons.dart';
import 'package:final_project_research/models/todo_item.dart';
import 'package:final_project_research/screens/detail_person.dart';
import 'package:final_project_research/screens/home_page.dart';
import 'package:final_project_research/screens/search_person.dart';
import 'package:final_project_research/screens/search_research.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultSearchTitle extends StatefulWidget {
  const ResultSearchTitle({Key? key}) : super(key: key);

  @override
  State<ResultSearchTitle> createState() => _ResultSearchTitle();
}

class _ResultSearchTitle extends State<ResultSearchTitle> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  Map<String, dynamic>? list;

  Future<List<Person>> fetchData(String search) async {
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

  @override
  Widget build(BuildContext context) {
    final String dataForSearchPerson = ModalRoute.of(context)!.settings.arguments as String;
    final Map<String, dynamic> arguments = json.decode(dataForSearchPerson) as Map<String, dynamic>;
    String searchFromTitle = arguments['searchFromTitle'];


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('นักวิจัยที่เกี่ยวข้อง', style: GoogleFonts.getFont('Prompt', fontSize: 20, color: Colors.white)),
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
      body: Stack(
        children: [
          FutureBuilder<List<Person>>(
            future: fetchData(searchFromTitle),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Align(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
              } else if (snapshot.hasError) {
                return Text('ไม่พบข้อมูล: ${snapshot.error}');
              } else {
                List<Person> person = snapshot.data!;
                var picName = null;
                return ListView.builder(
                  itemCount: person.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Color.fromRGBO(240, 240, 240, 1),
                        shape: RoundedRectangleBorder(
                          /*side: BorderSide(width: 0),*/
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Row(
                          children: [
                            Column(
                              children: [
                                if (person[index].pic_name == "ไม่มีข้อมูล")
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: AssetImage('assets/pictures/person_icon.png'),
                                  )
                                else
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(person[index].pic_name),
                                  ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    person[index].full_name,
                                    style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.indigo),
                                  ),
                                  if(person[index].name_th != 'ไม่พบชื่อภาษาไทย')
                                    Text(
                                      person[index].name_th,
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
                                      if(person[index].office != '-')
                                        Text(
                                          person[index].office,
                                          style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                        )
                                      else
                                        Text(
                                          "หน่วยงาน: - ",
                                          style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                        )
                                      ,
                                      if(person[index].province != '-')
                                        Text(
                                          " ${person[index].province}",
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
                                ],
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPerson(person: person[index])));
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
