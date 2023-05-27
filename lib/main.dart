import 'package:flutter/material.dart';
import 'package:gym_workout/features/data/workout_data.dart';

import 'package:gym_workout/features/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  //hive
  await Hive.initFlutter();
// hive box
  await Hive.openBox("workoutPlan_database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutPlan(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
