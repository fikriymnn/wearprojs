import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:wearprojs/auth.dart';
import 'package:wearprojs/btm_bar.dart';

import 'const/snack_bar.dart';

class RegistrasiScreens extends StatefulWidget {
  RegistrasiScreens({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _RegistrasiScreensState createState() => _RegistrasiScreensState();
}

class _RegistrasiScreensState extends State<RegistrasiScreens> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDate = '';
  String? selectedTujuan;
  String? selectedKelamin;
  String? selectedAktivitas;
  final TextEditingController _umurCtrl = TextEditingController();
  final TextEditingController _beratBadanCtrl = TextEditingController();
  final TextEditingController _tinggiBadanCtrl = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  var _obscureText = true;
  bool _isLoading = false;
  final _passFocusNode = FocusNode();

  late DatabaseReference dbRef;

  @override
  void initState() {
    // TODO: implement initState
    dbRef = FirebaseDatabase.instance.ref().child('akun');
    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      }
    });
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        createdAt: Timestamp.now(),
        password: _password.text,
        email: _email.text,
        aktivitas: selectedAktivitas.toString(),
        beratBadan: _beratBadanCtrl.text,
        kelamin: selectedKelamin.toString(),
        tanggalLahir: _selectedDate,
        tinggiBadan: _tinggiBadanCtrl.text,
        tujuan: selectedTujuan.toString());

    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BottomBarScreen(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      CoolStep(
        isHeaderEnabled: false,
        title: '',
        subtitle: '',
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Penyiapan Profil Anda",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 130),
                child: Text(
                  "Untuk memulai, kami akan menghitung AKG atau angka kecukupan gizi adnda. Ini adalah seberapa banyak makanan yang idealnya harus anda konsumsi tiap hari. AKG dipengaruhi oleh nutrisi, tingkat aktivitas, usia, tinggi, dan karakteristik lainnya yang unik untuk anda.",
                  style: GoogleFonts.roboto(
                    textStyle:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
        validation: () {},
      ),
      CoolStep(
          isHeaderEnabled: false,
          title: '',
          subtitle: 'subtitle',
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Email Anda",
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
                height: 10,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Masukkan email dengan benar';
                  } else {
                    return null;
                  }
                },
                style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: "Email",
                    hintStyle: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
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
                height: 10,
              ),
              TextFormField(
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  // _submitFormOnLogin();
                },
                controller: _password,
                focusNode: _passFocusNode,
                obscureText: _obscureText,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value!.isEmpty || value.length <= 5) {
                    return 'Masukkan password dengan benar';
                  } else {
                    return null;
                  }
                },
                style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.green,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: "Password",
                    hintStyle: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500))),
              ),
            ],
          ),
          validation: () {}),
      CoolStep(
        title: 'Select your role',
        subtitle: 'Choose a role that better defines you',
        isHeaderEnabled: false,
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tujuan Anda Menggunakan Aplikasi",
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
              height: 100,
            ),
            _buildSelectorTujuan(
              context: context,
              name: 'Pengurangan Berat Badan',
            ),
            SizedBox(height: 10),
            _buildSelectorTujuan(
              context: context,
              name: 'Pertahankan Berat Badan Saya',
            ),
            SizedBox(height: 10),
            _buildSelectorTujuan(
              context: context,
              name: 'Peningkatan Berat Badan',
            ),
          ],
        ),
        validation: () {},
      ),
      CoolStep(
          title: "",
          subtitle: "",
          isHeaderEnabled: false,
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
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
              ),
              SizedBox(
                height: 100,
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
            ],
          ),
          validation: () {}),
      CoolStep(
          title: "",
          subtitle: "",
          isHeaderEnabled: false,
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Berapakah Umur Anda?",
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
                height: 100,
              ),
              SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 4)),
                    DateTime.now().add(const Duration(days: 3))),
              ),
              Text('Selected date: $_selectedDate'),
            ],
          ),
          validation: () {}),
      CoolStep(
          title: "",
          subtitle: "",
          isHeaderEnabled: false,
          content: Column(
            children: [
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
                height: 100,
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
                      "Kegiatan sehari hari yang membutuhkan upaya yang tinggi seperti pekerjaan konstruksi atau olahraga berat secara teratur.")
            ],
          ),
          validation: () {}),
      CoolStep(
          title: "title",
          subtitle: "subtitle",
          isHeaderEnabled: false,
          content: Column(
            children: [
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
            ],
          ),
          validation: () {})
    ];

    final stepper = CoolStepper(
      showErrorSnackbar: false,
      onCompleted: () {
        if (_email == null) {
          return showSnackBar(context, "Email harus di isi");
        } else if (_password == null) {
          return showSnackBar(context, "Password harus di isi");
        } else if (selectedAktivitas == null) {
          return showSnackBar(context, "Aktivital harus di isi");
        } else if (_selectedDate == null) {
          return showSnackBar(context, "Tanggal lahir harus di isi");
        } else if (selectedKelamin == null) {
          return showSnackBar(context, "Kelamin harus di isi");
        } else if (selectedTujuan == null) {
          return showSnackBar(context, "Tujuan harus di isi");
        } else if (_tinggiBadanCtrl == null) {
          return showSnackBar(context, "Tinggi badan harus di isi");
        } else if (_beratBadanCtrl == null) {
          return showSnackBar(context, "Berat badan harus di isi");
        } else {
          signUpUser();
        }
      },
      steps: steps,
      config: CoolStepperConfig(
        backText: 'PREV',
      ),
    );

    return Scaffold(
      body: Container(
        child: stepper,
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
