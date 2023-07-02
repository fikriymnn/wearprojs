import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wearprojs/screens/catatan_harian/kalori_history.dart';

class KaloriHarianScreens extends StatefulWidget {
  const KaloriHarianScreens({super.key});

  @override
  State<KaloriHarianScreens> createState() => _KaloriHarianScreensState();
}

class _KaloriHarianScreensState extends State<KaloriHarianScreens> {
  @override
  Widget build(BuildContext context) {
    DateTime tsdate = DateTime.now();
    String dateAdd = DateFormat.yMd().format(tsdate);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Kalori Harian",
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KaloriHistoryScreens()));
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
                          "History",
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('akun')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('calori')
                      .where('date', isEqualTo: dateAdd)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text("no data"));
                    }
                    // if it has data, do your thing:
                    final doc = snapshot.data.docs;
                    return ListView.builder(
                        itemCount: doc.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          double calori = snapshot.data.docs[index]['calori'];
                          String date = snapshot.data.docs[index]['date'];
                          String time = snapshot.data.docs[index]['time'];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Calori : ${calori}",
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Tanggal : $date",
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Waktu : $time",
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
