import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:wearprojs/const/snack_bar.dart';
import 'package:intl/intl.dart';

class EditDataScreens extends StatefulWidget {
  const EditDataScreens(
      {super.key,
      required this.kelamin,
      required this.aktivitas,
      required this.tinggi,
      required this.berat,
      required this.umur});
  final String kelamin, aktivitas, tinggi, berat;
  final DateTime umur;

  @override
  State<EditDataScreens> createState() => _EditDataScreensState();
}

class _EditDataScreensState extends State<EditDataScreens> {
  DateTime _selectedDate = DateTime.now();

  String? selectedTujuan;
  String? selectedKelamin;
  String? selectedAktivitas;

  TextEditingController _beratBadanCtrl = TextEditingController();
  TextEditingController _tinggiBadanCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState

    selectedKelamin = widget.kelamin;
    selectedAktivitas = widget.aktivitas;
    _selectedDate = widget.umur;
    _beratBadanCtrl = TextEditingController(text: widget.berat);
    _tinggiBadanCtrl = TextEditingController(text: widget.tinggi);

    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
      }
    });
  }

  Future updateDataUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    try {
      // update data user
      await FirebaseFirestore.instance
          .collection('akun')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'beratBadan': _beratBadanCtrl.text,
        'tinggiBadan': _tinggiBadanCtrl.text,
        'kelamin': selectedKelamin.toString(),
        'tglLahir': _selectedDate,
        'tingkatAktivitas': selectedAktivitas.toString()
      });
      showSnackBar(
        context,
        'Akun telah diperbarui!',
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  String selectedDateText(select) {
    return DateFormat.yMd().format(select);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Edit Data",
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                updateDataUser();
              },
              child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.green),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "Edit",
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                    ),
                  )),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Jenis Kelamin",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildSelectorKelamin(
                        context: context,
                        name: 'Laki - Laki',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildSelectorKelamin(
                        context: context,
                        name: 'Perempuan',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Berat Badan",
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          _buildTextField2(
                              controller: _beratBadanCtrl,
                              labelText: "Berat Badan (KG)",
                              validator: (value) {
                                return null;
                              }),
                        ],
                      ),
                    )),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Tinggi Badan",
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          _buildTextField2(
                              controller: _tinggiBadanCtrl,
                              labelText: "Tinggi Badan (CM)",
                              validator: (value) {
                                return null;
                              }),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bagaimana Tingkat Aktivitas Anda?",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSelectorAktivitas(
                          name: "Jarang Sekali", subtitle: ""),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: _buildSelectorAktivitas(
                          name: "Sedikit Aktif", subtitle: ""),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child:
                          _buildSelectorAktivitas(name: "Aktif", subtitle: ""),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: _buildSelectorAktivitas(
                          name: "Sangat Aktif", subtitle: ""),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tanggal Lahir Anda?",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        DateTime? pickDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000));

                        if (pickDate != null) {
                          setState(() {
                            _selectedDate = pickDate;
                          });
                        }
                      },
                      child: Container(
                          height: 35,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.green),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Center(
                              child: Text(
                                "Pilih Tanggal",
                                style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "${DateFormat("dd/MMMM/yyyy").format(_selectedDate)}",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? labelText,
    FormFieldValidator<String>? validator,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        validator: validator,
        controller: controller,
      ),
    );
  }

  Widget _buildTextField2({
    String? labelText,
    FormFieldValidator<String>? validator,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        style: GoogleFonts.rubik(
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.green),
              borderRadius: BorderRadius.circular(5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.green),
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: labelText,
            hintStyle: GoogleFonts.rubik(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500))),
        validator: validator,
        controller: controller,
      ),
    );
  }

  Widget _buildSelectorTujuan({
    BuildContext? context,
    required String name,
  }) {
    final isActive = name == selectedTujuan;

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey : Colors.transparent,
        border: Border.all(
          width: 0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: RadioListTile(
        value: name,
        activeColor: Colors.white,
        groupValue: selectedTujuan,
        onChanged: (String? v) {
          setState(() {
            selectedTujuan = v;
          });
        },
        title: Text(
          name,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorKelamin({
    BuildContext? context,
    required String name,
  }) {
    final isActive = name == selectedKelamin;

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.transparent,
        border: Border.all(
          width: 1,
          color: isActive ? Colors.green : Colors.black,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: RadioListTile(
        value: name,
        activeColor: Colors.white,
        groupValue: selectedKelamin,
        onChanged: (String? v) {
          setState(() {
            selectedKelamin = v;
          });
        },
        title: Text(
          name,
          style: GoogleFonts.rubik(
              textStyle: TextStyle(
                  color: isActive ? Colors.white : Colors.black,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _buildSelectorAktivitas(
      {BuildContext? context, required String name, required String subtitle}) {
    final isActive = name == selectedAktivitas;

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.transparent,
        border: Border.all(
          width: 1,
          color: isActive ? Colors.green : Colors.black,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: RadioListTile(
        value: name,
        activeColor: Colors.white,
        groupValue: selectedAktivitas,
        onChanged: (String? v) {
          setState(() {
            selectedAktivitas = v;
          });
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.rubik(
                  textStyle: TextStyle(
                      color: isActive ? Colors.white : Colors.black,
                      fontSize: 13,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
