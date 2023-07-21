import 'package:gym_workout/datetime/date_time.dart';
import 'package:gym_workout/features/models/exercises.dart';
import 'package:gym_workout/features/models/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  final _myBox = Hive.box('workoutPlan_database1');

  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print('previous data does not exist');
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("previous data does exist");
      return true;
    }
  }
  Future<List<String>> readProfileData() async {
    final profileBox = Hive.box('profile_data');
    List<String> profileData = [];
    profileData.add(profileBox.get('FULL_NAME', defaultValue: ''));
    profileData.add(profileBox.get('EMAIL', defaultValue: ''));
    profileData.add(profileBox.get('PASSWORD', defaultValue: ''));
    profileData.add(profileBox.get('LOCATION', defaultValue: ''));
    return profileData;
  }

  String getStartDate() {
    return _myBox.get("START_DATE");
  }

   void saveProfileData(String fullName, String email, String password, String location) {
    final profileBox = Hive.box('profile_data');
    profileBox.put('FULL_NAME', fullName);
    profileBox.put('EMAIL', email);
    profileBox.put('PASSWORD', password);
    profileBox.put('LOCATION', location);
  }
  

  Map<String, dynamic> getProfileData() {
    final profileBox = Hive.box('profile_data');
    return {
      'fullName': profileBox.get('FULL_NAME', defaultValue: ''),
      'email': profileBox.get('EMAIL', defaultValue: ''),
      'password': profileBox.get('PASSWORD', defaultValue: ''),
      'location': profileBox.get('LOCATION', defaultValue: ''),
    };
  }

  void saveToDatebase(
    List<Workout> workouts,
    String fullName,
    String email,
    String password,
    String location,
  ) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_" + todaysDateYYYYMMDD(), 1);
    } else {
      _myBox.put("COMPLETION_STATUS_" + todaysDateYYYYMMDD(), 0);
    }

    _myBox.put("FULL_NAME", fullName);
    _myBox.put("EMAIL", email);
    _myBox.put("PASSWORD", password);
    _myBox.put("LOCATION", location);

    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

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

  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _myBox.get("COMPLETION_STATUS_" + yyyymmdd) ?? 0;
    return completionStatus;
  }
}

List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (int i = 0; i < workouts.length; i++) {
    List<Exercises> exercisesInWorkout = workouts[i].exercises;
    List<List<String>> individualWorkout = [];

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
