import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/data/workout_data.dart';

// ignore: must_be_immutable
class ExerciseTile extends StatefulWidget {
  final String exerciseName;
  final String workoutName;
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
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:  Dismissible(
        key: Key(widget.exerciseName),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          // Usuń ćwiczenie z listy (przykład z użyciem dostawcy danych)
          Provider.of<WorkoutPlan>(context, listen: false)
              .deleteExercise(widget.workoutName, widget.exerciseName);
        },
        background: Container(decoration: BoxDecoration(
borderRadius: BorderRadius.circular(30.0),
                          color: Colors.red,),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
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
                  child: Text(widget.exerciseName, style: const TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //weight
                  Chip(
                    label: Text(
                      "${widget.weight}kg",
                    ),
                  ),
                  //reps
                  Chip(
                    label: Text(
                      "${widget.reps} powtórzeń",
                    ),
                  ),
                  //sets
                  Chip(
                    label: Text(
                      "${widget.sets} serii",
                    ),
                  ),
                ],
              ),
              trailing: Checkbox(
                checkColor: Colors.white,
                fillColor:
                    MaterialStateProperty.resolveWith((states) => Colors.black),
                value: widget.isCompleted,
                onChanged: (value) => widget.onCheckBoxChanged!(value),
                
              ),
            ),
          ),
        ),
      ),
    );
  }
}
