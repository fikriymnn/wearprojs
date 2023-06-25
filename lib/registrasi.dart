import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wearprojs/auth.dart';

import 'package:wearprojs/verifikasi.dart';

import 'const/snack_bar.dart';

class RegistrasiScreens extends StatefulWidget {
  RegistrasiScreens({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _RegistrasiScreensState createState() => _RegistrasiScreensState();
}

class _RegistrasiScreensState extends State<RegistrasiScreens> {
  final _formKey = GlobalKey<FormState>();

  String? selectedTujuan;
  String? selectedKelamin;
  String? selectedAktivitas;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _password = TextEditingController();
  var _obscureText = true;
  bool _isLoading = false;
  final _passFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void signUpUser() async {
    // set loading to true
    _formKey.currentState!.validate();
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        createdAt: Timestamp.now(),
        password: _password.text,
        email: _email.text,
        nama: _nama.text);

    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => VerifikasiScreen(),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Registrasi",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Nama Anda",
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
                  controller: _nama,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukkan nama anda';
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
                      hintText: "Nama",
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
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    signUpUser();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Registrasi",
                              style: GoogleFonts.rubik(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField({
  //   String? labelText,
  //   FormFieldValidator<String>? validator,
  //   TextEditingController? controller,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 20.0),
  //     child: TextFormField(
  //       decoration: InputDecoration(
  //         labelText: labelText,
  //       ),
  //       validator: validator,
  //       controller: controller,
  //     ),
  //   );
  // }

  // Widget _buildTextField2({
  //   String? labelText,
  //   FormFieldValidator<String>? validator,
  //   TextEditingController? controller,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 20.0),
  //     child: TextFormField(
  //       keyboardType: TextInputType.number,
  //       decoration: InputDecoration(
  //         labelText: labelText,
  //       ),
  //       validator: validator,
  //       controller: controller,
  //     ),
  //   );
  // }

  // Widget _buildSelectorTujuan({
  //   BuildContext? context,
  //   required String name,
  // }) {
  //   final isActive = name == selectedTujuan;

  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 200),
  //     curve: Curves.easeInOut,
  //     decoration: BoxDecoration(
  //       color: isActive ? Colors.grey : Colors.transparent,
  //       border: Border.all(
  //         width: 0,
  //       ),
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //     child: RadioListTile(
  //       value: name,
  //       activeColor: Colors.white,
  //       groupValue: selectedTujuan,
  //       onChanged: (String? v) {
  //         setState(() {
  //           selectedTujuan = v;
  //         });
  //       },
  //       title: Text(
  //         name,
  //         style: TextStyle(
  //           color: isActive ? Colors.white : Colors.black,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildSelectorKelamin({
  //   BuildContext? context,
  //   required String name,
  // }) {
  //   final isActive = name == selectedKelamin;

  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 200),
  //     curve: Curves.easeInOut,
  //     decoration: BoxDecoration(
  //       color: isActive ? Colors.grey : Colors.transparent,
  //       border: Border.all(
  //         width: 0,
  //       ),
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //     child: RadioListTile(
  //       value: name,
  //       activeColor: Colors.white,
  //       groupValue: selectedKelamin,
  //       onChanged: (String? v) {
  //         setState(() {
  //           selectedKelamin = v;
  //         });
  //       },
  //       title: Text(
  //         name,
  //         style: TextStyle(
  //           color: isActive ? Colors.white : Colors.black,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildSelectorAktivitas(
  //     {BuildContext? context, required String name, required String subtitle}) {
  //   final isActive = name == selectedAktivitas;

  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 200),
  //     curve: Curves.easeInOut,
  //     decoration: BoxDecoration(
  //       color: isActive ? Colors.grey : Colors.transparent,
  //       border: Border.all(
  //         width: 0,
  //       ),
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //     child: RadioListTile(
  //       value: name,
  //       activeColor: Colors.white,
  //       groupValue: selectedAktivitas,
  //       onChanged: (String? v) {
  //         setState(() {
  //           selectedAktivitas = v;
  //         });
  //       },
  //       title: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             name,
  //             style: TextStyle(
  //               color: isActive ? Colors.white : Colors.black,
  //             ),
  //           ),
  //           Text(
  //             subtitle,
  //             style: TextStyle(
  //                 color: isActive ? Colors.white : Colors.black, fontSize: 12),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
