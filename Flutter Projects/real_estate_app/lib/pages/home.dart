import 'package:dtt_assessment/pages/about_page.dart';
import 'package:dtt_assessment/pages/overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bottom_nav_bar_cubit.dart';
import '../widgets/abstract.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, state) {
          switch (state) {
            case 0:
              return const OverviewPage();
            case 1:
              return const AboutHouse();
            default:
              return const OverviewPage();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffFFFFFF),
        currentIndex: context.watch<BottomNavigationCubit>().state,
        onTap: (index) {
          context.read<BottomNavigationCubit>().updateIndex(index);
        },
        items: <BottomNavigationBarItem>[
          bottomNavBarItem(houseSVG, houseActiveSVG),
          bottomNavBarItem(infoSVG, infoActiveSVG)
        ],
      ),
    );
  }
}
