import 'package:flutter/cupertino.dart';
import 'package:gym_workout/features/models/exercises.dart';
import 'package:gym_workout/features/models/workout.dart';

class WorkoutPlan extends ChangeNotifier {
  List<Workout> workoutPlan = [
    Workout(
      name: 'Upper Body',
      exercises: [
        Exercises(
          name: "Biceps Curl",
          weight: '20',
          reps: "12",
          sets: "2",
        ),
      ],
    ),
    Workout(
      name: 'Lower Body',
      exercises: [
        Exercises(
          name: "Squads ",
          weight: '20',
          reps: "12",
          sets: "2",
        ),
      ],
    ),
  ];

  //zrob liste planu cwiczen

  List<Workout> getWorkoutList() {
    return workoutPlan;
  }

  // uzyskaj dlugosc danego treningu

  int numberOfExInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  //dodaj plan cwiczen

  void addWorkout(String name) {
    // dodaj cwiczenie z białym polem
    workoutPlan.add(Workout(name: name, exercises: []));

    notifyListeners();
  }

  // dodaj cwiczenie do planu

  void addExercise(
    String workoutName,
    String exerciseName,
    String name,
    String weight,
    String reps,
    String sets,
  ) {
    // znajdz odpowiedni trening
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercises(
        name: exerciseName,
        weight: weight,
        reps: reps,
        sets: sets,
      ),
    );
    notifyListeners();
  }

  // odznacz cwiczenie

  void checkExercise(String workoutName, String exerciseName) {
    // znajdz odpowiednie cwiczenie w planie
    Exercises relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // jesli zostalo wykonane  == zaznacz
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  // zwroc odpowieni plan
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutPlan.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  Exercises getRelevantExercise(String workoutName, String exerciseName) {
    // najpierw znajdz odpowiedni plan
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    // pozniej znajdz odpowiednie cwiczenie w tym planie

    Exercises relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}
