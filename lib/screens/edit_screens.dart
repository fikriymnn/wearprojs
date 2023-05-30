import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:wearprojs/const/snack_bar.dart';

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
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();

  String? selectedTujuan;
  String? selectedKelamin;
  String? selectedAktivitas;

  TextEditingController _beratBadanCtrl = TextEditingController();
  TextEditingController _tinggiBadanCtrl = TextEditingController();

  var _obscureText = true;
  bool _isLoading = false;
  final _passFocusNode = FocusNode();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        updateDataUser();
                      },
                      child: Container(
                          height: 40,
                          width: 130,
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
                    Text(
                      "Apakah Jenis Kelamin Anda",
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
              _buildSelectorKelamin(
                context: context,
                name: 'Laki - Laki',
              ),
              SizedBox(height: 10),
              _buildSelectorKelamin(
                context: context,
                name: 'Perempuan',
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
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
              _buildSelectorAktivitas(
                  name: "Jarang Sekali",
                  subtitle:
                      "Kegiatan sehari hari yang membutuhkan sedikit usaha seperti beristirahat, kerja di belakang meja, atau mengemudi."),
              SizedBox(
                height: 10,
              ),
              _buildSelectorAktivitas(
                  name: "Sedikit Aktif",
                  subtitle:
                      "Kegiatan sehari hari yang membutuhkan beberapa upaya seperti berdiri secara berkala, pekerjaan rumah, atau latihan ringan"),
              SizedBox(
                height: 10,
              ),
              _buildSelectorAktivitas(
                  name: "Aktif",
                  subtitle:
                      "Kegiatan sehari hari yang membutuhkan upaya yang wajar seperti berdiri, kerja fisik atau olahraga ringan secara teratur."),
              SizedBox(
                height: 10,
              ),
              _buildSelectorAktivitas(
                  name: "Sangat Aktif",
                  subtitle:
                      "Kegiatan sehari hari yang membutuhkan upaya yang tinggi seperti pekerjaan konstruksi atau olahraga berat secara teratur."),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Berapakah Berat Badan Anda Saat Ini?",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                  labelText: "Berat Badan Anda Dalam Satuan Kilogram (KG)",
                  validator: (value) {}),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Berapakah Tinggi Badan Anda Saat Ini?",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                  labelText: "Tinggi Badan Anda Dalam Satuan Sentimeter (CM)",
                  validator: (value) {}),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
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
              SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedRange:
                    PickerDateRange(_selectedDate, _selectedDate),
              ),
              Text('Selected date: $_selectedDate'),
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
        decoration: InputDecoration(
          labelText: labelText,
        ),
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
        color: isActive ? Colors.grey : Colors.transparent,
        border: Border.all(
          width: 0,
        ),
        borderRadius: BorderRadius.circular(8.0),
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
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
          ),
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
        color: isActive ? Colors.grey : Colors.transparent,
        border: Border.all(
          width: 0,
        ),
        borderRadius: BorderRadius.circular(8.0),
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
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                  color: isActive ? Colors.white : Colors.black, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
