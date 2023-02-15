// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, unnecessary_null_comparison

import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/Widgets/show_image.dart';
import 'package:myproject_yourstyle/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';

class ConfirmAffWallet extends StatefulWidget {
  const ConfirmAffWallet({super.key});

  @override
  State<ConfirmAffWallet> createState() => _ConfirmAffWalletState();
}

class _ConfirmAffWalletState extends State<ConfirmAffWallet> {
  String? dateTimeStr;
  File? file;
  var formKey = GlobalKey<FormState>();
  String? idBuyer;
  TextEditingController moneyController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findCurrentTime();
    findIdBuyer();
  }

  Future<void> findIdBuyer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idBuyer = preferences.getString('id');
  }

  void findCurrentTime() {
    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    setState(() {
      dateTimeStr = dateFormat.format(dateTime);
    });
    print('dateTimeStr = $dateTimeStr');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle(),
                  BuildDate(),
                  SizedBox(
                    height: 40,
                  ),
                  buildMoney(),
                  SizedBox(
                    height: 80,
                  ),
                  Buildimage(),
                  SizedBox(
                    height: 30,
                  ),
                  Center(child: buildConfirm())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMoney() {
    return Center(
      child: Container(
        width: 300,
        child: TextFormField(
          controller: moneyController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอกจำนวนเงิน';
            } else {
              return null;
            }
          },
          cursorColor: Colors.grey[700],
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  )),
              labelText: 'Money',
              labelStyle: TextStyle(color: Colors.grey[800])),
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }

  Container buildConfirm() {
    return Container(
      width: 180,
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (file == null) {
                MyDialog().normalDialog(context, 'ยังไม่เพิ่มสลิปโอนเงิน',
                    'กรุณาเพิ่มหลักฐานการชำระเงินด้วยค่ะ');
              } else {
                // processUploadAndInsertData();
              }
            }
          },
          child: Text(
            'Confirm Add Wallet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
    );
  }

  // Future<void> processUploadAndInsertData() async {
  //   String apisaveReceipt = '${MyConstant.domain}/shoppingmall/saveReceipt.php';
  //   String nameReceipt = 'Receipt${Random().nextInt(10000000)}.jpg';

  //   MyDialog().showProgressDialog(context);
  //   try {
  //     Map<String, dynamic> map = {};
  //     map['file'] =
  //         await MultipartFile.fromFile(file!.path, filename: nameReceipt);
  //     FormData data = FormData.fromMap(map);
  //     await Dio().post(apisaveReceipt, data: data).then((value) {
  //       print('value ==> $value');
  //       Navigator.pop(context);
  //       var pathReceipt = '/Receipt/$nameReceipt';
  //       var urlAPIinsert =
  //           '${MyConstant.domain}/shoppingmall/insertWallet.php?isAdd=true&idBuyer=$idBuyer&datePay=$dateTimeStr&money=${moneyController.text.trim()}&pathReceipt=$pathReceipt&status=$status';
  //     });
  //   } catch (e) {}
  // }

  Future<void> processTakePhoto(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .pickImage(source: source, maxWidth: 800, maxHeight: 800);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row Buildimage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => processTakePhoto(ImageSource.camera),
            icon: Icon(
              Icons.add_a_photo,
              size: 32,
            )),
        Container(
            width: 200,
            height: 200,
            child: file == null
                ? ShowImage(
                    path: 'assets/img/checkout.png',
                  )
                : Image.file(file!)),
        IconButton(
            onPressed: () => processTakePhoto(ImageSource.gallery),
            icon: Icon(
              Icons.add_photo_alternate,
              size: 32,
            )),
      ],
    );
  }

  ShowTitle BuildDate() {
    return ShowTitle(
      title: dateTimeStr == null ? 'dd/MM/yyyy HH:mm' : dateTimeStr!,
      textStyle: MyConstant().H2style(),
    );
  }

  ShowTitle buildTitle() {
    return ShowTitle(
        title: 'Current Data Pay', textStyle: MyConstant().H22style());
  }

  AppBar BuildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white, size: 25),
      backgroundColor: Color.fromARGB(255, 56, 44, 75),
      elevation: 0,
      title: Text(
        'Confirm Add Wallet',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routeBuyerService, (route) => false),
          icon: Platform.isIOS
              ? Icon(Icons.arrow_back_ios)
              : Icon(Icons.arrow_back_ios)),
    );
  }
}
