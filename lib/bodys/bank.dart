// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/Widgets/nav_confirm_add_wallet.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';

class Bank extends StatefulWidget {
  const Bank({super.key});

  @override
  State<Bank> createState() => _BankState();
}

class _BankState extends State<Bank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(),
          SizedBox(height: 20),
          buildBKKbank(),
          SizedBox(height: 10),
          buildKbank()
        ],
      ),
    );
  }

  Padding buildKbank() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: Colors.green[100],
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ListTile(
            leading: Container(
                width: 90,
                height: 95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.green),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset('assets/img/kbank.svg'),
                )),
            title: ShowTitle(
                title: 'ธนาคารกสิกรไทย',
                textStyle: TextStyle(
                    color: Color.fromARGB(255, 64, 44, 86),
                    fontWeight: FontWeight.bold,
                    fontSize: 17)),
            subtitle: ShowTitle(
              title:
                  'ชื่อบัญชี นางสาวหทัยชนก ยอดแก้ว เลขที่บัญชี 078 - 3 - 63651 - 4',
              textStyle: TextStyle(fontSize: 15.5),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildBKKbank() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: Colors.indigo[100],
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ListTile(
            leading: Container(
                width: 90,
                height: 95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.indigo),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset('assets/img/bbl.svg'),
                )),
            title: ShowTitle(
                title: 'ธนาคารกรุงเทพ',
                textStyle: TextStyle(
                    color: Color.fromARGB(255, 64, 44, 86),
                    fontWeight: FontWeight.bold,
                    fontSize: 17)),
            subtitle: ShowTitle(
              title:
                  'ชื่อบัญชี นางสาวหทัยชนก ยอดแก้ว เลขที่บัญชี 078 - 3 - 63651 - 4',
              textStyle: TextStyle(fontSize: 15.5),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Center(
        child: ShowTitle(
            title: 'ชำระเงินผ่าน บัญชีธนาคาร',
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
