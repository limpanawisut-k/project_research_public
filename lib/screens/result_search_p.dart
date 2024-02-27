import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:final_project_research/models/persons.dart';
import 'package:final_project_research/models/todo_item.dart';
import 'package:final_project_research/screens/detail_person.dart';
import 'package:final_project_research/screens/search_person.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';


class ResultSearchP extends StatefulWidget {

  const ResultSearchP({super.key});


  @override
  State<ResultSearchP> createState() => _ResultSearchP();
}

class _ResultSearchP extends State<ResultSearchP> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  Map<String, dynamic>? list;

  Future<List<Person>> fetchData(String search , String office) async {
    final response = await Dio().get('http://10.0.2.2:8000/search/filter',
      queryParameters: {'search': search,'office': office},);
    debugPrint(response.data.toString());

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((item) => Person.fromJson(item)).toList();
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
    String selectedValue = arguments['selectedValue'];

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
          FutureBuilder<List<Person>>(
            future: fetchData(searchText,selectedValue),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Align(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Person> person = snapshot.data!;
                var picName = null;
                return ListView.builder(
                  itemCount: person.length,
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
                            Column(
                              children: [
                                if (person[index].pic_name == "ไม่มีข้อมูล")
                                  CircleAvatar(
                                    radius: 40, // ขนาดของวงกลม
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white, // สีไอคอน
                                      size: 40, // ขนาดไอคอน
                                    ),
                                  )
                                else
                                  CircleAvatar(
                                    radius: 40, // ขนาดของวงกลม
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
                                  Text(
                                    person[index].name_th,
                                    style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                  ),
                                  Text(
                                    "${person[index].office} ${person[index].province}",
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