import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CatatanHarian extends StatefulWidget {
  const CatatanHarian({super.key});

  @override
  State<CatatanHarian> createState() => _CatatanHarianState();
}

class _CatatanHarianState extends State<CatatanHarian> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Cataan Harian"),
    );
  }
}
