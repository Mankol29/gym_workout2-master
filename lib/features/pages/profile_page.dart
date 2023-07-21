import 'package:flutter/material.dart';
import 'package:gym_workout/features/data/hive_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Initialize Hive and open the boxes
  await Hive.initFlutter();
  await Hive.openBox('profile_data');
  await Hive.openBox('workoutPlan_database1');

  runApp(MaterialApp(
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitleController.text),
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context); // Go back to the homepage
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check_sharp,
              color: Colors.black,
            ),
            onPressed: () {
              // Save the user profile information to Hive
              HiveDatabase().saveProfileData(
                FullName.text,
                Email.text,
                Password.text,
                Location.text,
              );

              // Go back to the homepage
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context); // Go back to the homepage
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
                        image: DecorationImage(
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
                        child: Icon(
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
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void onSaveProfileData() {
    // Save the user profile information to Hive
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
  }

  Widget buildTextField(String labelText, TextEditingController controller, bool isPasswordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
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
