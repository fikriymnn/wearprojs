import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../model/user_model.dart';

class DaftarOlahraga extends StatefulWidget {
  const DaftarOlahraga({super.key});

  @override
  State<DaftarOlahraga> createState() => _DaftarOlahragaState();
}

class _DaftarOlahragaState extends State<DaftarOlahraga> {
  void getData() async {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('akun')
        .doc(user!.uid)
        .get();
    UserModel userModel = UserModel.fromSnap(userData);
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('akun')
            .where('uid', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          // if it has data, do your thing:
          final doc = snapshot.data.docs;
          return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                final heartRate = double.parse(
                    snapshot.data.docs[index]['heartRate'].toString());
                return Text(
                  heartRate.toString(),
                  style: TextStyle(fontSize: 50),
                );
              });
        });
  }
}
