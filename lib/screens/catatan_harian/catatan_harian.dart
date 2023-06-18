import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
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

                  var kaloriHariIni = List.generate(doc.length,
                          (index) => snapshot.data.docs[index]['calori'])
                      .reduce((a, b) => a + b);
                  return Text(
                    "Kalori terbakar hari ini : $kaloriHariIni",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  );

                  // if it has data, do your thing:
                })
          ],
        ),
      ),
    );
  }
}
