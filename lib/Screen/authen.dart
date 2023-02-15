// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_local_variable, prefer_void_to_null, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myproject_yourstyle/Screen/BuyerScreen/buyer_service.dart';
import 'package:myproject_yourstyle/Screen/register.dart';
import 'package:myproject_yourstyle/Widgets/show_image.dart';
import 'package:myproject_yourstyle/models/user_models.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:myproject_yourstyle/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  final formKey = GlobalKey<FormState>();
  bool statusRedEye = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[345],
      body: Form(
        key: formKey,
        child: SafeArea(
            child: Center(
                child: SingleChildScrollView(
                    child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //ภาพLOgo
              Image.asset('assets/img/logo.png'),
              const Text(
                'เข้าสู่ระบบเลย',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 10),
              const Text(
                'อีเวนต์หลากหลายรอคุณอยู่!',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border:
                          Border.all(color: Color.fromARGB(255, 221, 221, 221)),
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'กรุณากรอกอีเมล';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'อีเมล'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border:
                          Border.all(color: Color.fromARGB(255, 221, 221, 221)),
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'รหัสผ่าน',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  statusRedEye = !statusRedEye;
                                });
                              },
                              icon: Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.black,
                              ))),
                      obscureText: statusRedEye,
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                    height: 55,
                    width: 350,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 51, 51, 51),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      child: Text('เข้าสู่ระบบ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          String email = emailController.text;
                          String password = passwordController.text;
                          print('## email = $email, password = $password');
                          checkAuthen(email: email, password: password);
                        } else {}
                      },
                    )),
              ),

              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ยังไม่มีสมาชิกใช่ไหม?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  InkWell(
                    child: Text(
                      '  ลงทะเบียนที่นี่',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return const Register();
                      })));
                    },
                  )
                ],
              ),
            ],
          ),
        )))),
      ),
    );
  }

  Future<Null> checkAuthen({
    String? email,
    String? password,
  }) async {
    String apiCheckAuthen =
        '${MyConstant.domain}/shoppingmall/getUserWhereUser.php?isAdd=true&email=$email';
    await Dio().get(apiCheckAuthen).then((value) async {
      print('## value for API ==>> $value');
      if (value.toString() == 'null') {
        MyDialog().normalDialog(
            context, 'เข้าสู่ระบบผิดพลาด ', 'ไม่มีข้อมูลสมาชิกของ $email ');
      } else {
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);
          if (password == model.password) {
            // Success Authen
            String type = model.type;
            print('## Authen Success in Type ==>> $type');
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString('id', model.id);
            preferences.setString('type', type);
            preferences.setString('user', model.user);
            preferences.setString('name', model.name);
            preferences.setString('email', model.email);
            switch (type) {
              case 'buyer':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeBuyerService, (route) => false);
                break;
              case 'seller':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeSalerService, (route) => false);
                break;
              default:
            }
          } else {
            // Authen failed
            MyDialog().normalDialog(
                context, 'รหัสผ่านไม่ถูกต้อง', 'กรุณาลองใหม่อีกครั้ง');
          }
        }
      }
    });
  }
}
