// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';

class LynBrand extends StatefulWidget {
  const LynBrand({super.key});

  @override
  State<LynBrand> createState() => _LynBrandState();
}

class _LynBrandState extends State<LynBrand> {
  @override
  int indexWidget = 0;
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('LYN',style: MyConstant().H1style(),),
        ],
      ),
    );
  }
}