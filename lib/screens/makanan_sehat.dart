import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:wearprojs/const/notif_service.dart';
import 'package:wearprojs/const/snack_bar.dart';

import 'package:extended_image/extended_image.dart';

import 'package:intl/intl.dart';

class MakananSehatScreens extends StatefulWidget {
  const MakananSehatScreens({super.key});

  @override
  State<MakananSehatScreens> createState() => _MakananSehatScreensState();
}

class _MakananSehatScreensState extends State<MakananSehatScreens> {
  Response? response;
  Response? response2;
  Response? response3;

  var dio = Dio();
  List food = [];
  List foodPagi = [];
  List foodSiang = [];
  List foodMalam = [];
  dynamic kaloriSiang = 0;
  dynamic kaloriPagi = 0;
  dynamic kaloriMalam = 0;
  bool isLoading = false;
  bool submitLoading = false;

  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController cariMakan = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }

  void getData() async {
    try {
      DocumentSnapshot dataDoc = await FirebaseFirestore.instance
          .collection("akun")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (dataDoc.hashCode == null) {
        setState(() {
          kaloriSiang = 0;
          kaloriMalam = 0;
          kaloriPagi = 0;
        });
      } else {
        kaloriSiang = dataDoc.get("kaloriSiang");
        kaloriPagi = dataDoc.get("kaloriPagi");
        kaloriMalam = dataDoc.get("kaloriMalam");

        if (kaloriPagi != "0") {
          await searchFoodPagi();
        } else {
          null;
        }

        if (kaloriSiang != "0") {
          await searchFoodSiang();
        } else {
          null;
        }

        if (kaloriMalam != "0") {
          searchFoodMalam();
        } else {
          null;
        }

        // if (kaloriSiang != "0" && kaloriMalam != "0" && kaloriPagi != "0") {
        //   searchFoodSiang();
        //   searchFoodMalam();
        //   searchFoodPagi();
        // } else if (kaloriSiang == "0" &&
        //     kaloriMalam != "0" &&
        //     kaloriPagi != "0") {
        //   searchFoodMalam();
        //   searchFoodPagi();
        // } else if (kaloriSiang != "0" &&
        //     kaloriMalam == "0" &&
        //     kaloriPagi != "0") {
        //   searchFoodSiang();
        //   searchFoodPagi();
        // } else if (kaloriSiang != "0" &&
        //     kaloriMalam != "0" &&
        //     kaloriPagi == "0") {
        //   searchFoodSiang();
        //   searchFoodMalam();
        // } else if (kaloriSiang == "0" &&
        //     kaloriMalam == "0" &&
        //     kaloriPagi != "0") {
        //   searchFoodPagi();
        // } else if (kaloriSiang != "0" &&
        //     kaloriMalam == "0" &&
        //     kaloriPagi == "0") {
        //   searchFoodSiang();
        // } else if (kaloriSiang == "0" &&
        //     kaloriMalam != "0" &&
        //     kaloriPagi == "0") {
        //   searchFoodMalam();
        // }
      }
    } catch (e) {}
  }

  searchFoodSiang() async {
    try {
      setState(() {
        isLoading = true;
      });

      response = await dio.get(
          "https://low-carb-recipes.p.rapidapi.com/search?maxCalories=${kaloriSiang}&limit=5",
          options: Options(headers: {
            'X-RapidAPI-Key':
                'd9812ad25dmshc5e4602b87baf3dp1db246jsn08b1ed27f455',
            'X-RapidAPI-Host': 'low-carb-recipes.p.rapidapi.com'
          }));
      setState(() {
        foodSiang = response!.data;

        isLoading = false;
      });
    } catch (e) {
      SnackBar(content: Text("Error"));
      setState(() {
        isLoading = false;
      });
    }
  }

  searchFoodPagi() async {
    try {
      setState(() {
        isLoading = true;
      });

      response = await dio.get(
          "https://low-carb-recipes.p.rapidapi.com/search?maxCalories=${kaloriPagi}&limit=5",
          options: Options(headers: {
            'X-RapidAPI-Key':
                'd9812ad25dmshc5e4602b87baf3dp1db246jsn08b1ed27f455',
            'X-RapidAPI-Host': 'low-carb-recipes.p.rapidapi.com'
          }));
      setState(() {
        food = response!.data;

        isLoading = false;
      });
    } catch (e) {
      SnackBar(content: Text("Error"));
      setState(() {
        isLoading = false;
      });
    }
  }

  searchFoodMalam() async {
    try {
      setState(() {
        isLoading = true;
      });

      response = await dio.get(
          "https://low-carb-recipes.p.rapidapi.com/search?maxCalories=${kaloriMalam}&limit=5",
          options: Options(headers: {
            'X-RapidAPI-Key':
                'd9812ad25dmshc5e4602b87baf3dp1db246jsn08b1ed27f455',
            'X-RapidAPI-Host': 'low-carb-recipes.p.rapidapi.com'
          }));
      setState(() {
        foodMalam = response!.data;

        isLoading = false;
      });
    } catch (e) {
      SnackBar(content: Text("Error"));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime tsdate = DateTime.now();
    String dateAdd = DateFormat.yMd().format(tsdate);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('akun')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('calori')
            .where('date', isEqualTo: dateAdd)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          // if it has data, do your thing:
          final doc = snapshot.data.docs;

          var kaloriHariIni = List.generate(doc.length, (index) {
            double x = doc[index]['calori'];
            String z = x.toStringAsFixed(0);
            int a = int.parse(z);

            return a;
          }).fold(0, (p, c) => p + c);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
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
                                double Calories =
                                    snapshot.data.docs[index]['kalori'];
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
                                  ],
                                );
                              });
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("akun")
                          .where('uid',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text("no data"));
                        } else {
                          var docsk = snapshot.data!.docs;

                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: docsk.length,
                              itemBuilder: (context, index) {
                                double hasilBmr = docsk[index]['hasilBmr'];
                                final heartRate = double.parse(
                                    docsk[index]['heartRate'].toString());
                                int umur = docsk[index]['myAge'];
                                var batasHeartRate = 220 - umur;
                                var kaloriHPagi = 20;
                                var kaloriHSiang = 0;
                                var kaloriHMalam = 0;

                                print(batasHeartRate);

                                if (heartRate >= batasHeartRate) {
                                  NotificationService().showNotification(
                                    title: "Peringatan !!",
                                    body: "Detah jantung sudah melebihi batas",
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kebutuhan kalori harian : " +
                                          hasilBmr.toStringAsFixed(3),
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Container(
                                    //   child: Row(
                                    //     children: [
                                    //       InkWell(
                                    //         onTap: () async {
                                    //           try {
                                    //             setState(() {
                                    //               isLoading = true;
                                    //             });
                                    //             if (kaloriHPagi != 0) {
                                    //               response = await dio.get(
                                    //                   "https://low-carb-recipes.p.rapidapi.com/search?maxCalories=${kaloriHPagi}&limit=5",
                                    //                   options:
                                    //                       Options(headers: {
                                    //                     'X-RapidAPI-Key':
                                    //                         'd9812ad25dmshc5e4602b87baf3dp1db246jsn08b1ed27f455',
                                    //                     'X-RapidAPI-Host':
                                    //                         'low-carb-recipes.p.rapidapi.com'
                                    //                   }));
                                    //               setState(() {
                                    //                 food = response!.data;

                                    //                 isLoading = false;
                                    //               });
                                    //             } else if (kaloriHPagi == 0) {
                                    //               setState(() {
                                    //                 food = [];

                                    //                 isLoading = false;
                                    //               });
                                    //             } else {
                                    //               setState(() {
                                    //                 isLoading = false;
                                    //               });
                                    //             }
                                    //             if (kaloriHSiang != 0) {
                                    //               response2 = await dio.get(
                                    //                   "https://low-carb-recipes.p.rapidapi.com/search?maxCalories=${kaloriHSiang}&limit=5",
                                    //                   options:
                                    //                       Options(headers: {
                                    //                     'X-RapidAPI-Key':
                                    //                         'd9812ad25dmshc5e4602b87baf3dp1db246jsn08b1ed27f455',
                                    //                     'X-RapidAPI-Host':
                                    //                         'low-carb-recipes.p.rapidapi.com'
                                    //                   }));
                                    //               setState(() {
                                    //                 foodSiang = response2!.data;

                                    //                 isLoading = false;
                                    //               });
                                    //             } else if (kaloriHSiang == 0) {
                                    //               setState(() {
                                    //                 foodSiang = [];

                                    //                 isLoading = false;
                                    //               });
                                    //             } else {
                                    //               setState(() {
                                    //                 isLoading = false;
                                    //               });
                                    //             }
                                    //             if (kaloriHMalam != 0) {
                                    //               response3 = await dio.get(
                                    //                   "https://low-carb-recipes.p.rapidapi.com/search?maxCalories=${kaloriHMalam}&limit=5",
                                    //                   options:
                                    //                       Options(headers: {
                                    //                     'X-RapidAPI-Key':
                                    //                         'd9812ad25dmshc5e4602b87baf3dp1db246jsn08b1ed27f455',
                                    //                     'X-RapidAPI-Host':
                                    //                         'low-carb-recipes.p.rapidapi.com'
                                    //                   }));
                                    //               setState(() {
                                    //                 foodMalam = response3!.data;
                                    //                 isLoading = false;
                                    //               });
                                    //             } else if (kaloriHMalam == 0) {
                                    //               setState(() {
                                    //                 foodMalam = [];

                                    //                 isLoading = false;
                                    //               });
                                    //             } else {
                                    //               setState(() {
                                    //                 isLoading = false;
                                    //               });
                                    //             }
                                    //           } catch (e) {
                                    //             ScaffoldMessenger.of(context)
                                    //                 .showSnackBar(SnackBar(
                                    //               content: Text("error"),
                                    //             ));
                                    //             setState(() {
                                    //               isLoading = false;
                                    //             });
                                    //           }
                                    //         },
                                    //         child: Container(
                                    //           width: 80,
                                    //           height: 40,
                                    //           decoration: BoxDecoration(
                                    //               color: Colors.green,
                                    //               borderRadius:
                                    //                   BorderRadius.circular(5)),
                                    //           child: Center(
                                    //               child: submitLoading
                                    //                   ? CircularProgressIndicator(
                                    //                       color: Colors.white,
                                    //                     )
                                    //                   : Text(
                                    //                       "Cari",
                                    //                       style: TextStyle(
                                    //                           color:
                                    //                               Colors.white),
                                    //                     )),
                                    //         ),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                );
                              });
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Makan Pagi",
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  isLoading == true
                      ? CircularProgressIndicator()
                      : ListView.builder(
                          itemCount: food.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ExtendedImage.network(
                                      food[index]['image'],
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                      cache: true,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 170,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                  child: Text(
                                                food[index]['name'],
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
                                          "Calori : ${food[index]['nutrients']['caloriesKCal']}",
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
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
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection("makanan")
                                                  .doc(id)
                                                  .set({
                                                'uid': id,
                                                'date': date,
                                                'name': food[index]['name'],
                                                'kalori': food[index]
                                                        ['nutrients']
                                                    ['caloriesKCal'],
                                                'image': food[index]['image']
                                              });
                                              setState(() {
                                                submitLoading = false;
                                              });
                                              showSnackBar(context,
                                                  "Berhasil ditambahkan");
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
                                                            color:
                                                                Colors.white),
                                                      )),
                                          ),
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            );
                          }),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Makan Siang",
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      itemCount: foodSiang.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ExtendedImage.network(
                                  foodSiang[index]['image'],
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                  cache: true,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 170,
                                      child: Row(
                                        children: [
                                          Flexible(
                                              child: Text(
                                            foodSiang[index]['name'],
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
                                      "Calori : ${foodSiang[index]['nutrients']['caloriesKCal']}",
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
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
                                              .collection("makanan")
                                              .doc(id)
                                              .set({
                                            'uid': id,
                                            'date': date,
                                            'name': foodSiang[index]['name'],
                                            'kalori': foodSiang[index]
                                                ['nutrients']['caloriesKCal'],
                                            'image': foodSiang[index]['image']
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
                                                  )),
                                      ),
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                        );
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Makan Malam",
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      itemCount: foodMalam.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ExtendedImage.network(
                                  foodMalam[index]['image'],
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                  cache: true,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 170,
                                      child: Row(
                                        children: [
                                          Flexible(
                                              child: Text(
                                            foodMalam[index]['name'],
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
                                      "Calori : ${foodMalam[index]['nutrients']['caloriesKCal']}",
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
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
                                              .collection("makanan")
                                              .doc(id)
                                              .set({
                                            'uid': id,
                                            'date': date,
                                            'name': foodMalam[index]['name'],
                                            'kalori': foodMalam[index]
                                                ['nutrients']['caloriesKCal'],
                                            'image': foodMalam[index]['image']
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
                                                  )),
                                      ),
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        });
  }
}
