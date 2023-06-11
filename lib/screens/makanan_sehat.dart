import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:wearprojs/const/yy.dart';

import 'package:wearprojs/login.dart';

import '../const/firebase_const.dart';

import 'package:http/http.dart' as http;

import '../model/user_model.dart';

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
                final calorie =
                    snapshot.data.docs[index]['hasilBmr'].toString();
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(calorie.toString()),
                      TextButton(
                          onPressed: () async {
                            try {
                              setState(() {
                                isLoading = true;
                              });

                              response = await dio.get(
                                  "https://low-carb-recipes.p.rapidapi.com/search?maxCalories=${calorie.toString()}&limit=2",
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
                            }
                            ;
                          },
                          child: Text("cari")),
                      isLoading == true
                          ? CircularProgressIndicator()
                          : ListView.builder(
                              itemCount: food.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 30),
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 130,
                                          width: 130,
                                          child: Image.network(
                                            food[index]['image'],
                                            fit: BoxFit.cover,
                                          ),
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
                                              width: 200,
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                      child: Text(
                                                          food[index]['name'])),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                "Calori : ${food[index]['nutrients']['caloriesKCal']}"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 80,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Text(
                                                  "Add",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
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
                );
              });
        });
  }
}
