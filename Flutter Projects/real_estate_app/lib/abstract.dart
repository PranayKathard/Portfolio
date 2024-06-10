import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

//ICONS

final Widget searchSVG = SvgPicture.asset('assets/icons/ic_search.svg', color: const Color(0xff949494));
final Widget bedSVG = SvgPicture.asset('assets/icons/ic_bed.svg', color: const Color(0xff949494));
final Widget bathSVG = SvgPicture.asset('assets/icons/ic_bath.svg', color: const Color(0xff949494));
final Widget sizeSVG = SvgPicture.asset('assets/icons/ic_layers.svg', color: const Color(0xff949494));
final Widget locationSVG = SvgPicture.asset('assets/icons/ic_location.svg', color: const Color(0xff949494));
final Widget houseSVG = SvgPicture.asset('assets/icons/ic_home.svg', color: const Color(0xff949494));
final Widget infoSVG = SvgPicture.asset('assets/icons/ic_info.svg', color: const Color(0xff949494));
final Widget houseActiveSVG = SvgPicture.asset('assets/icons/ic_home.svg', color: const Color(0xff000000));
final Widget infoActiveSVG = SvgPicture.asset('assets/icons/ic_info.svg', color: const Color(0xff000000));
final Widget backSVG = SvgPicture.asset('assets/icons/ic_back.svg', color: const Color(0xffF7F7F7));
final Widget backSVGFloorPlan = SvgPicture.asset('assets/icons/ic_back.svg', color: const Color(0xff949494));

//WIDGETS

//Extracted widget for a BottomNavigationBarItem
//Usage: home_page, about_page
BottomNavigationBarItem bottomNavBarItem(Widget icon, Widget iconActive) {
  return BottomNavigationBarItem(
    label: '',
    activeIcon: Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(height: 30, width: 30, child: iconActive),
    ),
    icon: Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(height: 30, width: 30, child: icon),
    ),
  );
}

//Extracted widget from a house Card
//Usage: home_page
Widget iconRowWidget(Widget svg, String metric){
  return Row(
    children: [
      SizedBox(width: 16,height: 16,child: svg,),
      const SizedBox(width: 3),
      Text(metric, style: subtitle,)
    ],
  );
}


//Extracted widget for text on house card
//Usage: home_page
TextSpan textSpan(String text, double fontSize, Color color, FontWeight fw){
  return TextSpan(
      text: text,
      style: TextStyle(
          fontFamily: 'Gotham SSm',
          fontSize: fontSize,
          color: color,
          fontWeight: fw)
  );
}

Widget filterSlider(double value, Function(double) func){
  return Slider(
    value: value,
    min: 1.0,
    max: 6.0,
    divisions: 5,
    label: value.round().toString(),
    onChanged: func
  );
}

//TEXT

const TextStyle title01 = TextStyle(
    fontFamily: 'Gotham SSm',
    fontWeight: FontWeight.w700,
    fontSize: 18
  );

const TextStyle title02 = TextStyle(
      fontFamily: 'Gotham SSm',
      fontWeight: FontWeight.w700,
      fontSize: 16
  );

const TextStyle title03 = TextStyle(
      fontFamily: 'Gotham SSm',
      fontWeight: FontWeight.w400,
      fontSize: 16
  );


const TextStyle body = TextStyle(
    fontFamily: 'Gotham SSm',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: Color(0xff949494)
);


const TextStyle input = TextStyle(
      fontFamily: 'Gotham SSm',
      fontWeight: FontWeight.w200,
      fontSize: 12
  );


const TextStyle hint = TextStyle(
      fontFamily: 'Gotham SSm',
      fontWeight: FontWeight.w300,
      fontSize: 12
  );


const TextStyle subtitle = TextStyle(
      fontFamily: 'Gotham SSm',
      fontWeight: FontWeight.w400,
      fontSize: 10,
      color: Color(0xff949494)
  );


const TextStyle detail = TextStyle(
      fontFamily: 'Gotham SSm',
      fontWeight: FontWeight.w400,
      fontSize: 12
  );
