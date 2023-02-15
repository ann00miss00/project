// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/Widgets/show_image.dart';

class MyDialog {
  final Function()? funcAction;

  MyDialog({this.funcAction});

  Future<Null> showProgressDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  Future<Null> alertLocationService(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: ListTile(
          title: ShowTitle(
            title: title,
            textStyle: TextStyle(fontSize: 18),
          ),
          subtitle:
              ShowTitle(title: message, textStyle: TextStyle(fontSize: 18)),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                // Navigator.pop(context);
                await Geolocator.openLocationSettings();
                exit(0);
              },
              child: Text(
                'ตกลง',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[850],
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: ListTile(
          title: ShowTitle(title: title, textStyle: TextStyle(fontSize: 18)),
          subtitle:
              ShowTitle(title: message, textStyle: TextStyle(fontSize: 18)),
        ),
        children: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ตกลง',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[850],
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  Future<Null> actionDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: ListTile(
          title: ShowTitle(title: title, textStyle: TextStyle(fontSize: 18)),
          subtitle:
              ShowTitle(title: message, textStyle: TextStyle(fontSize: 18)),
        ),
        actions: [
          TextButton(
            onPressed: funcAction,
            child: Text(
              'ตกลง',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ยกเลิก',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> DetailDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: RichText(text: TextSpan()),
        actions: [
          TextButton(
            onPressed: funcAction,
            child: Text(
              'ตกลง',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold),
            ),
          ),
          OutlinedButton(onPressed: () {}, child: Icon(Icons.abc)),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ยกเลิก',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
