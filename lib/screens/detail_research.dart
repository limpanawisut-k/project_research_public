import 'package:dio/dio.dart';
import 'package:final_project_research/models/degree.dart';
import 'package:final_project_research/models/expertise.dart';
import 'package:final_project_research/models/persons.dart';
import 'package:final_project_research/models/research.dart';
import 'package:final_project_research/screens/search_person.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailResearch extends StatefulWidget {
  final Research research;
  const DetailResearch({Key? key, required this.research}) : super(key: key);

  @override
  State<DetailResearch> createState() => _ResultDetail();
}

class _ResultDetail extends State<DetailResearch> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  Future<List<Degree>> fetchDataDegree(String search) async {
    final response = await Dio().get('http://10.0.2.2:8000/search_degree/$search');
    debugPrint(response.data.toString());

    if (response.statusCode == 200 ) {
      List<dynamic> data = response.data;
      return data.map((item) => Degree.fromJson(item)).toList();
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
    Research research = widget.research;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('รายละเอียดของงานวิจัย',style: GoogleFonts.getFont('Prompt', fontSize: 20, color: Colors.white)),
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
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/pictures/bg_app.jpg'),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomCenter),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                          child: Text(
                            research.title,
                            style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                          child: Text(
                            research.publication_title,
                            style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ปี :",
                                style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${research.publication_year}",
                                style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    /*Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Website :",
                                style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${person.website}",
                                style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "IEEE Url :",
                                style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${person.authorUrl}",
                                style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "วุฒิการศึกษา :",
                                style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FutureBuilder<List<Degree>>(
                                future: fetchDataDegree(person.name_th),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Align(
                                      child: CircularProgressIndicator(),
                                      alignment: Alignment.center,
                                    );
                                  } else if (snapshot.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                      child: Text(
                                        "ไม่พบวุฒิการศึกษา",
                                        style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.indigo),
                                      ),
                                    );
                                  } else {
                                    List<Degree> degree = snapshot.data!;
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: degree.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                          child: Text(
                                            degree[index].degree_name,
                                            style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.indigo),
                                          ),
                                        );

                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "สาขาความเชี่ยวชาญ :",
                                style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FutureBuilder<List<Expertise>>(
                                future: fetchData(person.name_th),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Align(
                                      child: CircularProgressIndicator(),
                                      alignment: Alignment.center,
                                    );
                                  } else if (snapshot.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                      child: Text(
                                        "ไม่พบสาขาความเชี่ยวชาญ",
                                        style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.indigo),
                                      ),
                                    );
                                  } else {
                                    List<Expertise> expertise = snapshot.data!;
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: expertise.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                          child: Text(
                                            expertise[index].expertise_name,
                                            style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.indigo),
                                          ),
                                        );

                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )*/


                  ],
                ),
              ),



            ]));
  }
}
