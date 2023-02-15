// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:myproject_yourstyle/Screen/show_order_seller.dart';
import 'package:myproject_yourstyle/bodys/show_manage_seller.dart';
// import 'package:myproject_yourstyle/bodys/show_order_seller.dart';
import 'package:myproject_yourstyle/Screen/show_product_seller.dart';
import 'package:myproject_yourstyle/models/user_models.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/Show_title.dart';
import '../Widgets/show_signout.dart';

class SalerService extends StatefulWidget {
  const SalerService({Key? key}) : super(key: key);

  @override
  State<SalerService> createState() => _SalerServiceState();
}

class _SalerServiceState extends State<SalerService> {
  List<Widget> widgets = [
    ShowProductSeller(),
    ShowOrderSeller(),
  ];
  int indexWidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUerModel();
  }

  Future<Null> findUerModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    print('## id Login = $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingmall/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      print('## value ===> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          print('### username Logined = ${userModel!.user}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(),
      drawer: Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              children: [
                BuildUserAccounts(),
                menuShowProduct(),
                menuShowOrder(),
              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  UserAccountsDrawerHeader BuildUserAccounts() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24))),
      currentAccountPicture: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: CircleAvatar(
            backgroundImage:
                NetworkImage('${MyConstant.domain}${userModel?.avatar}'),
            radius: 35),
      ),
      accountName: Text(
        userModel == null ? 'Name ?' : userModel!.name,
        style: TextStyle(fontSize: 18),
      ),
      accountEmail: Text(userModel == null ? 'email ?' : userModel!.email,
          style: TextStyle(fontSize: 15)),
    );
  }

  AppBar BuildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.grey[700], size: 25),
      backgroundColor: Colors.grey[50],
      elevation: 0,
      centerTitle: true,
      title: Text(
        'SALER',
        style: MyConstant().H1style(),
      ),
    );
  }

  // ListTile menuShowOrder() {
  //   return ListTile(
  //     onTap: () {
  //       setState(() {
  //         indexWidget = 0;
  //         Navigator.pop(context);
  //       });
  //     },
  //     leading: Icon(
  //       Icons.list,
  //       size: 32,
  //     ),
  //     title: ShowTitle(title: 'Show Order', textStyle: MyConstant().H1style()),
  //     subtitle: ShowTitle(
  //       title: 'แสดงรายละเอียดของ Oder ที่สั่ง',
  //       textStyle: MyConstant().H3style(),
  //     ),
  //   );
  // }

  ListTile menuShowProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.shopping_bag,
        size: 32,
      ),
      title:
          ShowTitle(title: 'Show Product', textStyle: MyConstant().H1style()),
      subtitle: ShowTitle(
        title: 'รายละเอียดของสินค้าที่ขาย',
        textStyle: MyConstant().H3style(),
      ),
    );
  }

  menuShowOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.shopping_bag,
        size: 32,
      ),
      title: ShowTitle(title: 'Show Order', textStyle: MyConstant().H1style()),
      subtitle: ShowTitle(
        title: 'รายละเอียดของรายการสั่งซื้อ',
        textStyle: MyConstant().H3style(),
      ),
    );
  }
}
