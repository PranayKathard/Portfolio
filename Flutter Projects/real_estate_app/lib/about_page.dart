import 'package:flutter/material.dart';
import 'package:dtt_assessment/abstract.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:url_launcher/link.dart';
import 'home_page.dart';
import 'package:sizer/sizer.dart';

class AboutHouse extends StatefulWidget {
  const AboutHouse({super.key});

  @override
  State<AboutHouse> createState() => _AboutHouseState();
}

class _AboutHouseState extends State<AboutHouse> {

  /*BottomNavigationBar*/
  int _selectedIndex = 1;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    AboutHouse()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return _pages[_selectedIndex];
          },
        ));
  }

  /*TEXT*/
  //Use lorem ipsum plugin to generate random text.
  String text = loremIpsum(words: 150);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xffF7F7F7),
          child:  Padding(
            padding: EdgeInsets.fromLTRB(22,7.h,22,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Headings and body*/
                const Text('ABOUT', style: title01
                ),
                const SizedBox(height: 30,),
                Text(
                  text,
                  style: body,
                ),
                const SizedBox(height: 30,),
                const Text(
                  'Design and Development',
                  style: title01,
                ),
                const SizedBox(height: 15,),
                /*Banner and link*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 80,
                        width: 140,
                        child: Image.asset('assets/Images/dtt_banner/xxxhdpi/dtt_banner.png')
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'by DTT',
                          style: detail,
                        ),
                       Link(
                        uri: Uri.parse('https://www.d-tt.nl'),
                         builder: (BuildContext context, Future<void> Function()? followLink) {
                           return InkWell(
                            onTap: followLink,
                             child: const Text(
                               'd-tt.nl',
                               style: TextStyle(color: Colors.blue),
                             ),
                          );
                         },
                       )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffFFFFFF),
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff000000),
        items: <BottomNavigationBarItem>[
          bottomNavBarItem(houseSVG, houseActiveSVG),
          bottomNavBarItem(infoSVG, infoActiveSVG)
        ],
      ),
    );
  }
}
