import 'package:dtt_assessment/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin{
  //SingleTicker allows me to use Duration

  @override
  void initState() {
    super.initState();

    //Remove overlays while loading
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    //Slight delay then move to Home page
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  @override
  void dispose() {
    super.dispose();

    //Return overlays
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
            color: Color(0xffE65541)
        ),
        child: Center(
          child: Image.asset('assets/Images/launcher_icon.png'),
        ),
      ),

    );
  }
}

