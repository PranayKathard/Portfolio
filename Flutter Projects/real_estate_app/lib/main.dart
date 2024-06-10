import 'package:dtt_assessment/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(
            //Remove debug banner
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        }
    );

  }
}

