// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:myproject_yourstyle/bodys/show_categorries.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';

import '../Screen/BuyerScreen/details_screen.dart';
import '../Widgets/Show_title.dart';
import '../Widgets/show_progress.dart';
import '../models/product_models.dart';

class CharlesKeuthBrand extends StatefulWidget {
  const CharlesKeuthBrand({super.key});

  @override
  State<CharlesKeuthBrand> createState() => _CharlesKeuthBrandState();
}

class _CharlesKeuthBrandState extends State<CharlesKeuthBrand> {

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
        '${MyConstant.domain}/shoppingmall/getProductWhereTypeCharles.php';
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
                              color: Color.fromARGB(255, 56, 44, 75),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          height: 80,
                          width: double.infinity,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10, left: 20),
                            child: Text(
                              'YOUR STYLE',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 45)),
                            Categories(),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                BuildGridView(),
              ],
            ),
    );
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
            crossAxisCount: 2, crossAxisSpacing: 5, childAspectRatio: 0.55),
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
                                // border: Border.all(
                                //     width: 1,
                                //     color: Color.fromARGB(255, 74, 74, 74)),
                                color: Color.fromARGB(255, 195, 178, 223),
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
}