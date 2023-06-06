import 'package:gym_workout/datetime/date_time.dart';
import 'package:gym_workout/features/models/exercises.dart';
import 'package:gym_workout/features/models/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
// references hivebox
  final _myBox = Hive.box('workoutPlan_database1');

// chceck if there is already data stored, if not, record start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print('previous data does not exists');
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("previous data does  exists");
      return true;
    }
  }

// return staret datae as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

// write data
  void saveToDatebase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    // check if any exercises have been done
    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_" + todaysDateYYYYMMDD(), 1);
    } else {
      _myBox.put("COMPLETION_STATUS_" + todaysDateYYYYMMDD(), 0);
    }
    //save it into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

//read data and return a list of workouts
  List<Workout> readFromDataBase() {
    List<Workout> mySavedWorkouts = [];

    List<String>? workoutNames = _myBox.get("WORKOUTS");
    List<dynamic>? exerciseDetails = _myBox.get("EXERCISES");

    if (workoutNames != null && exerciseDetails != null) {
      for (int i = 0; i < workoutNames.length; i++) {
        List<Exercises> exercisesInEachWorkout = [];

        List<dynamic> exercisesData = exerciseDetails[i];
        for (int j = 0; j < exercisesData.length; j++) {
          List<dynamic> exercise = exercisesData[j];
          exercisesInEachWorkout.add(
            Exercises(
              name: exercise[0],
              weight: exercise[1],
              reps: exercise[2],
              sets: exercise[3],
              isCompleted: exercise[4] == "true",
            ),
          );
        }

        Workout workout = Workout(
          name: workoutNames[i],
          exercises: exercisesInEachWorkout,
        );

        mySavedWorkouts.add(workout);
      }
    }

    return mySavedWorkouts;
  }

// check if any exercises is done
  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

//return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _myBox.get("COMPLETION_STATUS_" + yyyymmdd) ?? 0;
    return completionStatus;
  }
}

//converts workout objects into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

//converts the exercises in a workout object into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];
  // go through each workout
  for (int i = 0; i < workouts.length; i++) {
    //get exercises from each workout
    List<Exercises> exercisesInWorkout = workouts[i].exercises;
    List<List<String>> individualWorkout = [];
    // go through each execises in ExerciseLIst
    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
