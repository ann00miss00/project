// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myproject_yourstyle/Screen/authen.dart';
import 'package:myproject_yourstyle/Screen/home.dart';
import 'package:myproject_yourstyle/Screen/register.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => const Authen(),
  '/register': (BuildContext context) => const Register(),
  '/Home': (BuildContext context) => const Home()
};

String? initiialRoute;

void main() {
  initiialRoute = MyConstant.routeAuthen;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyConstant.appName,
      routes: map,
      initialRoute: initiialRoute,
    );
  }
}
