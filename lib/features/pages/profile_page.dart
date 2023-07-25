import 'package:flutter/material.dart';
import 'package:gym_workout/features/data/hive_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/material.dart';
import 'package:gym_workout/features/data/hive_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Initialize Hive and open the boxes
  await Hive.initFlutter();
  await Hive.openBox('profile_data');
  await Hive.openBox('workoutPlan_database1');

  runApp(const MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isObscurePassword = true;
  final FullName = TextEditingController();
  final Email = TextEditingController();
  final Password = TextEditingController();
  final Location = TextEditingController();
  final appBarTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfileData(); // Wczytaj dane profilu przy inicjalizacji widoku
  }

  void loadProfileData() async {
    // Wczytaj dane profilu z bazy danych Hive
    Map<String, dynamic> profileData = HiveDatabase().getProfileData();

    setState(() {
      FullName.text = profileData['fullName'];
      Email.text = profileData['email'];
      Password.text = profileData['password'];
      Location.text = profileData['location'];
      appBarTitleController.text = profileData['fullName'];
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitleController.text),
        centerTitle: true,
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
           _goBack(); // Go back to the homepage
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check_sharp,
              color: Colors.black,
            ),
            onPressed: () {
              _saveProfileData();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              _goBack(); // Go back to the homepage
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            'https://cdn.pixabay.com/photo/2023/06/27/10/51/man-8091933_1280.jpg',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Colors.white,
                          ),
                          color: Colors.grey[900],
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              buildTextField('Full Name', FullName, false),
              buildTextField('Email', Email, false),
              buildTextField('Password', Password, true),
              buildTextField("Location", Location, false),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Method to save profile data to Hive and update the app bar title
  void _saveProfileData() {
    HiveDatabase().saveProfileData(
      FullName.text,
      Email.text,
      Password.text,
      Location.text,
    );
    // Update the app bar title with the full name
    setState(() {
      appBarTitleController.text = FullName.text;
    });
    _goBack();
  }

  void _goBack() {
    Navigator.pop(context);
  }

  Widget buildTextField(String labelText, TextEditingController controller, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscurePassword = !isObscurePassword;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: labelText,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
