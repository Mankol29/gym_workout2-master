import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_workout/features/data/account_data.dart';
import 'package:gym_workout/features/data/hive_database.dart';
import 'package:gym_workout/features/models/drawer.dart';
import 'package:gym_workout/features/models/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final File? imageFile;

  ProfilePage({Key? key, this.imageFile,}) : super(key: key);

  Future<void> saveProfileImage(File imageFile) async {
    final box = await Hive.openBox('profile_data');
    final imageBytes = imageFile.readAsBytesSync();
    await box.put('profile_image', imageBytes);
  }

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
  File? imageFile;

  @override
  void initState() {
    super.initState();
    loadProfileData(); // Load profile data on initialization
  }

  void loadProfileData() async {
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
    final profilAcc = Provider.of<ProfilAcc>(context);
    File? imageFile = profilAcc.imageFile; // Get the imageFile from ProfilAcc
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
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: profilAcc.imageFile != null
                    ? FileImage(profilAcc.imageFile!) as ImageProvider<Object> // Use the selected image file if available
                    : imageFile != null // Use the last selected image if no new image is selected
                        ? FileImage(imageFile!) as ImageProvider<Object>
                        : NetworkImage(
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
                        child: ImagePickerWidget(
                          onImagePicked: (File pickedImage) {
                            // Update the selected image from the ImagePickerWidget and save it to the database
                            setState(() {
                              imageFile = pickedImage;
                            });
                            profilAcc.saveProfileImage(pickedImage);
                          },
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

  // Method to pick an image
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Update the selected image from the ImagePickerWidget
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyDrawer(imageFile: imageFile,),),);
        
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
