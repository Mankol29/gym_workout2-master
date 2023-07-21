import 'package:flutter/material.dart';
import 'package:gym_workout/features/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green[900],
      child:  Column(
        children: [
         const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: DrawerHeader(
              child: CircleAvatar(
                maxRadius: 70,
                ),
                ),
          ),
          IconButton(
            onPressed: (){ Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ProfilePage(),
    ),
  );
},
            icon: const Icon(Icons.settings, 
            color: Colors.black54,
            ),),
        ],
      ),
    );
  }
}