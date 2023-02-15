// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:myproject_yourstyle/models/user_models.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';

import '../../Widgets/show_progress.dart';

class ShowAccount extends StatefulWidget {
  final UserModel userModel;
  const ShowAccount({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<ShowAccount> createState() => _ShowAccountState();
}

class _ShowAccountState extends State<ShowAccount> {
  int indexWidget = 0;
  UserModel? userModel;
File? file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             buildShowAvatar(),
            SizedBox(height: 20),
            buildShowName(),
            SizedBox(height: 5),
            buildShowUserName(),
            SizedBox(
              height: 20,
            ),
            buildShowUser(),
            SizedBox(height: 10),
            buildShowPhone(),
            SizedBox(height: 10),
            buildShowAddress(),
            SizedBox(height: 20),
            BuildEditButtom(),
          ],
        ),
      ),
    );
  }

  Widget buildShowAddress() {
    return Container(
      height: 50,
      width: 280,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey[200]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShowTitle(
              title: userModel!.address, textStyle: MyConstant().H2style()),
        ],
      ),
    );
  }

  Widget buildShowPhone() {
    return Container(
      height: 50,
      width: 280,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey[200]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.phone),
          SizedBox(
            width: 5,
          ),
          ShowTitle(title: userModel!.phone, textStyle: MyConstant().H2style()),
        ],
      ),
    );
  }

  Widget buildShowUser() {
    return Container(
      height: 50,
      width: 280,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey[200]),
      child: Center(
          child: ShowTitle(
              title: userModel!.email,
              textStyle: TextStyle(fontSize: 18, color: Colors.grey[800]))),
    );
  }

  ShowTitle buildShowUserName() {
    return ShowTitle(
        title: userModel!.user, textStyle: TextStyle(fontSize: 18));
  }

  ShowTitle buildShowName() {
    return ShowTitle(title: userModel!.name, textStyle: MyConstant().H1style());
  }

  Container buildShowAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
        boxShadow: [
          BoxShadow(
              spreadRadius: 2,
              blurRadius: 10,
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 10))
        ],
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          imageUrl: '${MyConstant.domain}${userModel!.avatar}',
          placeholder: (context, url) => ShowProgress(),
          height: 120,
          width: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<Null> refreshUserModel() async {
    print('## RefreshUserModel Work');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingmall/getUserWhereId.php?isAdd=true&id=${userModel!.id}';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  Container BuildEditButtom() {
    return Container(
        height: 55,
        width: 260,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 53, 53, 53),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Text('Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routeEditProfileBuyer)
                    .then((value) => refreshUserModel())));
  }
}
