import 'package:flutter/cupertino.dart';
import 'package:gym_workout/features/data/hive_database.dart';
import 'package:gym_workout/features/models/exercises.dart';
import 'package:gym_workout/features/models/workout.dart';
import 'package:provider/provider.dart';

class WorkoutPlan extends ChangeNotifier {
  final db = HiveDatabase();

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

  // czy sa jakies cwiczenia w bazie danych
  void initalizeWorkoutLIst() {
    if (db.previousDataExists()) {
      workoutPlan = db.readFromDataBase();
    } else {
      db.saveToDatebase(workoutPlan);
    }
  }

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
    //zapisz do bazy danych
    db.saveToDatebase(workoutPlan);
  }

  // dodaj cwiczenie do planu

  void addExercise(
    String workoutName,
    String exerciseName,
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

    //zapisz do bazy danych
    db.saveToDatebase(workoutPlan);
  }
  //usun cwiczenie

  void deleteExercise(String workoutName, String exerciseName) {
    // Znajdź odpowiednie ćwiczenie w planie
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    int index = relevantWorkout.exercises
        .indexWhere((exercise) => exercise.name == exerciseName);

    if (index != -1) {
      // Usuń ćwiczenie z planu
      relevantWorkout.exercises.removeAt(index);
      notifyListeners();
       //zapisz do bazy danych
    db.saveToDatebase(workoutPlan);
    }
  }

  void deleteWorkout(String workoutName) {
  int index = workoutPlan.indexWhere((workout) => workout.name == workoutName);

  if (index != -1) {
    workoutPlan.removeAt(index);
    notifyListeners();
    db.saveToDatebase(workoutPlan);
  }
}


  // odznacz cwiczenie

  void checkExercise(String workoutName, String exerciseName) {
    // znajdz odpowiednie cwiczenie w planie
    Exercises relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // jesli zostalo wykonane  == zaznacz
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();

    //zapisz do bazy danych
    db.saveToDatebase(workoutPlan);
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
