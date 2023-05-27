import 'package:flutter/material.dart';
import 'package:gym_workout/components/exercise_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutPlan>(context, listen: false)
        .checkExercise(workoutName, exerciseName);
  }

  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  // okno do dodawania cwiczenia
  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dodaj nowe ćwiczenie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //exercise name
            TextField(
              controller: exerciseNameController,
              decoration: InputDecoration(hintText: "Nazwa ćwiczenia"),
            ),

            TextField(
              controller: weightController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(hintText: "Ilość ciężaru"),
            ),

            TextField(
              controller: repsController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(hintText: "Ilość powtórzeń"),
            ),

            TextField(
              controller: setsController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(hintText: "Ilość serii"),
            ),
          ],
        ),
        actions: [
          // save
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),

          //cancel
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

// save workout
  void save() {
    // get exercise name from controller
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    //add exercise
    Provider.of<WorkoutPlan>(context, listen: false).addExercise(
      widget.workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
    );

    // pop of dialog
    Navigator.pop(context);
    clear();
  }

  // cancel workout
  void cancel() {
    // pop of dioalog
    Navigator.pop(context);
    clear();
  }

  // clear dialog
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutPlan>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: Text(widget.workoutName),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: createNewExercise,
        ),
        body: ListView.builder(
          itemCount: value.numberOfExInWorkout(widget.workoutName),
          itemBuilder: ((context, index) => ExerciseTile(
                exerciseName: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name,
                weight: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .weight,
                reps: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .reps,
                sets: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .sets,
                isCompleted: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .isCompleted,
                onCheckBoxChanged: (val) => onCheckBoxChanged(
                  widget.workoutName,
                  value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .name,
                ), workoutName: widget.workoutName,
              )),
        ),
      ),
    );
  }
}
