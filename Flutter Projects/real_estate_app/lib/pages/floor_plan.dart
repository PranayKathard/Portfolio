import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

import '../widgets/abstract.dart';

class FloorPlan extends StatefulWidget {
  const FloorPlan({super.key});

  @override
  State<FloorPlan> createState() => _FloorPlanState();
}

class _FloorPlanState extends State<FloorPlan> {
  late Object plan;

  @override
  void initState() {
    super.initState();
    //Set the dynamic object to the .obj floor plan file
    plan = Object(fileName: 'assets/house-floor-plan-v2/source/AllFloors/AllFloors.obj');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            height: 30,
            width: 30,
            //Back button
            child: GestureDetector(
              child: backSVGFloorPlan,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
      //3d object rendered using Cube
      body: Center(
        child: Cube(
          onSceneCreated: (Scene scene) {
            scene.world.add(plan);
            scene.camera.zoom = 5;
            },
        ),
      ),
    );
  }
}
