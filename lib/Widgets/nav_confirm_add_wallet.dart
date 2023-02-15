// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_models.dart';
import '../models/sqlite_model.dart';
import '../models/user_models.dart';
import '../utility/sqlite_helper.dart';

class NavConfirmAddWallet extends StatefulWidget {
  const NavConfirmAddWallet({super.key});

  @override
  State<NavConfirmAddWallet> createState() => _NavConfirmAddWalletState();
}

class _NavConfirmAddWalletState extends State<NavConfirmAddWallet> {
  UserModel? userModel;
  List<SQLiteModel> sqliteModels = [];
  bool load = true;
  int amountInt = 1;
  bool? haveProduct;
  List<UserModel> userModels = [];
  List<ProductModel> productModels = [];
  List<List<String>> listImages = [];
  int indexImage = 0;
  String? currentIdSeller;
  int? total;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processReadSQLite();
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
        });
      }
    });
  }

  Future<Null> processReadSQLite() async {
    if (sqliteModels.isEmpty) {
      sqliteModels.clear();
    }
    await SQLiteHelper().readSQLite().then((value) {
      print('### value on processReadSQLite ==>> $value');
      setState(() {
        load = false;
        sqliteModels = value;
        calcukateTotal();
      });
    });
  }

  void calcukateTotal() async {
    total = 0;
    for (var item in sqliteModels) {
      int sumInt = int.parse(item.sum.trim());
      setState(() {
        total = total! + sumInt;
      });
    }
  }

  Future<Null> orderThread() async {
    DateTime timeOrder = DateTime.now();
    String OrderDateTime = DateFormat('yyyy-MM-dd HH:mm').format(timeOrder);
    String idBuyer = userModel!.id;
    String nameBuyer = userModel!.name;
    List<String> idProducts = [];
    List<String> nameProducts = [];
    List<String> prices = [];
    List<String> amounts = [];
    List<String> sums = [];

    // String idProduct = sqliteModels[0].idProduct;
    // String nameProduct = sqliteModels[0].title;
    // String amountProduct = sqliteModels[0].amount;
    // String sumProduct = sqliteModels[0].sum;

    for (var model in sqliteModels) {}
    for (var model in sqliteModels) {
      idProducts.add(model.idProduct);
      nameProducts.add(model.title);
      prices.add(model.price);
      amounts.add(model.amount);
      sums.add(model.sum);
    }

    String idProduct = idProducts.toString();
    String nameProduct = nameProducts.toString();
    String price = prices.toString();
    String amountProduct = amounts.toString();
    String sumProduct = sums.toString();

    print('orderDateTime = $OrderDateTime, ');
    print(
        'idBuyer = $idBuyer,nameBuyer = $nameBuyer,idProduct = $idProduct,nameProduct = $nameProduct, price = $price,amount = $amountProduct,sum =$sumProduct , total = $total');

    String urlOrder =
        '${MyConstant.domain}/shoppingmall/insertOrder.php?isAdd=true&idBuyer=$idBuyer&nameBuyer=$nameBuyer&idProduct=$idProduct&nameProduct=$nameProduct&amountProduct=$amountProduct&sumProduct=$sumProduct&total=$total&OrderDateTime=$OrderDateTime';

    await Dio().get(urlOrder).then((value) {
      if (value.toString() == 'true') {
        clearAllSQLite();
      } else {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
              title: ShowTitle(
            title: 'ไม่สามารถสั่งซื้อสินค้าได้ กรุณาลองใหม่อีกครั้ง',
          )),
        );
      }
    });
  }

  Future<Null> clearAllSQLite() async {
    await SQLiteHelper().emptySQLite().then((value) {
      processReadSQLite();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      // height: 100,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 49, 49, 49),
          borderRadius: BorderRadius.circular(25)),

      child: InkWell(
        onTap: () {
          orderThread();
          Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routeBuyerService, (route) => false);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/img/checkout.png',
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShowTitle(
                title: 'Confirm Order',
                textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
