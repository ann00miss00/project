// ignore_for_file: unused_local_variable, prefer_void_to_null, prefer_const_constructors, sort_child_properties_last, deprecated_member_use, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject_yourstyle/Screen/BuyerScreen/show_account.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/Widgets/show_image.dart';
import 'package:myproject_yourstyle/Widgets/show_progress.dart';
import 'package:myproject_yourstyle/main.dart';
import 'package:myproject_yourstyle/models/user_models.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utility/my_dialog.dart';

class EditProfileBuyer extends StatefulWidget {
  const EditProfileBuyer({super.key});

  @override
  State<EditProfileBuyer> createState() => _EditProfileBuyerState();
}

class _EditProfileBuyerState extends State<EditProfileBuyer> {
  UserModel? userModel;
  final formKey = GlobalKey<FormState>();
  File? file;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController roadController = TextEditingController();
  List<String> pathImages = [];
  List<File?> files = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? email = preferences.getString('email')!;

    String apiGetUser =
        '${MyConstant.domain}/shoppingmall/getUserWhereUser.php?isAdd=true&email=$email';
    await Dio().get(apiGetUser).then((value) {
      print('value from API ==>> $value');
      if (value.toString() == 'null') {
        MyDialog().normalDialog(
            context, 'เข้าสู่ระบบผิดพลาด ', 'ไม่มีข้อมูลสมาชิกของ $email ');
      }
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          nameController.text = userModel!.name;
          phoneController.text = userModel!.phone;
          addressController.text = userModel!.address;
          roadController.text = userModel!.road;
        });
      }
    });
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
                  title: 'ต้องการเปลี่ยนรูปโปรไฟล์ ?',
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

  Future<Null> processImagePicker({ImageSource? source}) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source!, maxWidth: 800, maxHeight: 800);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BuildAppBar(),
        body: LayoutBuilder(
          builder: (context, Constraints) => GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          Container(
                              width: 120,
                              height: 120,
                              child: userModel == null
                                  ? ShowProgress()
                                  : Container(
                                      child: userModel?.avatar == null
                                          ? ShowImage(path: MyConstant.profile)
                                          : file == null
                                              ? buildAvatarImage()
                                              : editAvatarImage())
                                              ),
                          buildEditButtom()
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildName(),
                      SizedBox(
                        height: 20,
                      ),
                      buildPhoneNum(),
                      SizedBox(
                        height: 20,
                      ),
                      buildAddress(),
                      SizedBox(
                        height: 20,
                      ),
                      buildRoad(),
                      SizedBox(
                        height: 20,
                      ),
                      buildEditConfirmButtom(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Container editAvatarImage() {
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
        child: Image.file(
          file!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<Null> processEditProfileBuyer() async {
    print('processEditProfileBuyer Work');
    MyDialog().showProgressDialog(context);

    if (formKey.currentState!.validate()) {
      if (file == null) {
        print('Use Current Avatar');
        editValueToMySQL(userModel!.avatar);
      } else {
        String apiSaveAvatar =
            '${MyConstant.domain}/shoppingmall/saveAvatar.php';
        List<String> nameAvatars = userModel!.avatar.split('/');
        String nameFile = nameAvatars[nameAvatars.length - 1];
        nameFile = 'edit${Random().nextInt(100)}$nameFile';

        print('Use New Avatar nameFile ==>> $nameFile');

        Map<String, dynamic> map = {};
        map['file'] =
            await MultipartFile.fromFile(file!.path, filename: nameFile);
        FormData formData = FormData.fromMap(map);
        await Dio()
            .post(apiSaveAvatar, data: formData)
            .then((value) => print('### Upload Succes'));
        String pathAvatar = '/shoppingmall/avatar/$nameFile';
        editValueToMySQL(pathAvatar);
      }
    }
  }

  Future<Null> editValueToMySQL(String pathAvatar) async {
    print('## pathAvatar ==> $pathAvatar');
    String apiEditProfile =
        '${MyConstant.domain}/shoppingmall/editProfileWhereId.php?isAdd=true&id=${userModel!.id}&avatar=$pathAvatar&name=${nameController.text}&phone=${phoneController.text}&address=${addressController.text}&road=${roadController.text}';
    await Dio().get(apiEditProfile).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  Container buildEditConfirmButtom() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 165,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text('Cancel',
                    style: TextStyle(
                      color: Color.fromARGB(255, 49, 49, 49),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onPressed: () => (Navigator.pop(context))),
          ),
          SizedBox(
            width: 165,
            height: 55,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 57, 57, 57),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text('Edit Confirm',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onPressed: () => processEditProfileBuyer()),
          ),
        ],
      ),
    );
  }

  Container buildAvatarImage() {
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
                color: Color.fromARGB(255, 45, 45, 45),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 2, color: Colors.white)),
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ));
  }

  TextFormField buildName() {
    return TextFormField(
      controller: nameController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณากรอกชื่อ-นามสกุลด้วยค่ะ';
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
          labelText: 'UserName',
          labelStyle: TextStyle(color: Colors.grey[800])),
      textInputAction: TextInputAction.done,
    );
  }

  TextFormField buildPhoneNum() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: phoneController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณากรอกเบอร์โทรศัพท์ด้วยค่ะ';
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
          labelText: 'PhoneNumber',
          labelStyle: TextStyle(color: Colors.grey[800])),
      textInputAction: TextInputAction.done,
    );
  }

  TextFormField buildAddress() {
    return TextFormField(
      maxLines: null,
      minLines: 1,
      controller: addressController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณากรอกข้อมูลด้วยค่ะด้วยค่ะ';
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
          labelText: 'Address',
          labelStyle: TextStyle(color: Colors.grey[800])),
      textInputAction: TextInputAction.done,
    );
  }

  TextFormField buildRoad() {
    return TextFormField(
      maxLines: null,
      minLines: 1,
      controller: roadController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณากรอกข้อมูลด้วยค่ะด้วยค่ะ';
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
          labelText: 'Road',
          labelStyle: TextStyle(color: Colors.grey[800])),
      textInputAction: TextInputAction.done,
    );
  }

  AppBar BuildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.grey[850]),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Edit Profile',
        style: MyConstant().H1style(),
      ),
      centerTitle: true,
    );
  }
}
