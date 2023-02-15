import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utility/my_constant.dart';

class ALDOBrand extends StatefulWidget {
  const ALDOBrand({super.key});

  @override
  State<ALDOBrand> createState() => _ALDOBrandState();
}

class _ALDOBrandState extends State<ALDOBrand> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ALDO',style: MyConstant().H1style(),),
            ],
          ),
        ],
      ),
    );
  }
}