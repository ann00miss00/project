// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:myproject_yourstyle/Screen/register.dart';
import 'package:myproject_yourstyle/Widgets/show_image.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
  
}

class _AuthenState extends State<Authen> {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey[345],
      body: SafeArea(
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
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: const TextField(
                    //   controller: ,
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
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'รหัสผ่าน'),
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
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Text('เข้าสู่ระบบ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    onPressed: () {},
                  )
                  // padding: EdgeInsets.all(20),
                  // decoration: BoxDecoration(
                  //     color: Colors.deepPurple,
                  //     borderRadius: BorderRadius.circular(12)),
                  // child: Center(
                  //     child: Text('เข้าสู่ระบบ',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 18,
                  //         ))),
                  ),
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
    );
  }
}
