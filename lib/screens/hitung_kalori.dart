import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HitungKalori extends StatefulWidget {
  const HitungKalori({super.key});

  @override
  State<HitungKalori> createState() => _HitungKaloriState();
}

class _HitungKaloriState extends State<HitungKalori> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Hitung Kalori"),
    );
  }
}
