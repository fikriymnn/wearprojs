import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:wearprojs/const/notif_service.dart';
import 'package:wearprojs/const/snack_bar.dart';
import 'package:intl/intl.dart';

class DaftarOlahraga extends StatefulWidget {
  const DaftarOlahraga({super.key});

  @override
  State<DaftarOlahraga> createState() => _DaftarOlahragaState();
}

class _DaftarOlahragaState extends State<DaftarOlahraga> {
  Response? response;

  var dio = Dio();

  List fitnes = [];
  bool isLoading = false;
  bool submitLoading = false;
  String? tingkat;
  @override
  void initState() {
    // TODO: implement initState

    searchFitnes();
    super.initState();
  }

  User? user = FirebaseAuth.instance.currentUser;
  searchFitnes() async {
    try {
      setState(() {
        isLoading = true;
      });

      response = await dio.get(
          "https://exercises-by-api-ninjas.p.rapidapi.com/v1/exercises?",
          options: Options(headers: {
            'X-RapidAPI-Key':
                'd9812ad25dmshc5e4602b87baf3dp1db246jsn08b1ed27f455',
            'X-RapidAPI-Host': 'exercises-by-api-ninjas.p.rapidapi.com'
          }));

      setState(() {
        fitnes = response!.data;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("error"),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(
            "Semua",
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          value: ""),
      DropdownMenuItem(
          child: Text(
            "Pemula",
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          value: "difficulty=beginner"),
      DropdownMenuItem(
          child: Text(
            "Menegah",
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          value: "difficulty=intermediate"),
      DropdownMenuItem(
          child: Text(
            "Ahli",
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          value: "difficulty=expert"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Container(
              child: StreamBuilder(
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
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final heartRate = double.parse(snapshot
                              .data.docs[index]['heartRate']
                              .toString());
                          int umur = snapshot.data.docs[index]['myAge'];
                          var batasHeartRate = 220 - umur;
                          double Calories = snapshot.data.docs[index]['kalori'];
                          double hasilBmr =
                              snapshot.data.docs[index]['hasilBmr'];
                          print(batasHeartRate);

                          if (heartRate >= batasHeartRate) {
                            NotificationService().showNotification(
                              title: "Peringatan !!",
                              body: "Detah jantung sudah melebihi batas",
                            );
                          }

                          return Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Text(
                                      "Detak Jantung : ",
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      heartRate.toString(),
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Text(
                                      "Kalori : ",
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      Calories.toStringAsFixed(2),
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Kebutuhan kalori harian : " +
                                    hasilBmr.toStringAsFixed(3),
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          );
                        });
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: tingkat,
                          hint: Text(
                            "Tingkat",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          items: dropdownItems,
                          onChanged: (value) {
                            setState(() {
                              tingkat = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () async {
                      if (tingkat == null) {
                        showSnackBar(context, "Pilih tingkat terlebih dahulu");
                      } else {
                        try {
                          setState(() {
                            isLoading = true;
                          });

                          response = await dio.get(
                              "https://exercises-by-api-ninjas.p.rapidapi.com/v1/exercises?$tingkat",
                              options: Options(headers: {
                                'X-RapidAPI-Key':
                                    'd9812ad25dmshc5e4602b87baf3dp1db246jsn08b1ed27f455',
                                'X-RapidAPI-Host':
                                    'exercises-by-api-ninjas.p.rapidapi.com'
                              }));

                          setState(() {
                            fitnes = response!.data;
                            isLoading = false;
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("error"),
                          ));
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: submitLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Cari",
                                  style: TextStyle(color: Colors.white),
                                )),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: isLoading == true
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: fitnes.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Row(
                                      children: [
                                        Flexible(
                                            child: Text(
                                          fitnes[index]['name'],
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Kesulitan : ${fitnes[index]['difficulty']}",
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        Flexible(
                                            child: Text(
                                          fitnes[index]['instructions'],
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      DateTime tsdate = DateTime.now();
                                      String date =
                                          DateFormat.yMd().format(tsdate);
                                      var uuid = Uuid();
                                      var id = uuid.v4();

                                      try {
                                        setState(() {
                                          submitLoading = true;
                                        });

                                        FirebaseFirestore.instance
                                            .collection("akun")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection("olahraga")
                                            .doc(id)
                                            .set({
                                          'uid': id,
                                          'date': date,
                                          'name': fitnes[index]['name'],
                                          'kesulitan': fitnes[index]
                                              ['difficulty'],
                                          'instruksi': fitnes[index]
                                              ['instructions']
                                        });
                                        setState(() {
                                          submitLoading = false;
                                        });
                                        showSnackBar(
                                            context, "Berhasil ditambahkan");
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("error"),
                                        ));
                                      }
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: submitLoading
                                            ? CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : Text(
                                                "Add",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
            )
          ],
        ),
      ),
    );
  }
}
