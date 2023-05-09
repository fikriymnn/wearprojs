import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DaftarOlahraga extends StatefulWidget {
  const DaftarOlahraga({super.key});

  @override
  State<DaftarOlahraga> createState() => _DaftarOlahragaState();
}

class _DaftarOlahragaState extends State<DaftarOlahraga> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Daftar Olahraga"),
    );
  }
}
