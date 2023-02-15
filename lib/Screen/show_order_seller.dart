// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/order_model.dart';
import '../Widgets/Show_title.dart';

class ShowOrderSeller extends StatefulWidget {
  const ShowOrderSeller({super.key});

  @override
  State<ShowOrderSeller> createState() => _ShowOrderSellerState();
}

class _ShowOrderSellerState extends State<ShowOrderSeller> {
  List<OrderModel> orderModels = [];
  String? idBuyer;
  bool StatusOrder = true;
  List<List<String>> listMenuFoods = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> totalInts = [];
  List<int> statusInts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  @override
  Widget build(BuildContext context) {
    return StatusOrder
        ? buildNonOrder()
        : SingleChildScrollView(child: ListOrder());
  }

  ListView ListOrder() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: orderModels.length,
      itemBuilder: (context, index) => SizedBox(
        child: Card(
            color: Colors.grey[200],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          nameBuyer(index),
                          SizedBox(height: 5),
                          titelProduct(index),
                          SizedBox(height: 5),
                          amountProduct(index),
                          SizedBox(height: 5),
                          OrderDateTime(index),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [totalProduct(index)],
                          ),
                          buildAddress(index)
                        ],
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  Column buildAddress(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShowTitle(
          title: 'Address',
          textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ShowTitle(title: '${orderModels[index].addressBuyer}'),
            ),
            ShowTitle(title: '${orderModels[index].roadBuyer}'),
          ],
        ),
      ],
    );
  }

  RichText totalProduct(int index) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: 'Total : ',
              style: TextStyle(
                color: Color.fromARGB(255, 254, 16, 16),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          TextSpan(
              text: '฿${orderModels[index].total}',
              style: TextStyle(
                color: Color.fromARGB(255, 254, 16, 16),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
        ],
      ),
    );
  }

  RichText OrderDateTime(int index) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: 'Order DateTime : ',
              style: TextStyle(
                color: Color.fromARGB(255, 131, 42, 42),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
          TextSpan(
              text: orderModels[index].orderDateTime,
              style: TextStyle(
                color: Colors.grey[850],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
        ],
      ),
    );
  }

  RichText nameBuyer(int index) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: orderModels[index].nameBuyer,
              style: TextStyle(
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold,
                  fontSize: 18))
        ],
      ),
    );
  }

  RichText titelProduct(int index) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: orderModels[index].nameProduct,
              style: TextStyle(
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold,
                  fontSize: 14))
        ],
      ),
    );
  }

  RichText amountProduct(int index) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: 'amount : ',
              style: TextStyle(
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          TextSpan(
              text: '${orderModels[index].amountProduct} ',
              style: TextStyle(
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );
  }

  Center buildNonOrder() => Center(
        child: Text(
          'ไม่มีรายการสั่งซื้อสินค้า',
          style: TextStyle(fontSize: 18),
        ),
      );

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idBuyer = preferences.getString('id');
    print('idBuyer = $idBuyer');
    readOrderFromIdUser();
  }

  Future<Null> readOrderFromIdUser() async {
    if (idBuyer != null) {
      String urlAPIgetOrderWhereId =
          '${MyConstant.domain}/shoppingmall/getOrderWhereIdSeller.php';
      await Dio().get(urlAPIgetOrderWhereId).then((value) {
        print('## value ===> $value');
        if (value != 'null') {
          var result = json.decode(value.data);
          for (var map in result) {
            OrderModel model = OrderModel.fromJson(map);
            setState(() {
              StatusOrder = false;
              orderModels.add(model);
            });
          }

          setState(() {
            StatusOrder = false;
          });
        }
      });
    }
  }
}
