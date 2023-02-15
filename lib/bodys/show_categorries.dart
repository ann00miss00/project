// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myproject_yourstyle/Screen/BuyerScreen/show_products.dart';
import 'package:myproject_yourstyle/Screen/show_product_seller.dart';
import 'package:myproject_yourstyle/bodys/Charles_Keuth.dart';
import 'package:myproject_yourstyle/bodys/aldo.dart';

import 'coach.dart';
import 'lyn.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<Widget> widgets = [
    ShowproductBuyer(),
    CharlesKeuthBrand(),
    ALDOBrand(),
    CoachBrand(),
    LynBrand()
  ];
  List<String> Categories = [
    'All Prodcuts',
    'Charles & Keuth',
    'ALDO',
    'Coach',
    'LYN'
  ];
  int selctedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        child: SizedBox(
          height: 30,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Categories.length,
              itemBuilder: (context, index) => buildCategory(index)),
        ),
      ),
    );
  }
  

  Widget buildCategory(int index) => Container(
        child: GestureDetector(
          onTap: () {
            setState(() {
              selctedIndex = index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Categories[index],
                  style: TextStyle(
                      fontSize: 14,
                      color: selctedIndex == index
                          ? Color.fromARGB(255, 33, 33, 33)
                          : Color.fromARGB(255, 149, 149, 149),
                      fontWeight: selctedIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  height: 2,
                  width: 30,
                  color: selctedIndex == index
                      ? Color.fromARGB(255, 0, 0, 0)
                      : Color.fromARGB(0, 0, 0, 0),
                )
              ],
            ),
          ),
        ),
      );
}
