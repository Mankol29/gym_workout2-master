import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditExercisePage extends StatefulWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;

  const EditExercisePage({
    Key? key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
  }) : super(key: key);

  @override
  _EditExercisePageState createState() => _EditExercisePageState();
}

class _EditExercisePageState extends State<EditExercisePage> {
  TextEditingController exerciseNameController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController setsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the provided exercise details
    exerciseNameController.text = widget.exerciseName;
    weightController.text = widget.weight;
    repsController.text = widget.reps;
    setsController.text = widget.sets;
  }

  void onSaveButtonPressed() {
    String newExerciseName = exerciseNameController.text;
    String newWeight = weightController.text;
    String newReps = repsController.text;
    String newSets = setsController.text;

    // Pass the updated exercise details back to the WorkoutPage
    Navigator.pop(context, {
      'exerciseName': newExerciseName,
      'weight': newWeight,
      'reps': newReps,
      'sets': newSets,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exercise Name: ${widget.exerciseName}'),
            TextField(
              controller: weightController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Weight'),
            ),
            TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: repsController,
              decoration: const InputDecoration(labelText: 'Reps'),
            ),
            TextField(
              controller: setsController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Sets'),
            ),
            ElevatedButton(
              onPressed: onSaveButtonPressed,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}