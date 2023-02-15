// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';
import 'Show_title.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then((value) =>
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeAuthen, (route) => false));
          },
          tileColor: Colors.grey[800],
          leading: Icon(
            Icons.exit_to_app,
            size: 34,
            color: Colors.white,
          ),
          title: ShowTitle(
              title: 'SignOut', textStyle: MyConstant().H1Whitestyle()),
        ),
      ],
    );
  }
}
