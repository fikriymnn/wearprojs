import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Registrasi extends StatefulWidget {
  Registrasi({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _RegistrasiState createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRole = 'Writer';
  final TextEditingController _umurCtrl = TextEditingController();
  final TextEditingController _beratBadanCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final steps = [
      CoolStep(
        isHeaderEnabled: false,
        title: '',
        subtitle: '',
        content: Column(
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
        validation: () {},
      ),
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
            _buildSelector(
              context: context,
              name: 'Pengurangan Berat Badan',
            ),
            SizedBox(height: 10),
            _buildSelector(
              context: context,
              name: 'Pertahankan Berat Badan Saya',
            ),
            SizedBox(height: 10),
            _buildSelector(
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
              _buildSelector(
                context: context,
                name: 'Laki - Laki',
              ),
              SizedBox(height: 10),
              _buildSelector(
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
              _buildTextField(
                  controller: _umurCtrl,
                  labelText: "Umur",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Umur is required';
                    }
                    return null;
                  })
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
              _buildSelector2(
                  name: "Jarang Sekali",
                  subtitle:
                      "Kegiatan sehari hari yang membutuhkan sedikit usaha seperti beristirahat, kerja di belakang meja, atau mengemudi."),
              SizedBox(
                height: 10,
              ),
              _buildSelector2(
                  name: "Sedikit Aktif",
                  subtitle:
                      "Kegiatan sehari hari yang membutuhkan beberapa upaya seperti berdiri secara berkala, pekerjaan rumah, atau latihan ringan"),
              SizedBox(
                height: 10,
              ),
              _buildSelector2(
                  name: "Aktif",
                  subtitle:
                      "Kegiatan sehari hari yang membutuhkan upaya yang wajar seperti berdiri, kerja fisik atau olahraga ringan secara teratur."),
              SizedBox(
                height: 10,
              ),
              _buildSelector2(
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
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Berapakah Berat Badan Anda Saat Ini?",
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
              _buildTextField2(
                  controller: _beratBadanCtrl,
                  labelText: "Berat Badan Anda Dalam Satuan Kilogram (KG)",
                  validator: (value) {}),
            ],
          ),
          validation: () {})
    ];

    final stepper = CoolStepper(
      showErrorSnackbar: false,
      onCompleted: () {
        print('Steps completed!');
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

  Widget _buildSelector({
    BuildContext? context,
    required String name,
  }) {
    final isActive = name == selectedRole;

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
        groupValue: selectedRole,
        onChanged: (String? v) {
          setState(() {
            selectedRole = v;
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

  Widget _buildSelector2(
      {BuildContext? context, required String name, required String subtitle}) {
    final isActive = name == selectedRole;

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
        groupValue: selectedRole,
        onChanged: (String? v) {
          setState(() {
            selectedRole = v;
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
