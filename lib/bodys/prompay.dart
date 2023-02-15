// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/Widgets/show_progress.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:myproject_yourstyle/utility/my_dialog.dart';

import '../Widgets/nav_confirm_add_wallet.dart';

class Prompay extends StatefulWidget {
  const Prompay({super.key});

  @override
  State<Prompay> createState() => _PrompayState();
}

class _PrompayState extends State<Prompay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildTitle(),
          SizedBox(
            height: 20,
          ),
          buildCopyPrompay(),
          SizedBox(
            height: 20,
          ),
          buildQRcodePrompay(),
          buildDownload()
        ],
      ),
    );
  }

  Container buildDownload() {
    return Container(
      width: 180,
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
          onPressed: () async {
            String path = 'https://promptpay.io/0800104669.png';
            try {
              await GallerySaver.saveImage(path, toDcim: true).then((value) =>
                  MyDialog().normalDialog(context, 'Download Prompay Finish',
                      'กรุณาไปที่แอพธนาคาร เพื่อสแกน QR Code '));
            } catch (e) {
              print('## error ==>> ${e.toString()}');
              MyDialog().normalDialog(context, 'Storage Permission Denied',
                  'กรุณาเปิด Permission Storge ด้วยค่ะ');
            }
          },
          child: Text(
            'Download QRcode',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );
  }

  Container buildQRcodePrompay() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: CachedNetworkImage(
        imageUrl: MyConstant.urlPrompay,
        placeholder: (context, url) => ShowProgress(),
      ),
    );
  }

  Widget buildCopyPrompay() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.grey[800]),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Center(
        child: ListTile(
          title: ShowTitle(
              title: '0800104669',
              textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          subtitle: ShowTitle(
            title: 'บัญชี Prompay',
            textStyle: TextStyle(color: Colors.grey[200]),
          ),
          trailing: IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: '0800104669'));
                MyDialog().normalDialog(context, 'คัดลอกสำเร็จ',
                    'กรุณาไปที่ Mobile Banking ของท่าน เพื่อทำการชำระเงิน ผ่านระบบ Prompay ค่ะ');
              },
              icon: Icon(
                Icons.copy,
                color: Color.fromARGB(255, 196, 196, 196),
              )),
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: ShowTitle(
          title: 'การชำระเงินโดย จ่ายผ่าน Prompay',
          textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[850])),
    );
  }
}
