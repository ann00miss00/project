// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utility/my_constant.dart';

class CoachBrand extends StatefulWidget {
  const CoachBrand({super.key});

  @override
  State<CoachBrand> createState() => _CoachBrandState();
}

class _CoachBrandState extends State<CoachBrand> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Coach',
                style: MyConstant().H1style(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
