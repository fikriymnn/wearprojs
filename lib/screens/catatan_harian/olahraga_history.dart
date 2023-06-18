import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OlahragaHistoryScreens extends StatefulWidget {
  const OlahragaHistoryScreens({super.key});

  @override
  State<OlahragaHistoryScreens> createState() => _OlahragaHistoryScreensState();
}

class _OlahragaHistoryScreensState extends State<OlahragaHistoryScreens> {
  TextEditingController dateController = TextEditingController();
  String addDate = "";
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
              Container(
                height: 40,
                child: TextField(
                  controller: dateController,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'cari berdasarkan tanggal'),
                  onChanged: (value) {
                    setState(() {
                      addDate = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('akun')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('olahraga')
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

                          if (addDate.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                          }
                          if (date.toString().startsWith(addDate)) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                          }
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
