// ignore_for_file: prefer_const_constructors, prefer_void_to_null, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:myproject_yourstyle/Screen/BuyerScreen/edit_profile.dart';
import 'package:myproject_yourstyle/Screen/add_product.dart';
import 'package:myproject_yourstyle/Screen/add_wallet.dart';
import 'package:myproject_yourstyle/Screen/authen.dart';
import 'package:myproject_yourstyle/Screen/BuyerScreen/buyer_service.dart';
import 'package:myproject_yourstyle/Screen/BuyerScreen/cart.dart';
import 'package:myproject_yourstyle/Screen/home.dart';
import 'package:myproject_yourstyle/Screen/register.dart';
import 'package:myproject_yourstyle/Screen/saler_service.dart';
import 'package:myproject_yourstyle/Widgets/nav_confirm_add_wallet.dart';
import 'package:myproject_yourstyle/bodys/confirm_add_wallet.dart';
import 'package:myproject_yourstyle/models/user_models.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => const Authen(),
  '/register': (BuildContext context) => const Register(),
  '/Home': (BuildContext context) => const Home(),
  '/buyerService': (BuildContext context) => const BuyerService(),
  '/salerService': (BuildContext context) => const SalerService(),
  '/cart': (BuildContext context) => const CartScreen(),
  '/addProduct': (BuildContext context) => const AddProduct(),
  '/editProfileBuyer': (BuildContext context) => const EditProfileBuyer(),
  '/addwallet': (BuildContext context) => const AddWallet(),
  '/confirmaddwallet': (BuildContext context) => const ConfirmAffWallet()
};

String? initiialRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  String? user = preferences.getString('user');
  print('### type ===>> $type ### Login Success in user ==>> $user');
  if (type?.isEmpty ?? true) {
    initiialRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    switch (type) {
      case 'buyer':
        initiialRoute = MyConstant.routeBuyerService;
        runApp(MyApp());
        break;
      case 'seller':
        initiialRoute = MyConstant.routeSalerService;
        runApp(MyApp());
        break;
      default:
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyConstant.appName,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColorDark: Colors.grey[800],
          outlinedButtonTheme: OutlinedButtonThemeData(
              style:
                  OutlinedButton.styleFrom(foregroundColor: Colors.grey[500]))),
      routes: map,
      initialRoute: initiialRoute,
    );
  }
}
