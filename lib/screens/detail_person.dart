import 'package:dio/dio.dart';
import 'package:final_project_research/models/expertise.dart';
import 'package:final_project_research/models/persons.dart';
import 'package:final_project_research/screens/search_person.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPerson extends StatefulWidget {
  final Person person;
  const DetailPerson({Key? key, required this.person}) : super(key: key);

  @override
  State<DetailPerson> createState() => _ResultExpertise();
}

class _ResultExpertise extends State<DetailPerson> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  Map<String, dynamic>? list;

  Future<List<Expertise>> fetchData(String search) async {
    final response = await Dio().get('http://10.0.2.2:8000/search_expertise/$search');
    debugPrint(response.data.toString());

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((item) => Expertise.fromJson(item)).toList();
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
    Person person = widget.person;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('รายละเอียดของนักวิจัย',style: GoogleFonts.getFont('Prompt', fontSize: 20, color: Colors.white)),
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (person.pic_name == "ไม่มีข้อมูล")
                        CircleAvatar(
                          radius: 60, // ขนาดของวงกลม
                          child: Icon(
                            Icons.person,
                            color: Colors.white, // สีไอคอน
                            size: 40, // ขนาดไอคอน
                          ),
                        )
                      else
                        CircleAvatar(
                          radius: 60, // ขนาดของวงกลม
                          backgroundImage: NetworkImage(person.pic_name),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(person.full_name),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(person.name_th),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(person.email),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(person.website),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(person.authorUrl),
                    ],
                  ),
                  FutureBuilder<List<Expertise>>(
                    future: fetchData(person.name_th),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Align(
                          child: CircularProgressIndicator(),
                          alignment: Alignment.center,
                        );
                      } else if (snapshot.hasError) {
                        return Text('ไม่พบข้อมูลสาขาความเชียวชาญ');
                      } else {
                        List<Expertise> expertise = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: expertise.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                expertise[index].expertise_name,
                                style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.indigo),
                              ),
                            );
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expertise[index].expertise_name,
                                          style: GoogleFonts.getFont('Prompt', fontSize: 16, color: Colors.indigo),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Text(person.degree_sum),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Text(person.email),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Text(person.website),
                    ],
                  ),
                ],
              ),



            ]));
  }
}
