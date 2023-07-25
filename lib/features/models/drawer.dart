import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_workout/features/data/account_data.dart';
import 'package:gym_workout/features/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
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
                      child: Text(profileData.fullName,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),textAlign: TextAlign.left,),
                    ),
                    IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                builder: (context) => ProfilePage(),
                ),
              ).then((_) {
                // Update the fullName in the drawer header when ProfilePage is popped.
                profileData.initializeProfileData(); // Refresh the fullName from Hive
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
