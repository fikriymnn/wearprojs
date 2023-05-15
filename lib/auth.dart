import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wearprojs/model/user_model.dart' as model;

import 'const/firebase_const.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('akun/123');

  final User? user = authInstance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.UserModel> getUserDetails() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('akun').doc(user!.uid).get();

    return model.UserModel.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser(
      {required Timestamp createdAt,
      required String email,
      required String password,
      required String tujuan,
      required String kelamin,
      required String tanggalLahir,
      required String aktivitas,
      required String beratBadan,
      required String tinggiBadan}) async {
    String res = "Some error Occurred";
    try {
      if (email != null && email.isNotEmpty) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        model.UserModel _user = model.UserModel(
            createdAt: Timestamp.now(),
            uid: cred.user!.uid,
            email: email,
            beratBadan: beratBadan,
            kelamin: kelamin,
            tanggalLahir: tanggalLahir,
            heartRate: 0,
            tinggiBadan: tinggiBadan,
            tinggkatAktivitas: aktivitas,
            tujuan: tujuan);

        // adding user in our database
        await _firestore
            .collection("akun")
            .doc(cred.user!.uid)
            .set(_user.toJson());
        // await ref
        //     .push()
        //     .set({"id": cred.user!.uid, "email": email, "heart_rate": 0});

        res = "success";
      } else {
        res = "Maaf tidak ada yang boleh kosong";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Maaf tidak ada yang boleh kosong";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
