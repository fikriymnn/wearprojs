import 'package:flutter/material.dart';
import 'package:wearprojs/const/yy.dart';

import 'package:wearprojs/login.dart';

import '../const/firebase_const.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class MakananSehatScreens extends StatefulWidget {
  const MakananSehatScreens({super.key});

  @override
  State<MakananSehatScreens> createState() => _MakananSehatScreensState();
}

class _MakananSehatScreensState extends State<MakananSehatScreens> {
  IntakeRecommendation vitB12 =
      RecommendedDailyIntake.getRecommendedDailyIntakes().chloride;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          InkWell(
              onTap: () {
                authInstance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: Text("Makanan Sehat")),
        ],
      ),
    );
  }
}
