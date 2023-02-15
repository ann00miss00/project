// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myproject_yourstyle/bodys/bank.dart';
import 'package:myproject_yourstyle/bodys/prompay.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';

class AddWallet extends StatefulWidget {
  const AddWallet({super.key});

  @override
  State<AddWallet> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  List<Widget> widgets = [Bank(), Prompay()];

  List<IconData> icons = [
    Icons.attach_money,
    Icons.payment,
  ];

  List<String> titles = ['Bank', 'prompay'];

  int indexPosition = 0;
  List<BottomNavigationBarItem> bottmNavigationBarItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int i = 0;
    for (var item in titles) {
      bottmNavigationBarItems.add(createBottomNavigatorBarItem(icons[i], item));
      i++;
    }
  }

  BottomNavigationBarItem createBottomNavigatorBarItem(
          IconData iconData, String string) =>
      BottomNavigationBarItem(
        icon: Icon(
          iconData,
        ),
        label: string,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets[indexPosition],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexPosition,
        selectedIconTheme:
            IconThemeData(color: Color.fromARGB(255, 35, 35, 35)),
        unselectedIconTheme:
            IconThemeData(color: Color.fromARGB(255, 147, 147, 147)),
        selectedItemColor: Color.fromARGB(255, 44, 44, 44),
        unselectedItemColor: Color.fromARGB(255, 144, 144, 144),
        items: bottmNavigationBarItems,
        onTap: (value) {
          setState(() {
            indexPosition = value;
          });
        },
      ),
    );
  }
}
