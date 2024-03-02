import 'package:final_project_research/screens/search_person.dart';
import 'package:final_project_research/screens/search_research.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required String title});

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
      Positioned.fill(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  // กระทำที่คุณต้องการเมื่อปุ่มบนถูกกด
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MySearchPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20.0),
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset('assets/pictures/person_search.png',
                          width: 80, height: 80),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('ค้นหานักวิจัย',
                          style: GoogleFonts.getFont('Prompt',fontSize: 20 , color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  // กระทำที่คุณต้องการเมื่อปุ่มบนถูกกด
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchResearchPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20.0),
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset('assets/pictures/research_search.png',
                          width: 80, height: 80),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('ค้นหางานวิจัย',
                          style: GoogleFonts.getFont('Prompt',fontSize: 20 , color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    ]));
  }
}
