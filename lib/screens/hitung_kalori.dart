import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:wearprojs/screens/edit_screens.dart';

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

  @override
  void initState() {
    super.initState();
  }

  HitungBmi(double tinggiBadan, double beratBadan) {
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

  hitungBmr(double beratBadan, double tinggiBadan, int usia, String kelamin,
      String tingkatAktivitas) {
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
                  String hasilBmr = docsk[index]['hasilBmr'].toString();
                  double hasilBmi = docsk[index]['bmi'];
                  String kategoriBmi = docsk[index]['katBmi'];

                  return beratBadan == "" ||
                          tinggiBadan == "" ||
                          kelamin == "" ||
                          tingkatAktivitas == ""
                      ? Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditDataScreens(
                                          kelamin: kelamin,
                                          aktivitas: tingkatAktivitas,
                                          tinggi: tinggiBadan,
                                          berat: beratBadan,
                                          umur: tahun)));
                            },
                            child: Container(
                                height: 40,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.green),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      "Lengkapi Data",
                                      style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: [
                              Text(
                                "Menu Menghitung Kalori",
                                style: GoogleFonts.roboto(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 130,
                                        height: 30,
                                        child: Text(
                                          "Hasil Hitung BMI:",
                                          style: GoogleFonts.roboto(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        width: 190,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                hasilBmi == 0
                                                    ? ""
                                                    : "${hasilBmi.toStringAsFixed(3)} " +
                                                        "(${kategoriBmi})",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 130,
                                        height: 40,
                                        child: Text(
                                          "Hasil Hitung BMR:",
                                          style: GoogleFonts.roboto(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        width: 160,
                                        height: 30,
                                        child: Text(
                                          hasilBmr == 0 ? "" : hasilBmr,
                                          style: GoogleFonts.roboto(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.male,
                                            size: 70,
                                            color: kelamin == "Perempuan"
                                                ? Colors.grey
                                                : Colors.blue,
                                          ),
                                          Text(
                                            "Laki-Laki",
                                            style: GoogleFonts.roboto(
                                              fontSize: 20,
                                              color: kelamin == "Perempuan"
                                                  ? Colors.grey
                                                  : Colors.blue,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.female,
                                            size: 70,
                                            color: kelamin == "Perempuan"
                                                ? Colors.pink
                                                : Colors.grey,
                                          ),
                                          Text(
                                            "Perempuan",
                                            style: GoogleFonts.roboto(
                                              fontSize: 20,
                                              color: kelamin == "Perempuan"
                                                  ? Colors.pink
                                                  : Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 110,
                                            height: 40,
                                            child: Text(
                                              "Usia",
                                              style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 110,
                                            height: 40,
                                            child: Text(
                                              "Tinggi Badan",
                                              style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 110,
                                            height: 40,
                                            child: Text(
                                              "Berat Badan",
                                              style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 110,
                                            height: 40,
                                            child: Text(
                                              "Aktivitas",
                                              style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 140,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 3)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "$usia Tahun",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 140,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 3)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "$tinggiBadan CM",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 140,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 3)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "$beratBadan KG",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 140,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 3)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "$tingkatAktivitas",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await HitungBmi(
                                              double.parse(tinggiBadan),
                                              double.parse(beratBadan));

                                          await hitungBmr(
                                              double.parse(beratBadan),
                                              double.parse(tinggiBadan),
                                              usia,
                                              kelamin,
                                              tingkatAktivitas);

                                          FirebaseFirestore.instance
                                              .collection("akun")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            'bmi': Bmi,
                                            'bmr': Bmr,
                                            'hasilBmr': kal,
                                            'katBmi': katBmi,
                                            'myAge': usia
                                          });
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 130,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Colors.green),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Center(
                                                child: Text(
                                                  "Hitung",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditDataScreens(
                                                          kelamin: kelamin,
                                                          aktivitas:
                                                              tingkatAktivitas,
                                                          tinggi: tinggiBadan,
                                                          berat: beratBadan,
                                                          umur: tahun)));
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 130,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Colors.green),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Center(
                                                child: Text(
                                                  "Edit Data",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        );
                });
          }
        });
  }
}
