import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:final_project_research/models/expertise.dart';
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
  String? item = 'มหาวิทยาลัยศิลปากร';
  List items = [
    'มหาวิทยาลัยศิลปากร',
    'Data Mining',
    'Machine Learning',
    'Distributed Database',
    'Data Warehouse',
    'Decision Support System',
    'Knowledge Engineering',
    'Computer Networks',
    'Distributed Systems',
    'Ubiquitous and Mobile Computing',
    'Image Processing',
    'Computer Vision',
    'Augmented/Virtual Reality',
    'Human Computer Interaction',
    'Game Design and Development',
    'Ubiquitous Computing',
    'Software Engineering',
    'Robotics',
    'Wireless Communication',
    'Evolutionary Algorithms',
    'Metaheuristics',
    'Optimization',
    'Artificial Intelligence',
    'Natural Language Processing',
    'Deep Learning',
    'DevOps',
    'Network Security',
    'Case-Base Reasoning for Design Patterns Retrieval',
    'Case-Base Reasoning',
    'Information Retrieval',
    'Computer Network Architectures',
    'Algorithms and Protocols',
    'Database Application and Design',
    'Data Warehouse and Application',
    'Enterprise Application Programing and Design',
    'System Analysis and Design',
    'Knowledge and Information Engineering',
    'KM',
    'Visualization',
    'Pattern Recognition',
    'Cognitive',
    'Emotional Analysis and Behaviour',
    'Data Analysis',
    'Computer Aided Diagnosis',
    'Multimedia Retrieval',
    'Web/Internet Technology',
    'Web Programming / Technology',
    'Business Intelligence',
    'Multimedia Content Analysis',
    'Data Analytics',
    'Speech Processing',
    'Digital System Design',
    'Memory Architecture',
    'Embedded System',
    'Microarchitecture Design Techniques',
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

                      filled: true,
                      fillColor: Colors.grey[200], // สีพื้นหลัง
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
                  child: Text('test',style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),
                    decoration: InputDecoration(

                      filled: true,
                      fillColor: Colors.grey[200], // สีพื้นหลัง
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
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black,),

                    decoration: InputDecoration(

                      filled: true,
                      fillColor: Colors.grey[200], // สีพื้นหลัง
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
                SizedBox(height: 16.0),
                DropdownButton(
                  value: item,
                  items: items.map((item) => DropdownMenuItem(value: item ,child: Text(item))).toList(),
                  onChanged: (value) => setState(() => item = value.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.indigo),
                        onPressed: () {
                          // Perform search based on _searchController.text
                          String searchText = _searchController.text;
                          String? selectedValue = item;
                          // Add your search logic here
                          // For now, print the search text
                          debugPrint('Searching for: $searchText');
                          debugPrint('Searching for: $selectedValue');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ResultSearchR(),
                              settings: RouteSettings(arguments: json.encode({'searchText': searchText})),
                            ),
                          );
                        },
                        child: Text('ค้นหา',style: TextStyle(color: Colors.white),),
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
