import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:final_project_research/models/todo_item.dart';
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
  List<TodoItem>? _itemList;
  String? _error;
  Map<String, dynamic>? list;

  void getTodos() async {
    try {
      final response = await _dio.get('http://10.0.2.2:8000/nodes');
      debugPrint(response.data.toString());
      debugPrint("test");
      // parse

      setState(() {
        list = jsonDecode(response.data.toString());
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            ]));
  }
}