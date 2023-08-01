// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:gym_workout/features/data/account_data.dart';
import 'package:gym_workout/features/data/hive_database.dart';
import 'package:gym_workout/features/data/workout_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gym_workout/features/pages/home_page.dart';

void main() async {
  // Initialize Hive and open boxes
  await Hive.initFlutter();
  await HiveDatabase.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorkoutPlan()),
        ChangeNotifierProvider(create: (context) => ProfilAcc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
