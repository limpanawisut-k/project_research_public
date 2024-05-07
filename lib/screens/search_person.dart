import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:final_project_research/models/expertise.dart';
import 'package:final_project_research/screens/home_page.dart';
import 'package:final_project_research/screens/result_search_p.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'constant.dart';

class MySearchPage extends StatefulWidget {
  @override
  SearchPerson createState() => SearchPerson();
}

class SearchPerson extends State<MySearchPage> {
  Future<List<String>> fetchAllExpertise() async {
    final response = await Dio().get('${Constants.apiUrl}/all_expertise');
    debugPrint(response.data.toString());

    if (response.statusCode == 200 ) {
      List<dynamic> data = response.data;
      List<String> expertiseNames = data.map((item) => Expertise.fromJson(item).expertise_name).toList();
      return expertiseNames;
    } else {
      throw Exception('Failed to load data');
    }
  }

  TextEditingController _searchController = TextEditingController();
  String? officevalue = '---เลือกหน่วยงานหรือสังกัด---';
  List officeitems = [
    '---เลือกหน่วยงานหรือสังกัด---',
    'มหาวิทยาลัยศิลปากร',
  ];
  String? expertisevalue = '---เลือกสาขาความเชี่ยวชาญ---';
  List expertiseitems = [
    '---เลือกสาขาความเชี่ยวชาญ---',

  ];


  @override
  void initState() {
    super.initState();
    fetchAllExpertise().then((expertiseList) {
      setState(() {
        expertiseitems.addAll(expertiseList);
      });
    }).catchError((error) {
      print('Error fetching expertise: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('ค้นหานักวิจัย',style: GoogleFonts.getFont('Prompt', fontSize: 20, color: Colors.white)),
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
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/pictures/bg_app.jpg'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter),
            ),
          ),
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('ชื่อ - นามสกุล',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'รองรับทั้งภาษาไทยและภาษาอังกฤษ',
                      filled: true,
                      fillColor: Colors.white, // สีพื้นหลัง
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                        color: Colors.black, // สีขอบเมื่อไม่ได้รับภายนอก
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo, // สีขอบเมื่อได้รับภายนอก
                        ),
                      ),
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 16, 8),
                  child: Text('* ไม่รองรับตัวอักษรพิเศษ',style: GoogleFonts.getFont('Prompt', fontSize: 14, color: Colors.red,),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('สาขาที่เชี่ยวชาญ',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1),
                        color: Colors.white,
                    ),
                    child: DropdownButton(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      underline: SizedBox(),
                      isExpanded: true,
                      value: expertisevalue,
                      items: expertiseitems.map((item) => DropdownMenuItem(value: item ,child: Text(item))).toList(),
                      onChanged: (value) => setState(() => expertisevalue = value.toString()),
                      style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('หน่วยงานหรือสังกัด',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1),
                        color: Colors.white,
                    ),
                    child: DropdownButton(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      underline: SizedBox(),
                      isExpanded: true,
                      value: officevalue,
                      items: officeitems.map((item) => DropdownMenuItem(value: item ,child: Text(item))).toList(),
                      onChanged: (value) => setState(() => officevalue = value.toString()),
                      style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.indigo,
                            fixedSize: Size(150, 50)
                        ),
                        onPressed: () {
                          String searchText = _searchController.text;
                          String? officeValue = officevalue;
                          String? expertiseValue = expertisevalue;

                          // เช็คว่าชื่อ-นามสกุลมีตัวอักษรพิเศษหรือไม่
                          if (_searchController.text.contains(RegExp(r'[!@#$%^&*(),?":{}|<>]'))) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('ข้อผิดพลาด',style: GoogleFonts.getFont('Prompt', fontSize: 20, color: Colors.red)),
                                  content: Container(
                                    height: 60,
                                      child: Text('ชื่อและนามสกุลไม่ควรมีอักษรพิเศษ',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black))
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.indigo,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('ตกลง',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // ให้ทำการค้นหา
                            debugPrint('Searching for: $searchText');
                            debugPrint('Searching for: $officeValue');
                            debugPrint('Searching for: $expertiseValue');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultSearchP(),
                                settings: RouteSettings(
                                  arguments: json.encode({
                                    'searchText': searchText,
                                    'officeValue': officeValue,
                                    'expertiseValue': expertiseValue,
                                  }),
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'ค้นหา',
                          style: GoogleFonts.getFont('Prompt', fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
