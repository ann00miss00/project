// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, prefer_const_declarations, prefer_is_empty

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myproject_yourstyle/Screen/edit_product.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/Widgets/show_progress.dart';
import 'package:myproject_yourstyle/models/product_models.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:myproject_yourstyle/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProductSeller extends StatefulWidget {
  const ShowProductSeller({super.key});

  @override
  State<ShowProductSeller> createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  bool load = true;
  bool? haveData;
  List<ProductModel> productmodels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {
    if (productmodels.length != 0) {
      productmodels.clear();
    } else {}

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String apiGetProductWhereIdSeller =
        '${MyConstant.domain}/shoppingmall/getProductWhereIdSeller.php?isAdd=true&idSeller=$id';
    await Dio().get(apiGetProductWhereIdSeller).then((value) {
      // print('value ==>> $value');
      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        // Have Data
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);
          print('title Product ==>> ${model.title}');
          setState(() {
            load = false;
            haveData = true;
            productmodels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: load
          ? ShowProgress()
          : haveData!
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListView(constraints))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'No Product',
                          textStyle: MyConstant().H1style()),
                      ShowTitle(
                          title: 'Please Add Product',
                          textStyle: MyConstant().H1style()),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.grey[800],
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddProduct)
                .then((value) => loadValueFromAPI()),
        child: Text(
          'Add',
        ),
      ),
    );
  }

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}/shoppingmall${strings[0]}';
    return url;
  }

  ListView buildListView(BoxConstraints constraints) {
    final Border =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30));
    final padding = const EdgeInsets.all(4.0);
    return ListView.builder(
      itemCount: productmodels.length,
      itemBuilder: (context, index) => Card(
        shape: Border,
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                width: constraints.maxWidth * 0.5,
                child: Column(
                  children: [
                    ShowTitle(
                      title: productmodels[index].title,
                      textStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                        height: constraints.maxWidth * 0.3,
                        child: CachedNetworkImage(
                          imageUrl: createUrl(productmodels[index].image),
                          placeholder: (context, url) => ShowProgress(),
                        )
                        )
                  ],
                )),
            Container(
                width: 150,
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShowTitle(
                      title: '${productmodels[index].price}฿ ',
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ShowTitle(
                      title: productmodels[index].type,
                      textStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              print('## You Click Edit ');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProduct(
                                      productModel: productmodels[index],
                                    ),
                                  )).then((value) => loadValueFromAPI());
                            },
                            icon: Icon(
                              Icons.edit_outlined,
                            )),
                        IconButton(
                            onPressed: () {
                              print('## You Cilck Delete From index = $index');
                              confirmDialogDelete(productmodels[index]);
                            },
                            icon: Icon(
                              Icons.delete_sharp,
                            )),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Future<Null> confirmDialogDelete(ProductModel productModel) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Container(
                height: 80,
                child: Center(
                  child: ListTile(
                    title: ShowTitle(
                        title: 'ต้องการลบสินค้า \n${productModel.title} ? ',
                        textStyle: MyConstant().H1style()),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ShowTitle(
                          title: 'คุณแน่ใจใช่ไหม',
                          textStyle: MyConstant().H2style()),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      print('Confirm Delete at id ==> ${productModel.id}');
                      String apiDeleteProductWhereId =
                          '${MyConstant.domain}/shoppingmall/deleteProductWhereId.php?isAdd=true&id=${productModel.id}';
                      await Dio().get(apiDeleteProductWhereId).then((value) {
                        Navigator.pop(context);
                        loadValueFromAPI();
                      });
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w800),
                    )),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    ))
              ],
            ));
  }
}
