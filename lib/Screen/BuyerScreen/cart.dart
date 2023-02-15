// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable

import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:intl/intl.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/Widgets/show_progress.dart';
import 'package:myproject_yourstyle/models/sqlite_model.dart';
import 'package:myproject_yourstyle/models/user_models.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:myproject_yourstyle/utility/my_dialog.dart';
import 'package:myproject_yourstyle/utility/sqlite_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/product_models.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  UserModel? userModel;
  ProductModel? productModel;
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
    readApiAllShop();
  }

  Future<Null> readApiAllPhop() async {
    String urlAPI =
        '${MyConstant.domain}/shoppingmall/getProductWhereIdSeller.php';
    await Dio().get(urlAPI).then((value) {
      setState(() {
        haveProduct = false;
        load = false;
      });
      var result = json.decode(value.data);
      for (var item in result) {
        ProductModel model = ProductModel.fromMap(item);
        // print('Title ==>>${productmodel.title}');
        String string = model.image;
        string = string.substring(1, string.length - 1);
        List<String> strings = string.split(',');
        int i = 0;
        for (var item in strings) {
          strings[i] = item.trim();
          i++;
        }

        listImages.add(strings);

        setState(() {
          haveProduct = true;
          load = false;
          productModels.add(model);
        });
      }
    });
  }

  String findUrlImage(String arrayImage) {
    String string = arrayImage.substring(1, arrayImage.length - 1);
    List<String> strings = string.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    String result = '${MyConstant.domain}/shoppingmall${strings[0]}';
    // print('### result = $result');
    return result;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BuildAppBar(),
      body: load
          ? ShowProgress()
          : sqliteModels.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 150,
                    ),
                    EmptyCart(),
                    SizedBox(
                      height: 100,
                    )
                  ],
                )
              : BuildContent(),
    );
  }

  Row EmptyCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.grey[800], borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowTitle(
                      title: 'Empty Cart',
                      textStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  SingleChildScrollView BuildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListProduct(),
          Divider(
            color: Colors.grey,
            thickness: 1.5,
            indent: 50,
            endIndent: 50,
          ),
          TotalAndBuyNow(),
        ],
      ),
    );
  }

  Future<void> confirmEmptyCart() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: ShowTitle(
                title: 'ต้องการลบสินค้าในตระกร้าทั้งหมดหรือไม่ ?',
                textStyle: TextStyle(fontSize: 20),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await SQLiteHelper().emptySQLite().then((value) {
                      Navigator.pop(context);
                      processReadSQLite();
                    });
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[850],
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ));
  }

  Padding TotalAndBuyNow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 140,
            height: 60,
            child: ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                onPressed: () {
                  confirmEmptyCart();
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.grey[850],
                ),
                label: ShowTitle(
                  title: 'Clear Cart',
                  textStyle: TextStyle(fontSize: 17, color: Colors.grey[850]),
                )),
          ),
          Column(
            children: [
              Container(
                  width: 140,
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(22),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Total\n',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 41, 41, 41),
                                    fontSize: 17)),
                            TextSpan(
                                text: total == null
                                    ? ''
                                    : '${total.toString()} THB',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 42, 42, 42),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19)),
                          ],
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  orderThread();
                  // Navigator.pushNamed(context, MyConstant.routeAddWallet);
                },
                child: Container(
                    width: 140,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.grey[850]),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShowTitle(
                            title: 'Order Now',
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                      ],
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListView ListProduct() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => SizedBox(
        height: 130,
        child: Card(
            color: Colors.grey[200],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              TitleProduct(index),
                            ],
                          ),
                          PriceProduct(index),
                        ],
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  Row PriceProduct(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'Price \n',
                  style: TextStyle(
                      color: Color.fromARGB(255, 56, 44, 75), fontSize: 15)),
              TextSpan(
                  text: '฿${sqliteModels[index].price} THB',
                  style: TextStyle(
                      color: Color.fromARGB(255, 56, 44, 75),
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'X ',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              TextSpan(
                  text: '${sqliteModels[index].amount}',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(width: 25),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'Total: ',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              TextSpan(
                  text: '${sqliteModels[index].sum} THB',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(width: 40),
        SizedBox(
          width: 36,
          height: 30,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color.fromARGB(255, 149, 143, 160)),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
              ),
              onPressed: () async {
                int idSQLite = sqliteModels[index].id!;
                print('### Delete idSQLite ==>> $idSQLite ');
                await SQLiteHelper()
                    .deleteSQLiteWhereId(idSQLite)
                    .then((value) => processReadSQLite());
              },
              child: Icon(
                Icons.remove,
                color: Colors.grey[900],
              )),
        ),
      ],
    );
  }

  RichText TitleProduct(int index) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: 'Product \n',
              style: TextStyle(color: Colors.grey[850], fontSize: 15)),
          TextSpan(
              text: sqliteModels[index].title,
              style: TextStyle(
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ],
      ),
    );
  }

  AppBar BuildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.grey[850], size: 25),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'Your Cart',
            style: MyConstant().H1style(),
          ),
        ],
      ),
    );
  }

  Future<Null> orderThread() async {
    DateTime timeOrder = DateTime.now();
    String OrderDateTime = DateFormat('yyyy-MM-dd HH:mm').format(timeOrder);
    String idBuyer = userModel!.id;
    String nameBuyer = userModel!.name;
    String addressBuyer = userModel!.address;
    String roadBuyer = userModel!.road;
    String idSeller = productModels[0].idSeller;
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
        'idSeller = $idSeller,idBuyer = $idBuyer,nameBuyer = $nameBuyer,addressBuyer = $addressBuyer,roadBuyer = $roadBuyer,idProduct = $idProduct,nameProduct = $nameProduct, price = $price,amount = $amountProduct,sum =$sumProduct , total = $total');

    String urlOrder =
        '${MyConstant.domain}/shoppingmall/insertOrder.php?isAdd=true&idSeller=$idSeller&idBuyer=$idBuyer&nameBuyer=$nameBuyer&addressBuyer=$addressBuyer&roadBuyer=$roadBuyer&nameBuyer=$nameBuyer&idProduct=$idProduct&nameProduct=$nameProduct&amountProduct=$amountProduct&sumProduct=$sumProduct&total=$total&OrderDateTime=$OrderDateTime';

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

  Future<Null> readApiAllShop() async {
    String urlAPI =
        '${MyConstant.domain}/shoppingmall/getProductWhereIdSeller.php';
    await Dio().get(urlAPI).then((value) {
      setState(() {
        haveProduct = false;
        load = false;
      });
      var result = json.decode(value.data);
      for (var item in result) {
        ProductModel model = ProductModel.fromMap(item);
        // print('Title ==>>${productmodel.title}');
        String string = model.image;
        string = string.substring(1, string.length - 1);
        List<String> strings = string.split(',');
        int i = 0;
        for (var item in strings) {
          strings[i] = item.trim();
          i++;
        }

        listImages.add(strings);

        setState(() {
          haveProduct = true;
          load = false;
          productModels.add(model);
        });
      }
    });
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

  Future<Null> clearAllSQLite() async {
    await SQLiteHelper().emptySQLite().then((value) {
      processReadSQLite();
    });
  }
}
