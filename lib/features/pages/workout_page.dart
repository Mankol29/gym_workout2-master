import 'package:flutter/material.dart';
import 'package:gym_workout/components/exercise_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({Key? key, required this.workoutName}) : super(key: key);

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
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

  // Okno do dodawania ćwiczenia
  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dodaj nowe ćwiczenie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nazwa ćwiczenia
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
          // Zapisz
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),

          // Anuluj
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  // Zapisz trening
  void save() {
    // Pobierz nazwę ćwiczenia z kontrolera
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    // Dodaj ćwiczenie
    Provider.of<WorkoutPlan>(context, listen: false).addExercise(
      widget.workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
    );

    // Zamknij okno dialogowe
    Navigator.pop(context);
    clear();
  }

  // Anuluj trening
  void cancel() {
    // Zamknij okno dialogowe
    Navigator.pop(context);
    clear();
  }

  // Wyczyść zawartość dialogu
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
        resizeToAvoidBottomInset:
            false, // Zapobiegaj przesuwaniu się obrazka po wysunięciu klawiatury
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: createNewExercise,
          backgroundColor: Colors.green,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'images/gym-workout-page.jpg'), // Ścieżka do obrazu tła
              fit: BoxFit.cover,
            ),
          ),
          child: ListView.builder(
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
                  ),
                  workoutName: widget.workoutName,
                )),
          ),
        ),
      ),
    );
  }
}
