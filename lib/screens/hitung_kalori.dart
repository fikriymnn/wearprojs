import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:wearprojs/const/snack_bar.dart';

import '../const/firebase_const.dart';

class HitungKalori extends StatefulWidget {
  const HitungKalori({super.key});

  @override
  State<HitungKalori> createState() => _HitungKaloriState();
}

class _HitungKaloriState extends State<HitungKalori> {
  final User? user = authInstance.currentUser;

  final String hasilBmr = "";
  String myAge = "";

  double Bmi = 0;
  String katBmi = "";

  String? tglLahir;
  String tinggi = "";
  String berat = "";
  String? kelamin;
  bool _isLoading = false;

  @override
  void initState() {
    getUserData();

    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('akun')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userDoc == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      } else {
        tglLahir = userDoc.get('tglLahir');
        tinggi = userDoc.get('tinggiBadan');
        berat = userDoc.get('beratBadan');
        kelamin = userDoc.get('kelamin');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, '$error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void HitungBmi() {
    double beratBadan = double.parse(berat);
    double tinggiBadanCm = double.parse(tinggi);
    double tinggiBadanM = tinggiBadanCm / 100;
    setState(() {
      Bmi = beratBadan / (tinggiBadanM * tinggiBadanM);
      if (Bmi < 17) {
        setState(() {
          katBmi = "Terlalu Kurus";
        });
      } else if (Bmi == 17 || Bmi <= 18.4) {
        setState(() {
          katBmi = "Kurus";
        });
      } else if (Bmi == 18.5 || Bmi <= 25) {
        setState(() {
          katBmi = "Normal";
        });
      } else if (Bmi == 25.1 || Bmi <= 27) {
        setState(() {
          katBmi = "Obesitas kelas 1";
        });
      } else if (Bmi > 27) {
        setState(() {
          katBmi = "Obesitas kelas 2";
        });
      } else {
        katBmi = "wkwkw";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Text(Bmi.toStringAsFixed(2)),
          Text(katBmi),
          Text(
            "Usia ${tglLahir == null ? "" : tglLahir!} Tahun",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Tinggi Badan ${tinggi == null ? "" : tinggi!} CM",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Berat Badan ${berat == null ? "" : berat!} Kg",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Kelamin ${kelamin == null ? "" : kelamin!}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        HitungBmi();
                      },
                      child: Text(
                        "Hitung BMI",
                        style: TextStyle(fontSize: 20),
                      )),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Hitung BMR",
                        style: TextStyle(fontSize: 20),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
