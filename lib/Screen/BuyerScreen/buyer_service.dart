// ignore_for_file: prefer_const_constructors, unnecessary_import, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_is_empty

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:myproject_yourstyle/Screen/BuyerScreen/show_account.dart';
import 'package:myproject_yourstyle/Screen/BuyerScreen/show_order.dart';
import 'package:myproject_yourstyle/Screen/BuyerScreen/cart.dart';
import 'package:myproject_yourstyle/Screen/BuyerScreen/show_products.dart';
import 'package:myproject_yourstyle/Screen/add_wallet.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/Widgets/show_signout.dart';
import 'package:myproject_yourstyle/bodys/my_money.dart';
import 'package:myproject_yourstyle/models/sqlite_model.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:myproject_yourstyle/utility/sqlite_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/show_progress.dart';
import '../../bodys/show_manage_seller.dart';
import '../show_product_seller.dart';
import '../../models/user_models.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({super.key});

  @override
  State<BuyerService> createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  List<Widget> widgets = [];
  int indexWidget = 0;
  UserModel? userModel;
  String? currentIdSeller;
  File? file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUerModel();
  }

  Future<Null> findUerModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingmall/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      // print('## value ===> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          widgets.add(ShowproductBuyer());
          widgets.add(ShowAccount(userModel: userModel!));
          widgets.add(ShowOrderBuyer());
          widgets.add(AddWallet());
        });
      }
    });
  }

  Future<Null> refreshUserModel() async {
    print('## RefreshUserModel Work');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingmall/getUserWhereId.php?isAdd=true&id=${userModel!.id}';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(),
      drawer: widgets.length == 0
          ? SizedBox()
          : Drawer(
              child: Stack(
                children: [
                  ShowSignOut(),
                  Column(
                    children: [
                      BuildUserAccount(),
                      menuHome(),
                      menuEditUser(),
                      menuMyOrder(),
                      menuMyMoney()
                    ],
                  ),
                ],
              ),
            ),
      body: widgets.length == 0 ? ShowProgress() : widgets[indexWidget],
    );
  }

  Column BuildUserAccount() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: UserAccountsDrawerHeader(
            otherAccountsPictures: [],
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24))),
            currentAccountPicture:  ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${MyConstant.domain}${userModel?.avatar}',
                              placeholder: (context, url) => ShowProgress(),
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
            accountName: Text(
              userModel == null ? 'Name ?' : userModel!.name,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
            accountEmail: Text(
              userModel == null ? 'email ?' : userModel!.email,
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),
      ],
    );
  }

  AppBar BuildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.grey[850], size: 25),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: <Widget>[
        // IconButton(
        //   icon: Icon(Icons.search),
        //   onPressed: () {},
        // ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                size: 28,
              ),
              onPressed: () {
                Navigator.pushNamed(context, MyConstant.routeCartScreen);
              }),
        ),
      ],
    );
  }

  ListTile menuMyMoney() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 3;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.money,
        size: 25,
      ),
      title: ShowTitle(
          title: 'ช่องทางการชำระเงิน', textStyle: MyConstant().H2style()),
    );
  }

  ListTile menuMyOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.list,
        size: 25,
      ),
      title:
          ShowTitle(title: 'ออเดอร์ของฉัน', textStyle: MyConstant().H2style()),
    );
  }

  ListTile menuEditUser() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.person,
        size: 25,
      ),
      title: ShowTitle(title: 'บัญชีของฉัน', textStyle: MyConstant().H2style()),
    );
  }

  ListTile menuHome() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(
        Icons.home,
        size: 25,
      ),
      title: ShowTitle(title: 'หน้าหลัก', textStyle: MyConstant().H2style()),
    );
  }
}
