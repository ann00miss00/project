// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

class MyConstant {
  //Genernal
  static String appName = 'Your Style';
  static String domain = 'https://10a7-183-88-0-234.ap.ngrok.io';
  static String urlPrompay = 'https://promptpay.io/0800104669.png';

  //Route
  static String routeAuthen = '/authen';
  static String routeRegister = '/register';
  static String routeHome = '/Home';
  static String routeBuyerService = '/buyerService';
  static String routeCartScreen = '/cart';
  static String routeSalerService = '/salerService';
  static String routeAddProduct = '/addProduct';
  static String routeEditProfileBuyer = '/editProfileBuyer';
  static String routeDetailProductBuyer = '/detailProductBuyer';
  static String routeAddWallet = '/addwallet';
  static String routeConfirmAddWallet = '/confirmaddwallet';

  //Image
  static String image1 = 'assets/img/logo.png';
  static String profile = 'assets/img/profile.png';

  //color
  static Color primary = Color(0xffce93d8);
  static Color dark = Color(0xff9c64a6);
  static Color light = Color(0xffffc4ff);

  //textstyle
  TextStyle H1style() => TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 33, 22, 36),
      fontWeight: FontWeight.bold);
  TextStyle H2style() => TextStyle(
      fontSize: 16,
      color: Color.fromARGB(255, 33, 22, 36),
      fontWeight: FontWeight.normal);
  TextStyle H3style() => TextStyle(
      fontSize: 14,
      color: Color.fromARGB(255, 33, 22, 36),
      fontWeight: FontWeight.normal);
  TextStyle H1Whitestyle() =>
      TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);
  TextStyle H2Whitestyle() => TextStyle(
      fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal);
  TextStyle H3Whitestyle() => TextStyle(
      fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal);
  TextStyle H20style() => TextStyle(
      fontSize: 20, color: Colors.grey[850], fontWeight: FontWeight.bold);
  TextStyle H22style() => TextStyle(
      fontSize: 22, color: Colors.grey[850], fontWeight: FontWeight.bold);
  TextStyle H22Whitestyle() =>
      TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold);
}
