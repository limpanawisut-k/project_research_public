import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:final_project_research/models/expertise.dart';
import 'package:final_project_research/screens/result_search_p.dart';
import 'package:final_project_research/screens/result_search_r.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchResearchPage extends StatefulWidget {
  @override
  SearchResearch createState() => SearchResearch();
}

class SearchResearch extends State<SearchResearchPage> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchFromPerson = TextEditingController();
  String? typevalue = '---เลือกประเภทงานวิจัย---';
  List typeitems = [
    '---เลือกประเภทงานวิจัย---',
    'Conferences',
    'Journals',
  ];
  String? publishervalue = '---เลือกแหล่งที่เผยแพร่---';
  List publisheritems = [
    '---เลือกแหล่งที่เผยแพร่---',
    'IEEE',
  ];
  String? yearvalue = '---เลือกปีที่จัดทำ---';
  List yearitems = [
    '---เลือกปีที่จัดทำ---',
    '2024', '2023', '2022', '2021', '2020', '2019', '2018', '2017', '2016', '2015',
    '2014', '2013', '2012', '2011', '2010', '2009', '2008', '2007', '2006', '2005',
    '2004', '2003', '2002', '2001'

  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('ค้นหางานวิจัย',style: GoogleFonts.getFont('Prompt', fontSize: 20, color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                  child: Text('ชื่องานวิจัย',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ป้อนชื่องานวิจัย',
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('ชื่อนักวิจัยที่เกี่ยวข้อง',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),
                    controller: _searchFromPerson,
                    decoration: InputDecoration(
                      hintText: 'ป้อนชื่อนักวิจัยที่เกี่ยวข้อง',
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('แหล่งที่เผยแพร่',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),),
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
                      value: publishervalue,
                      items: publisheritems.map((item) => DropdownMenuItem(value: item ,child: Text(item))).toList(),
                      onChanged: (value) => setState(() => publishervalue = value.toString()),
                      style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('ประเภทงานวิจัย',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),),
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
                      value: typevalue,
                      items: typeitems.map((item) => DropdownMenuItem(value: item ,child: Text(item))).toList(),
                      onChanged: (value) => setState(() => typevalue = value.toString()),
                      style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('ปีที่เผยแพร่',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),),
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
                      value: yearvalue,
                      items: yearitems.map((item) => DropdownMenuItem(value: item ,child: Text(item))).toList(),
                      onChanged: (value) => setState(() => yearvalue = value.toString()),
                      style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                          fixedSize: Size(150, 50),
                        ),
                        onPressed: () {
                          String searchText = _searchController.text;
                          String searchFromPerson = _searchFromPerson.text;
                          String? typeValue = typevalue;
                          String? publisherValue = publishervalue;
                          String? yearValue = yearvalue;

                          // เช็คว่าชื่องานวิจัยมีตัวอักษรพิเศษหรือไม่
                          if (searchText.contains(RegExp(r'[!@#$%^&*(),?":{}|<>]'))) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('ข้อผิดพลาด',style: GoogleFonts.getFont('Prompt', fontSize: 20, color: Colors.red)),
                                  content: Container(
                                      height: 60,
                                      child: Text('ชื่องานวิจัยไม่ควรมีอักษรพิเศษ',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black))
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
                            // ทำการค้นหา
                            debugPrint('Searching for: $searchFromPerson');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultSearchR(),
                                settings: RouteSettings(
                                  arguments: json.encode({
                                    'searchText': searchText,
                                    'searchFromPerson': searchFromPerson,
                                    'typeValue': typeValue,
                                    'publisherValue': publisherValue,
                                    'yearValue': yearValue,
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
