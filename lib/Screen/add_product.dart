// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_new, dead_code, avoid_print, unused_element, prefer_void_to_null, unused_local_variable, deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:myproject_yourstyle/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  List<String> paths = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFile();
  }

  void initialFile() {
    for (var i = 0; i < 1; i++) {
      files.add(null);
    }
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
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'รายละเอียดสินค้า *',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BuildProductName(Constraints),
                    SizedBox(
                      height: 20,
                    ),
                    BuildProductPrice(Constraints),
                    SizedBox(
                      height: 20,
                    ),
                    BuildProductType(Constraints),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'เพิ่มรูปสินค้า *',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    BuildProductImageBG(Constraints),
                    SizedBox(
                      height: 30,
                    ),
                    BuildProductDetail(Constraints),
                    SizedBox(
                      height: 20,
                    ),
                    BuildProdcutSize(Constraints),
                    SizedBox(
                      height: 20,
                    ),
                    BuildAddProductButton(),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding BuildAddProductButton() {
    Future<Null> chooseSourceImageDialog(int index) async {
      print('Click From index ==>> $index');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
          height: 55,
          width: 350,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 44, 44, 44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            child: Text('Add Product',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              processAddProuct();
            },
          )),
    );
  }

  Future<Null> processAddProuct() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var item in files) {
        if (item == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        // print('### choose Image Succes');
        MyDialog().showProgressDialog(context);
        String apiSaveProduct =
            '${MyConstant.domain}/shoppingmall/saveProduct.php';
        // print('### apiSaveProduct ==>> $apiSaveProduct');
        int loop = 0;
        for (var item in files) {
          int i = Random().nextInt(100000000);
          String nameFile = 'Product$i.jpg';

          paths.add('/product/$nameFile');
          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item!.path, filename: nameFile);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveProduct, data: data).then((value) async {
            print('Upload  Success');
            loop++;
            if (loop >= files.length) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              String idSeller = preferences.getString('id')!;
              String nameSeller = preferences.getString('name')!;
              String title = titleController.text;
              String price = priceController.text;
              String type = typeController.text;
              String detail = detailController.text;
              String size = sizeController.text;
              String images = paths.toString();
              print(
                  '### idSeller ==>> $idSeller , nameSeller ==>> $nameSeller');
              print(
                  '### title = $title, price = $price, type = $type,detail = $detail,size = $size');

              print('### image ==>> $images');

              String path =
                  '${MyConstant.domain}/shoppingmall/insertProducts.php?isAdd=true&idSeller=$idSeller&nameSeller=$nameSeller&image=$images&type=$type&title=$title&size=$size&price=$price&description=$detail';

              await Dio().get(path).then((value) => Navigator.pop(context));

              Navigator.pop(context);
            }
          });
        }
      } else {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเพิ่มสินค้าได้', 'กรุณาเพิ่มรูปสินค้าค่ะ');
      }
    }
  }

  Padding BuildProdcutSize(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Theme(
        data: new ThemeData(primaryColorDark: Colors.grey[800]),
        child: Container(
          child: TextFormField(
            controller: sizeController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกรายละเอียดสินค้า';
              } else {
                return null;
              }
            },
            cursorColor: Colors.grey[700],
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    )),
                labelText: 'ขนาด (Size) ',
                labelStyle: TextStyle(color: Colors.grey[800])),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    );
  }

  Padding BuildProductDetail(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(
        child: Container(
          child: TextFormField(
            controller: detailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกรายละเอียดสินค้า';
              } else {
                return null;
              }
            },
            maxLines: null,
            minLines: 1,
            cursorColor: Colors.grey[700],
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    )),
                labelText: 'รายละเอียดสินค้า',
                labelStyle: TextStyle(color: Colors.grey[800])),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    );
  }

  Future<Null> processImagePicker(ImageSource source, int index) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source, maxWidth: 800, maxHeight: 800);

      setState(() {
        file = File(result!.path);
        files[index] = file;
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
                  title: 'ต้องการเพิ่มรูปสินค้า ?',
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
                        ImageSource.camera,
                        index,
                      );
                    },
                    child: Text(
                      'Camera',
                      style: MyConstant().H2style(),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      processImagePicker(ImageSource.gallery, index);
                    },
                    child: Text(
                      'Gallery',
                      style: MyConstant().H2style(),
                    ))
              ],
            ));
  }

  Center BuildProductImageBG(BoxConstraints constraints) {
    return Center(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
                onTap: () => chooseSourceImageDialog(0),
                child: files[0] == null
                    ? Image.asset(
                        'assets/img/imagebg.png',
                        width: 240,
                      )
                    : Image.file(
                        files[0]!,
                        scale: 2.50,
                      )),
          ),
        ],
      ),
    );
  }

  Padding BuildProductType(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Theme(
        data: new ThemeData(primaryColorDark: Colors.grey[800]),
        child: Container(
          child: TextFormField(
            controller: typeController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกประเภทสินค้า';
              } else {
                return null;
              }
            },
            cursorColor: Colors.grey[700],
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    )),
                labelText: 'ประเภทสินค้า',
                labelStyle: TextStyle(color: Colors.grey[800])),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    );
  }

  Padding BuildProductPrice(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Theme(
        data: new ThemeData(primaryColorDark: Colors.grey[800]),
        child: Container(
          child: TextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกราคาสินค้า';
              } else {
                return null;
              }
            },
            cursorColor: Colors.grey[700],
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    )),
                labelText: 'ราคา',
                labelStyle: TextStyle(color: Colors.grey[800])),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    );
  }

  Padding BuildProductName(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Theme(
        data: new ThemeData(primaryColorDark: Colors.grey[800]),
        child: Container(
          child: TextFormField(
            controller: titleController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกรหัสผ่าน';
              } else {
                return null;
              }
            },
            cursorColor: Colors.grey[700],
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    )),
                labelText: 'ชื่อสินค้า',
                labelStyle: TextStyle(color: Colors.grey[800])),
          ),
        ),
      ),
    );
  }

  AppBar BuildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text('Add Product', style: MyConstant().H1style()),
      iconTheme: IconThemeData(color: Colors.grey[700], size: 25),
      backgroundColor: Colors.grey[50],
      elevation: 0,
    );
  }
}
