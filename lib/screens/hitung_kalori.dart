import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:wearprojs/const/snack_bar.dart';
import 'package:intl/intl.dart';

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
  double Bmr = 0;
  double kal = 0;
  String katBmi = "";

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void HitungBmi(double tinggiBadan, double beratBadan) {
    double tinggiBadanM = tinggiBadan / 100;

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

  void hitungBmr(double beratBadan, double tinggiBadan, int usia,
      String kelamin, String tingkatAktivitas) {
    double tinggiBadanM = tinggiBadan / 100;
    double l = 66;
    double P = 665;
    double aktivitas = 0;

    if (kelamin == "Laki-Laki") {
      if (tingkatAktivitas == "Jarang Sekali") {
        setState(() {
          aktivitas = 1.30;
        });
      } else if (tingkatAktivitas == "Sedikit Aktif") {
        setState(() {
          aktivitas = 1.65;
        });
      } else if (tingkatAktivitas == "Aktif") {
        setState(() {
          aktivitas = 1.76;
        });
      } else if (tingkatAktivitas == "Sangat Aktif") {
        setState(() {
          aktivitas = 1.65;
        });
      } else {
        aktivitas = 0;
      }

      setState(() {
        Bmr = l + (13.7 * beratBadan) + (5 * tinggiBadan) - (6.8 * usia);
        kal = Bmr * aktivitas;
      });
    } else {
      if (tingkatAktivitas == "Jarang Sekali") {
        setState(() {
          aktivitas = 1.30;
        });
      } else if (tingkatAktivitas == "Sedikit Aktif") {
        setState(() {
          aktivitas = 1.65;
        });
      } else if (tingkatAktivitas == "Aktif") {
        setState(() {
          aktivitas = 1.76;
        });
      } else if (tingkatAktivitas == "Sangat Aktif") {
        setState(() {
          aktivitas = 1.65;
        });
      } else {
        aktivitas = 0;
      }
      setState(() {
        Bmr = P + (9.6 * beratBadan) + (1.8 * tinggiBadan) - (4.7 * usia);
        kal = Bmr * aktivitas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("akun")
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text("no data"));
          } else {
            var docsk = snapshot.data!.docs;

            return ListView.builder(
                itemCount: docsk.length,
                itemBuilder: (context, index) {
                  var tahun = snapshot.data!.docs[index]['tglLahir'].toDate();
                  var now = DateTime.now();
                  int usia = int.parse(DateFormat.y().format(now)) -
                      int.parse(DateFormat.y().format(tahun));

                  String beratBadan = docsk[index]['beratBadan'];
                  String tinggiBadan = docsk[index]['tinggiBadan'];
                  String kelamin = docsk[index]['kelamin'];
                  String tingkatAktivitas = docsk[index]['tingkatAktivitas'];
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Text(Bmi.toStringAsFixed(2)),
                        Text(katBmi),
                        Text(kal.toString()),
                        Text(
                          "Usia $usia Tahun",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Tinggi Badan $tinggiBadan CM",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Berat Badan $beratBadan Kg",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Kelamin $kelamin",
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
                                      HitungBmi(double.parse(tinggiBadan),
                                          double.parse(beratBadan));
                                    },
                                    child: Text(
                                      "Hitung BMI",
                                      style: TextStyle(fontSize: 20),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      hitungBmr(
                                          double.parse(beratBadan),
                                          double.parse(tinggiBadan),
                                          usia,
                                          kelamin,
                                          tingkatAktivitas);
                                    },
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
                });
          }
        });
  }
}
