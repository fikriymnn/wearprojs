import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wearprojs/login.dart';
import 'package:wearprojs/screens/edit_screens.dart';

import 'const/firebase_const.dart';

class DrawerCustom extends StatefulWidget {
  const DrawerCustom({super.key});

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      child: Column(
        children: [
          SizedBox(
            height: 150,
          ),
          TextButton.icon(
              onPressed: () {
                authInstance.signOut();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              label: Text(
                "Logout",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }
}
