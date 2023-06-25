import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
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

  var dio = Dio();
  List food = [];
  bool isLoading = false;
  bool submitLoading = false;

  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController cariMakan = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    searchFood("", "5");

    super.initState();
  }

  searchFood(calories, limit) async {
    try {
      setState(() {
        isLoading = true;
      });

      response = await dio.get(
          "https://low-carb-recipes.p.rapidapi.com/search?${calories}limit=$limit",
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("error"),
      ));
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

          double kaloriHariIni = List.generate(
                  doc.length, (index) => snapshot.data.docs[index]['calori'])
              .reduce((a, b) => a + b);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kalori di butuhkan : ",
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${kaloriHariIni.toStringAsFixed(2)}",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
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
                        Expanded(
                          child: Container(
                            height: 40,
                            child: TextField(
                              controller: cariMakan,
                              cursorColor: Colors.green,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Kalori'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () async {
                            try {
                              setState(() {
                                isLoading = true;
                              });

                              response = await dio.get(
                                  "https://low-carb-recipes.p.rapidapi.com/search?maxCalories=${cariMakan.text}&limit=10",
                                  options: Options(headers: {
                                    'X-RapidAPI-Key':
                                        'd9812ad25dmshc5e4602b87baf3dp1db246jsn08b1ed27f455',
                                    'X-RapidAPI-Host':
                                        'low-carb-recipes.p.rapidapi.com'
                                  }));

                              setState(() {
                                food = response!.data;
                                isLoading = false;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("error"),
                              ));
                              setState(() {
                                isLoading = false;
                              });
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
                          })
                ],
              ),
            ),
          );
        });
  }
}
