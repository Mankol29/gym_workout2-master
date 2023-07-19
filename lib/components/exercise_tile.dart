import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/data/workout_data.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  String workoutName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
    required this.workoutName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title:  Dismissible(
          key: Key(exerciseName),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            // Usuń ćwiczenie z listy (przykład z użyciem dostawcy danych)
            Provider.of<WorkoutPlan>(context, listen: false)
                .deleteExercise(workoutName, exerciseName);
          },
          background: Container(decoration: BoxDecoration(
borderRadius: BorderRadius.circular(30.0),
                            color: Colors.red,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(
                    0.5), // Ustaw biały kolor z poziomem przezroczystości 0.5
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: ListTile(
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(exerciseName),
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //weight
                    Chip(
                      label: Text(
                        "${weight}kg",
                      ),
                    ),
                    //reps
                    Chip(
                      label: Text(
                        "$reps powtórzeń",
                      ),
                    ),
                    //sets
                    Chip(
                      label: Text(
                        "$sets serii",
                      ),
                    ),
                  ],
                ),
                trailing: Checkbox(
                  checkColor: Colors.white,
                  fillColor:
                      MaterialStateProperty.resolveWith((states) => Colors.black),
                  value: isCompleted,
                  onChanged: (value) => onCheckBoxChanged!(value),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
