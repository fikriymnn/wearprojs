import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MakananHistoryScreens extends StatefulWidget {
  const MakananHistoryScreens({super.key});

  @override
  State<MakananHistoryScreens> createState() => _MakananHistoryScreensState();
}

class _MakananHistoryScreensState extends State<MakananHistoryScreens> {
  TextEditingController dateController = TextEditingController();
  String addDate = "";
  DateTime _selectDate = DateTime.now();

  String selectedDateText(select) {
    return DateFormat.yMd().format(select);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Makanan Harian",
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
                onTap: () async {
                  DateTime? pickDate = await showDatePicker(
                      context: context,
                      initialDate: _selectDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000));

                  if (pickDate != null) {
                    setState(() {
                      _selectDate = pickDate;
                      addDate = selectedDateText(_selectDate);
                    });
                  }
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
                          "Pilih Tanggal",
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
                      .collection('makanan')
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
                          String image = snapshot.data.docs[index]['image'];
                          double kalori = snapshot.data.docs[index]['kalori'];

                          if (addDate.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ExtendedImage.network(
                                      image,
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
                                          "Calori : $kalori",
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
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
                                    ))
                                  ],
                                ),
                              ),
                            );
                          }

                          if (date.toString().startsWith(addDate)) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 130,
                                      width: 130,
                                      child: Image.network(
                                        image,
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
                                          "Calori : $kalori",
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
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
                                    ))
                                  ],
                                ),
                              ),
                            );
                          }
                          return Container();
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
