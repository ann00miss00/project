// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, non_constant_identifier_names, prefer_void_to_null, unused_local_variable, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject_yourstyle/Widgets/show_image.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  File? file;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[345],
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Form(
              key: formkey,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildAvatar(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            '*รูปภาพเพื่อแสดงตัวตนของผู้ใช้งาน สามารถเพิ่มภายหลังหรือปฏิเสธการใช้รูปภาพได้'),
                      ),
                      SizedBox(height: 35),
                      Text('บัญชีผู้ใช้',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text("อีเมล *",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                                color: Color.fromARGB(255, 221, 221, 221)),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'กรุณากรอก อีเมล!';
                              } else {}
                            },

                            //   controller: ,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'ใส่อีเมล'),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 5),
                        child: Text("รหัสผ่าน *",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                                color: Color.fromARGB(255, 205, 205, 205)),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'กรุณากรอก รหัสผ่าน!';
                              } else {}
                            },
                            //   controller: ,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'ใส่รหัสผ่าน'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 9, top: 5),
                        child: Column(
                          children: [SizedBox(child: Text("6-16 ตัวอักษร"))],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 5),
                        child: Text("ชื่อเล่น *",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                                color: Color.fromARGB(255, 205, 205, 205)),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'กรุณากรอก ชื่อเล่น!';
                              } else {}
                            },
                            //   controller: ,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'ใส่ชื่อเล่น'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 9, top: 5),
                        child: Column(
                          children: [
                            const SizedBox(child: Text("น้อยกว่า 20 ตัวอักษร"))
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Text('เพิ่มที่อยู่ใหม่',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'กรุณากรอก ชื่อ-นามสกุล!';
                                } else {}
                              },
                              //   controller: ,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'ชื่อ-นามสกุลผู้รับ'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'กรุณากรอก เบอร์โทรศัพท์!';
                                } else {}
                              },
                              //   controller: ,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'เบอร์โทรศัพท์มือถือ'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'กรุณากรอกข้อมูลให้ครบถ้วน!';
                                } else {}
                              },
                              //   controller: ,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'จังหวัด/เขต(อำเภอ)/รหัสไปรณีย์'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'กรุณากรอกข้อมูลให้ครบถ้วน!';
                                } else {}
                              },
                              //   controller: ,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      'ที่อยู่ บ้านเลขที่ ซอย หมู่ ถนน แขวง/ตำบล'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: const TextField(
                              //   controller: ,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '  รายละเอียดเพิ่มเติม'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            child: Text(
                                "YOUR STYLE เก็บรวบรวมเพื่อใช้ประมวลผลจากอีเมลในจุดประสงค์ทางการตลาด คุณสามารถยกเลิกติดตามอีเมลเมื่อไหร่ก็ได้ง่าย ๆ ผ่านการกดลิงก์ในอีเมลประชาสัมพันธ์ต่าง ๆ"),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Container(
                          height: 55,
                          width: 350,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Text('ลงทะเบียน',
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                            onPressed: () {
                              if (formkey.currentState!.validate()) {}
                            },
                          )),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );

      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row BuildAvatar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(Icons.add_a_photo_outlined),
          iconSize: 34,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
              width: 130,
              child: file == null
                  ? ShowImage(pathImage: MyConstant.profile)
                  : Image.file(file!)),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(Icons.add_photo_alternate_outlined),
          iconSize: 34,
        )
      ],
    );
  }
}
