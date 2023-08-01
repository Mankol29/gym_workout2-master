import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_workout/features/data/account_data.dart';
import 'package:gym_workout/features/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  final File? imageFile;

  const MyDrawer({Key? key, this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profilAcc = Provider.of<ProfilAcc>(context);
    final profileData = Provider.of<ProfilAcc>(context);
    final profileEmail = Provider.of<ProfilAcc>(context);

    return Drawer(
      backgroundColor: Colors.green[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(profileData.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left,),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(), // Pass the ProfilAcc instance here
                          ),
                        ).then((_) {
                          // Update the fullName in the drawer header when ProfilePage is popped.
                          profileData.initializeProfileData(); // Refresh the fullName from Hive
                          if (profilAcc.imageFile != null) {
                            profilAcc.saveProfileImage(profilAcc.imageFile!); // Save the image to the database
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(profileEmail.email),
          ),
          Center(
            child: DrawerHeader(
              child: CircleAvatar(
                maxRadius: 70,
                backgroundImage: profilAcc.imageFile != null
                    ? FileImage(profilAcc.imageFile!) as ImageProvider<Object> // Use the selected image file if available
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
