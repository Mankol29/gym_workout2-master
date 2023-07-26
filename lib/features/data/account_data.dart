import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_workout/features/data/hive_database.dart';
import 'package:hive/hive.dart';

class ProfilAcc extends ChangeNotifier {
  final db = HiveDatabase();

  String fullName = '';
  String email = '';
  String password = '';
  String location = '';
  File? imageFile; // Add the imageFile property to store the selected image
  List<String?> avatarUrls = List.filled(6, null); // List to store selected avatar URLs

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

  // Add a method to set the imageFile property
  void setImageFile(File? file) {
    imageFile = file;
    notifyListeners();
  }
  // Method to set the selected avatar URL
  void setSelectedAvatarUrl(int index, String? imageUrl) {
    avatarUrls[index] = imageUrl;
    notifyListeners();
  }
}