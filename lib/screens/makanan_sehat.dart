import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:wearprojs/login.dart';

import '../const/firebase_const.dart';

class MakananSehatScreens extends StatefulWidget {
  const MakananSehatScreens({super.key});

  @override
  State<MakananSehatScreens> createState() => _MakananSehatScreensState();
}

class _MakananSehatScreensState extends State<MakananSehatScreens> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
          onTap: () {
            authInstance.signOut();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          child: Text("Makanan Sehat")),
    );
  }
}
