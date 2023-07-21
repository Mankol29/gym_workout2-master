import 'package:flutter/cupertino.dart';
import 'package:gym_workout/features/data/hive_database.dart';
import 'package:gym_workout/features/models/exercises.dart';
import 'package:gym_workout/features/models/workout.dart';
import 'package:provider/provider.dart';

class WorkoutPlan extends ChangeNotifier {
  final db = HiveDatabase();

  List<Workout> workoutPlan = [];

  WorkoutPlan() {
    initializeWorkoutList();
  }

  Future<void> initializeWorkoutList() async {
    workoutPlan = await db.readFromDataBase();
    notifyListeners();
  }

  List<Workout> getWorkoutList() {
    return workoutPlan;
  }

  int numberOfExInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  Future<void> deleteExercise(String workoutName, String exerciseName) async {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.removeWhere((exercise) => exercise.name == exerciseName);
    db.saveToDatebase(workoutPlan, '', '', '', ''); // Empty strings for user profile info
    notifyListeners();
  }

  Future<void> deleteWorkout(String workoutName) async {
    workoutPlan.removeWhere((workout) => workout.name == workoutName);
    db.saveToDatebase(workoutPlan, '', '', '', ''); // Empty strings for user profile info
    notifyListeners();
  }

  void checkExercise(String workoutName, String exerciseName) {
    Exercises relevantExercise = getRelevantExercise(workoutName, exerciseName);
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    db.saveToDatebase(workoutPlan, '', '', '', ''); // Empty strings for user profile info
  }

  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout = workoutPlan.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  Exercises getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    Exercises relevantExercise = relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  void addWorkout(String workoutName) {
    Workout newWorkout = Workout(name: workoutName, exercises: []);
    workoutPlan.add(newWorkout);
    db.saveToDatebase(workoutPlan, '', '', '', ''); // Empty strings for user profile info
    notifyListeners();
  }

  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets) {
    Exercises newExercise = Exercises(
      name: exerciseName,
      weight: weight,
      reps: reps,
      sets: sets,
      isCompleted: false,
    );
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.add(newExercise);
    db.saveToDatebase(workoutPlan, '', '', '', ''); // Empty strings for user profile info
    notifyListeners();
  }
}
