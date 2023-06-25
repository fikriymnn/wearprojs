import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wearprojs/btm_bar.dart';
import 'package:wearprojs/const/snack_bar.dart';
import 'package:wearprojs/login.dart';

class VerifikasiScreen extends StatefulWidget {
  const VerifikasiScreen({super.key});

  @override
  State<VerifikasiScreen> createState() => _VerifikasiScreenState();
}

class _VerifikasiScreenState extends State<VerifikasiScreen> {
  bool isEmailVerify = false;
  bool canResentEmail = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    isEmailVerify = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerify) {
      sendVerifikasiEmail();

      timer =
          Timer.periodic(Duration(seconds: 3), (timer) => checkEmailVerify());
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerify() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerify = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerify) timer?.cancel();
  }

  Future sendVerifikasiEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResentEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResentEmail = true);
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerify
      ? BottomBarScreen()
      : Scaffold(
          appBar: AppBar(
            title: Text(
              "Email Verification",
              style: GoogleFonts.rubik(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ),
            backgroundColor: Colors.green,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "A verification email has been sent to your email",
                  style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: canResentEmail
                            ? Colors.green
                            : Colors.black.withOpacity(0.10),
                        minimumSize: Size.fromHeight(50)),
                    onPressed: canResentEmail ? sendVerifikasiEmail : null,
                    icon: Icon(
                      Icons.email,
                      size: 32,
                    ),
                    label: Text(
                      "Resent Email",
                      style: GoogleFonts.rubik(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                    )),
                SizedBox(
                  height: 8,
                ),
                TextButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50)),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "Cancle",
                      style: GoogleFonts.rubik(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                    ))
              ],
            ),
          ),
        );
}
