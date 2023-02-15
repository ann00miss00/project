// ignore_for_file: unused_import, prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, dead_code, sized_box_for_whitespace, avoid_print, sort_child_properties_last

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:myproject_yourstyle/Screen/BuyerScreen/details_screen.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/Widgets/show_image.dart';
import 'package:myproject_yourstyle/Widgets/show_progress.dart';
import 'package:myproject_yourstyle/models/product_models.dart';
import 'package:myproject_yourstyle/models/user_models.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bodys/show_categorries.dart';

class ShowproductBuyer extends StatefulWidget {
  const ShowproductBuyer({
    super.key,
  });

  @override
  State<ShowproductBuyer> createState() => _ShowproductBuyerState();
}

class _ShowproductBuyerState extends State<ShowproductBuyer> {
  UserModel? userModel;
  bool load = true;
  bool? haveProduct;
  List<ProductModel> productModels = [];
  List<List<String>> listImages = [];
  int indexImage = 0;
  int amountInt = 1;
  String? currentIdSeller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readApiAllShop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          height: 50,
                          width: double.infinity,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10, left: 20),
                            child: Text(
                              'YOUR STYLE',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey[850],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 45)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                // Container(
                //     height: 50,
                //     decoration: BoxDecoration(
                //         color: Color.fromARGB(255, 56, 44, 75),
                //         borderRadius: BorderRadius.only(
                //             bottomLeft: Radius.circular(20),
                //             bottomRight: Radius.circular(20))),
                //     child: Categories()),
                BuildGridView(),
              ],
            ),
    );
  }

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}/shoppingmall${strings[0]}';
    return url;
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

  Expanded BuildGridView() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: GridView.builder(
        itemCount: productModels.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 5, childAspectRatio: 0.52),
        itemBuilder: (context, index) => Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(productModel: productModels[index]),
                  ))
              // print('### YOU Click InDEX ==>> $index');

              // ShowAlertDialog(productModels[index], listImages[index]);
              ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 220,
                            width: 170,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromARGB(255, 123, 123, 123)),
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(30)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    findUrlImage(productModels[index].image),
                                placeholder: (context, url) => ShowProgress(),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ShowTitle(
                                  title: '${productModels[index].type}',
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ShowTitle(
                                  title:
                                      cutWord('${productModels[index].title}'),
                                  textStyle: MyConstant().H2style())),
                          SizedBox(height: 5),
                          ShowTitle(
                              title: '฿${productModels[index].price} THB',
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  String cutWord(String string) {
    String result = string;
    if (result.length >= 15) {
      result = result.substring(0, 16);
      result = '$result ...';
    }
    return result;
  }

  Padding buildOutlinedButton(
      {required IconData icon, void Function()? press}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: 40,
        height: 32,
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
            ),
            onPressed: press,
            child: Icon(
              icon,
              color: Colors.grey[900],
            )),
      ),
    );
  }
}

// class ShowProducts extends StatelessWidget {
//   const ShowProducts({super.key});

// @override
// Widget build(BuildContext context) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: <Widget>[
//       Padding(
//         padding: const EdgeInsets.only(bottom: 10, left: 20),
//         child: Text(
//           'YOUR STYLE',
//           style: MyConstant().H22style(),
//         ),
//       ),
//       Categories(),
//       Expanded(
//           child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12),
//         child: GridView.builder(
//             itemCount: products.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 5,
//                 childAspectRatio: 0.60),
//             itemBuilder: (context, index) => ItemCard(
//                 product: products[index],
//                 press: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           DetailScreen(product: products[index]),
//                     )))),
//       ))
//     ],
//   );
// }
// }
