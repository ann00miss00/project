// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, non_constant_identifier_names, prefer_void_to_null, unused_local_variable, deprecated_member_use, avoid_print, unused_element, unnecessary_null_comparison, curly_braces_in_flow_control_structures, prefer_collection_literals, unnecessary_cast, dead_code, sort_child_properties_last

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/Widgets/show_image.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:myproject_yourstyle/utility/my_dialog.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String avatar = '';
  String? typeUser = 'buyer';
  bool statusRedEye = true;
  File? file;
  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController roadController = TextEditingController();
  TextEditingController detailController = TextEditingController();

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
                      SizedBox(height: 20),
                      Center(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: Container(
                                  width: 120,
                                  height: 120,
                                  child: file == null
                                      ? Image.asset(
                                          'assets/img/profile.png',
                                          height: 120,
                                          width: 120,
                                          color: Colors.grey[850],
                                        )
                                      : file == null
                                          ? BuildAvatar()
                                          : ClipRRect(
                                              child: Image.file(
                                                file!,
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                            ),
                            buildEditButtom()
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            '*รูปภาพเพื่อแสดงตัวตนของผู้ใช้งาน เพื่อใช้แสดงตัวตนเท่านั้น'),
                      ),
                      SizedBox(height: 35),
                      textUser(),
                      SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text("อีเมล *",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      Email(),
                      const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 5),
                        child: Text("รหัสผ่าน *",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      Password(),
                      Padding(
                        padding: const EdgeInsets.only(left: 9, top: 5),
                        child: Column(
                          children: [SizedBox(child: Text("6-15 ตัวอักษร"))],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 5),
                        child: Text("ชื่อบัญชีผู้ใช้งาน *",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      UserName(),
                      Padding(
                        padding: const EdgeInsets.only(left: 9, top: 5),
                        child: Column(
                          children: [
                            const SizedBox(child: Text("น้อยกว่า 50  ตัวอักษร"))
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      textAddress(),
                      Name(),
                      PhoneNumber(),
                      Address(),
                      Road(),
                      Detail(),
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
                      SignupButtom(),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Container SignupButtom() {
    return Container(
        height: 55,
        width: 350,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 59, 59, 59),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          child: Text('ลงทะเบียน',
              style: TextStyle(
                color: Colors.grey[200],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          onPressed: () {
            if (formkey.currentState!.validate()) {
              if (typeUser == 'buyer') {
                setState(() {
                  typeUser = 'buyer';
                });
              }
              print('Process Insert to Database');
              uploadPictureInsertData();
            }
          },
        ));
  }

  Padding Detail() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            controller: detailController,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: '  รายละเอียดเพิ่มเติม'),
          ),
        ),
      ),
    );
  }

  Padding Road() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            controller: roadController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกข้อมูลด้วยค่ะ';
              } else {}
            },
            //   controller: ,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'ที่อยู่ บ้านเลขที่ ซอย หมู่ ถนน แขวง/ตำบล *'),
          ),
        ),
      ),
    );
  }

  Padding Address() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            controller: addressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกข้อมูลด้วยค่ะ';
              } else {}
            },
            //   controller: ,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'จังหวัด/เขต(อำเภอ)/รหัสไปรณีย์ *'),
          ),
        ),
      ),
    );
  }

  Padding PhoneNumber() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกเบอร์โทรศัพท์ด้วยค่ะ';
              } else if (value.length > 10) {
                return "กรุณาใส่เบอร์โทรศัพท์ไม่เกิน 10 ตัวอักษร";
              }
            },
            //   controller: ,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'เบอร์โทรศัพท์มือถือ *'),
          ),
        ),
      ),
    );
  }

  Padding Name() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อ-นามสกุลด้วยค่ะ';
              } else {}
            },
            //   controller: ,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'ชื่อ-นามสกุลผู้รับ *'),
          ),
        ),
      ),
    );
  }

  Text textAddress() {
    return Text('เพิ่มที่อยู่',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Container UserName() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Color.fromARGB(255, 205, 205, 205)),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: TextFormField(
          controller: userController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอกชื่อบัญชีผู้ใช้งานด้วยค่ะ';
            } else if (value.length > 50) {
              return "กรุณาใส่ชื่อบัญชีไม่เกิน 50 ตัวอักษร";
            }
          },
          decoration: InputDecoration(
              border: InputBorder.none, hintText: 'ใส่บัญชีผู้ใช้งาน'),
        ),
      ),
    );
  }

  Container Password() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Color.fromARGB(255, 205, 205, 205)),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: TextFormField(
          obscureText: statusRedEye,
          controller: passwordController,
          validator: (value) {
            if (value!.isEmpty) {
              return " กรุณากรอกรหัสผ่านด้วยค่ะ";
            } else if (value.length < 8) {
              MyDialog().normalDialog(context, 'กรอกรหัสผ่านผิดพลาด',
                  'กรุณาใส่รหัสผ่านอย่างน้อย 8 ตัวอักษร');
            } else if (value.length > 16) {
              MyDialog().normalDialog(context, 'กรอกรหัสผ่านผิดพลาด',
                  'กรุณาใส่รหัสผ่านไม่เกิน 16 ตัวอักษร');
            } else
              return null;
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      statusRedEye = !statusRedEye;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.black,
                  )),
              border: InputBorder.none,
              hintText: 'ใส่รหัสผ่าน'),
        ),
      ),
    );
  }

  Container Email() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Color.fromARGB(255, 221, 221, 221)),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: TextFormField(
          controller: emailController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอกอีเมลด้วยค่ะ';
            } else {}
          },
          decoration:
              InputDecoration(border: InputBorder.none, hintText: 'ใส่อีเมล'),
        ),
      ),
    );
  }

  Text textUser() {
    return Text('บัญชีผู้ใช้',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Future<Null> processImagePicker({ImageSource? source}) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source!, maxWidth: 800, maxHeight: 800);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Future<Null> chooseSourceImageDialog(int index) async {
    print('Click From index ==>> $index');
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: ListTile(
                title: ShowTitle(
                  title: 'ต้องการเพิ่มรูปโปรไฟล์ ?',
                  textStyle: MyConstant().H1style(),
                ),
                subtitle: ShowTitle(
                    title: 'กรุณากดกล้องถ่ายรูป',
                    textStyle: MyConstant().H2style()),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      processImagePicker(
                        source: ImageSource.camera,
                      );
                    },
                    child: Text(
                      'Camera',
                      style: MyConstant().H2style(),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      processImagePicker(source: ImageSource.gallery);
                    },
                    child: Text(
                      'Gallery',
                      style: MyConstant().H2style(),
                    ))
              ],
            ));
  }

  Positioned buildEditButtom() {
    return Positioned(
        bottom: 0,
        right: 0,
        child: InkWell(
          onTap: () => chooseSourceImageDialog(0),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 51, 51, 51),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 2, color: Colors.white)),
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ));
  }

  Stack BuildAvatar() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: file == null
                    ? Image.asset(
                        'assets/img/profile.png',
                        height: 120,
                        width: 120,
                      )
                    : Image.file(
                        file!,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<Null> uploadPictureInsertData() async {
    String email = emailController.text;
    String password = passwordController.text;
    String user = userController.text;
    String name = nameController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String road = roadController.text;
    String detail = detailController.text;
    print(
        '## email =$email, password = $password, user = $user, name = $name,phone = $phone,address = $address, road = $road , detail = $detail');
    String path =
        '${MyConstant.domain}/shoppingmall/getUserWhereUser.php?isAdd=true&email=$email';
    await Dio().get(path).then((value) async {
      print('## value ==>> $value');
      if (value.toString() == 'null') {
        print('## user OK');
        if (file == null) {
          // No Avatar
          processInsertMySQL(
              email: email,
              password: password,
              user: user,
              name: name,
              phone: phone,
              address: address,
              road: road,
              detail: detail);
        } else {
          // Have Avatar
          print('### process Upload Avatar');
          String apiSaveAvatar =
              '${MyConstant.domain}/shoppingmall/saveAvatar.php';
          int i = Random().nextInt(10000000);
          String nameAvatar = 'avatar$i.jpg';
          Map<String, dynamic> map = Map();
          map['file'] =
              await MultipartFile.fromFile(file!.path, filename: nameAvatar);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveAvatar, data: data).then((value) {
            avatar = '/shoppingmall/avatar/$nameAvatar';
            processInsertMySQL(
                email: email,
                password: password,
                user: user,
                type: typeUser,
                name: name,
                phone: phone,
                address: address,
                road: road,
                detail: detail);
          });
        }
      } else {
        MyDialog().normalDialog(
            context, 'อีเมลนี้มีผู้ลงทะเบียนแล้ว', 'กรุณาเปลี่ยนอีเมลค่ะ');
      }
    });
  }

  Future<Null> processInsertMySQL(
      {String? email,
      String? password,
      String? user,
      String? type,
      String? name,
      String? phone,
      String? address,
      String? road,
      String? detail}) async {
    print('### processInsertMySQL Work And avatar ==>> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/shoppingmall/insertUser.php?isAdd=true&avatar=$avatar&email=$email&password=$password&user=$user&type=$typeUser&name=$name&phone=$phone&address=$address&road=$road&detail=$detail';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog()
            .normalDialog(context, 'ลงทะเบียนผิดพลาด', 'กรุณาลองใหม่อีกครั้ง');
      }
    });
  }
}
