import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:wearprojs/screens/catatan_harian/kalori_harian.dart';
import 'package:wearprojs/screens/catatan_harian/makanan_harian.dart';
import 'package:wearprojs/screens/catatan_harian/olahraga_harian.dart';
import 'package:intl/intl.dart';

class CatatanHarian extends StatefulWidget {
  const CatatanHarian({super.key});

  @override
  State<CatatanHarian> createState() => _CatatanHarianState();
}

class _CatatanHarianState extends State<CatatanHarian> {
  @override
  Widget build(BuildContext context) {
    DateTime tsdate = DateTime.now();
    String dateAdd = DateFormat.yMd().format(tsdate);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
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
                          String hasilBmr = docsk[index]['hasilBmr'].toString();
                          return Text(
                            "Kebutuhan kalori harian : " + hasilBmr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        });
                  }
                }),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MakananHarianScreens()));
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
                                    "Makanan hari ini",
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
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OlahragaHarianScreens()));
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
                                    "Olahraga hari ini",
                                    style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
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
                    return Text("no Data");
                  }
                  final doc = snapshot.data.docs;

                  var kaloriHariIni = List.generate(doc.length, (index) {
                    double x = doc[index]['calori'];
                    String z = x.toStringAsFixed(0);
                    int a = int.parse(z);

                    return a;
                  }).fold(0, (p, c) => p + c);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              KaloriHarianScreens()));
                                },
                                child: Text(
                                  "Detai kalori",
                                  style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.green,
                            )
                          ],
                        ),
                      ),
                      Text(
                        "Kalori terbakar hari ini : ${kaloriHariIni.toStringAsFixed(0)}",
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
