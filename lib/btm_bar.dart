import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:wearprojs/drawer_custom.dart';

import 'package:wearprojs/screens/catatan_harian/catatan_harian.dart';
import 'package:wearprojs/screens/daftar_olahraga.dart';
import 'package:wearprojs/screens/hitung_kalori.dart';
import 'package:wearprojs/screens/makanan_sehat.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': MakananSehatScreens(), 'title': 'Makanan sehat'},
    {'page': const HitungKalori(), 'title': 'Hitung kalori'},
    {'page': const DaftarOlahraga(), 'title': 'Daftar olahraga'},
    {'page': const CatatanHarian(), 'title': 'Catatan harian'},
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<UserProvider>(context).refreshUser();

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerCustom(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          _pages[_selectedIndex]['title'],
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black12,
        selectedItemColor: Colors.black87,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.apple,
              color: _selectedIndex == 0 ? Colors.green : Colors.black,
            ),
            label: "Makanan",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calculate,
              color: _selectedIndex == 1 ? Colors.green : Colors.black,
            ),
            label: "Hitung",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.run_circle_rounded,
              color: _selectedIndex == 2 ? Colors.green : Colors.black,
            ),
            label: "Olahraga",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.note,
              color: _selectedIndex == 3 ? Colors.green : Colors.black,
            ),
            label: "Catatan",
          ),
        ],
      ),
    );
  }
}
