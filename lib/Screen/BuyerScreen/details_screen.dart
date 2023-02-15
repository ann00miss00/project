// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, sort_child_properties_last

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/models/product_models.dart';
import 'package:flutter/material.dart';
import 'package:myproject_yourstyle/models/sqlite_model.dart';
import 'package:myproject_yourstyle/utility/sqlite_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/show_progress.dart';
import '../../models/user_models.dart';
import '../../utility/my_constant.dart';

class DetailScreen extends StatefulWidget {
  final ProductModel productModel;
  const DetailScreen({
    super.key,
    required this.productModel,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  UserModel? userModel;
  bool load = true;
  bool? haveProduct;
  ProductModel? productModel;
  List<ProductModel> productModels = [];
  List<String> pathImages = [];
  List<List<String>> listImages = [];
  List<File?> files = [];
  int index = 0;
  int amountInt = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productModel = widget.productModel;
    // print('### image from mySQL ==>> ${productModel!.image}');
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

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}/shoppingmall${strings[0]}';
    return url;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: BuildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              // height: 700,
              child: Stack(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.2),
                  height: 578,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleProduct(),
                        PriceAndSizeAndImage(context),
                        Description(),
                        SizedBox(
                          height: 20,
                        ),
                        AddToCart(context),
                        BuyNow()
                      ]),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Row BuyNow() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          height: 55,
          width: 59,
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 149, 143, 160)),
              borderRadius: BorderRadius.circular(17)),
          child: IconButton(
              onPressed: () async {
                String idProduct = productModel!.id;
                String title = productModel!.title;
                String price = productModel!.price;
                String amount = amountInt.toString();
                int sumInt = int.parse(productModel!.price) * amountInt;
                String sum = sumInt.toString();
                print(
                    '### idProduct ===> ${productModel!.id} , title = ${productModel!.title}, price = ${productModel!.price}, amount = $amount ,sum =$sum ');
                SQLiteModel sqLiteModel = SQLiteModel(
                    idProduct: idProduct,
                    title: title,
                    price: price,
                    amount: amount,
                    sum: sum);

                await SQLiteHelper()
                    .insertValueSQLite(sqLiteModel)
                    .then((value) => Navigator.pop(context));
              },
              icon: Icon(
                Icons.shopping_cart,
                size: 30,
              )),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
            child: SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  String idProduct = productModel!.id;
                  String title = productModel!.title;
                  String price = productModel!.price;
                  String amount = amountInt.toString();
                  int sumInt = int.parse(productModel!.price) * amountInt;
                  String sum = sumInt.toString();
                  print(
                      '### idProduct ===> ${productModel!.id} , title = ${productModel!.title}, price = ${productModel!.price}, amount = $amount ,sum =$sum ');
                  SQLiteModel sqLiteModel = SQLiteModel(
                      idProduct: idProduct,
                      title: title,
                      price: price,
                      amount: amount,
                      sum: sum);

                  await SQLiteHelper().insertValueSQLite(sqLiteModel).then(
                      (value) => Navigator.pushNamed(
                          context, MyConstant.routeCartScreen));
                },
                child: Text(
                  'BUY NOW',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Row AddToCart(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          height: 39,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color.fromARGB(255, 149, 143, 160)),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
              ),
              onPressed: () {
                if (amountInt != 1) {
                  setState(() {
                    amountInt--;
                  });
                } else {}
              },
              child: Icon(
                Icons.remove,
                color: Colors.grey[900],
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(
            amountInt.toString().padLeft(2, '0'),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        SizedBox(
          width: 48,
          height: 39,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color.fromARGB(255, 149, 143, 160)),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
              ),
              onPressed: () {
                setState(() {
                  amountInt++;
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.grey[900],
              )),
        ),
      ],
    );
  }

  Container Description() {
    return Container(
      height: 150,
      child: ShowTitle(
          title: productModel!.description,
          textStyle: TextStyle(
              color: Color.fromARGB(255, 56, 44, 75),
              fontSize: 17,
              height: 1.5)),
    );
  }

  Row PriceAndSizeAndImage(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Price\n',
                          style:
                              TextStyle(color: Colors.grey[800], fontSize: 18)),
                      TextSpan(
                          text: '฿${productModel!.price} THB',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20))
                    ],
                  )),
                ),
                SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Size \n',
                          style:
                              TextStyle(color: Colors.grey[800], fontSize: 18)),
                      TextSpan(
                          text: '${productModel!.size}  cm',
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                  height: 250,
                  width: 205,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 66, 66, 66), width: 1),
                      color: Color.fromARGB(255, 242, 242, 242),
                      borderRadius: BorderRadius.circular(30)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: findUrlImage(productModel!.image),
                      placeholder: (context, url) => ShowProgress(),
                    ),
                  )),
            ),
          ],
        )
      ],
    );
  }

  RichText TitleProduct() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: 'Aristocratic Hand Bag \n',
              style: TextStyle(color: Colors.white, fontSize: 15)),
          TextSpan(
              text: productModel!.title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24)),
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

  AppBar BuildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white, size: 25),
      backgroundColor: Colors.grey[800],
      elevation: 0,
    );
  }
}



// class DetailScreen extends StatelessWidget {
//   final ProductModel product;

//   const DetailScreen({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 195, 178, 223),
//       appBar: BuildAppBar(),
//       body: Body(productModel: product),
//     );
//   }

//   AppBar BuildAppBar() {
//     return AppBar(
//       iconTheme: IconThemeData(color: Colors.white, size: 25),
//       backgroundColor: Color.fromARGB(255, 195, 178, 223),
//       elevation: 0,
//       actions: <Widget>[
//         IconButton(
//           icon: Icon(Icons.search),
//           onPressed: () {},
//         ),
//         IconButton(
//           icon: Icon(Icons.shopping_cart_outlined),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }
// }
