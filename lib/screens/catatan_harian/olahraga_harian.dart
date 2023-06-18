import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wearprojs/screens/catatan_harian/olahraga_history.dart';

class OlahragaHarianScreens extends StatefulWidget {
  const OlahragaHarianScreens({super.key});

  @override
  State<OlahragaHarianScreens> createState() => _OlahragaHarianScreensState();
}

class _OlahragaHarianScreensState extends State<OlahragaHarianScreens> {
  @override
  Widget build(BuildContext context) {
    DateTime tsdate = DateTime.now();
    String dateAdd = DateFormat.yMd().format(tsdate);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Olahraga Harian",
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
                          builder: (context) => OlahragaHistoryScreens()));
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
                      .collection('olahraga')
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
                          String name = snapshot.data.docs[index]['name'];
                          String date = snapshot.data.docs[index]['date'];
                          String instruksi =
                              snapshot.data.docs[index]['instruksi'];
                          String kesulitan =
                              snapshot.data.docs[index]['kesulitan'];

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
                                            name,
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
                                      "Kesulitan : $kesulitan",
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
                                            instruksi,
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
                                    Text(
                                      "Ditambahkan : $date",
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
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
