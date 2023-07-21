import 'package:flutter/cupertino.dart';
import 'package:gym_workout/features/data/hive_database.dart';

class ProfilAcc extends ChangeNotifier {
  final db = HiveDatabase();

  String fullName= '';
  String email = '';
  String password = '';
  String location = '';

  ProfilAcc() {
    initializeProfileData();
  }

  Future<void> initializeProfileData() async {
    List<String> profileData = await db.readProfileData();
    if (profileData.isNotEmpty) {
      fullName = profileData[0];
      email = profileData[1];
      password = profileData[2];
      location = profileData[3];
    }
    notifyListeners();
  }

  void updateProfileData(String newName, String newEmail, String newPassword, String newLocation) {
    fullName = newName;
    email = newEmail;
    password = newPassword;
    location = newLocation;
    db.saveProfileData(newName, newEmail, newPassword, newLocation);
    notifyListeners();
  }
}