import 'package:dtt_assessment/bloc/filter_cubit.dart';
import 'package:dtt_assessment/bloc/house_cubit.dart';
import 'package:dtt_assessment/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'bloc/bottom_nav_bar_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
      MultiBlocProvider(
          providers: [
            BlocProvider<BottomNavigationCubit>(
              create: (BuildContext context) => BottomNavigationCubit(),
            ),
            BlocProvider<HouseCubit>(
                create: (BuildContext context) => HouseCubit()..fetchHouses()
            ),
            BlocProvider<FilterCubit>(
                create: (BuildContext context) => FilterCubit()
            ),
          ],
          child: Sizer(
              builder: (context, orientation, deviceType) {
                return const MaterialApp(
                  //Remove debug banner
                  debugShowCheckedModeBanner: false,
                  home: SplashScreen(),
                );
              }
          )
      );


  }
}


