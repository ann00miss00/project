// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, avoid_unnecessary_containers, avoid_print, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, unused_element, deprecated_member_use, unused_local_variable, use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject_yourstyle/Widgets/Show_title.dart';
import 'package:myproject_yourstyle/Widgets/show_progress.dart';
import 'package:myproject_yourstyle/models/product_models.dart';
import 'package:myproject_yourstyle/utility/my_constant.dart';
import 'package:myproject_yourstyle/utility/my_dialog.dart';

class EditProduct extends StatefulWidget {
  final ProductModel productModel;
  const EditProduct({super.key, required this.productModel});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final formKey = GlobalKey<FormState>();
  ProductModel? productModel;
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  List<String> pathImages = [];
  List<File?> files = [];
  bool statusImage = false; // false => no Change Image
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productModel = widget.productModel;
    convertStringYoArray();
    titleController.text = productModel!.title;
    priceController.text = productModel!.price;
    typeController.text = productModel!.type;
    detailController.text = productModel!.description;
    sizeController.text = productModel!.size;
  }

  void convertStringYoArray() {
    String string = productModel!.image;
    // print('string ก่อนตัด ==>> $string');
    string = string.substring(1, string.length - 1);
    // print('string หลังตัด ==>> $string');
    List<String> strings = string.split(',');
    for (var item in strings) {
      pathImages.add(item.trim());
      files.add(null);
    }
    print('### pathImage ==>> ${pathImages} ');
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
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: BuildGeneral(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        BuildTitleProduct(),
                        SizedBox(
                          height: 20,
                        ),
                        BuildPriceProduct(),
                        SizedBox(
                          height: 20,
                        ),
                        BuildTypeProduct(),
                        SizedBox(
                          height: 20,
                        ),
                        BuildDetailProduct(),
                        SizedBox(
                          height: 20,
                        ),
                        BuildSizeProduct(),
                        SizedBox(
                          height: 20,
                        ),
                        BuildTitleImg(),
                        SizedBox(
                          height: 20,
                        ),
                        BuildEditImage(Constraints, 0),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding BuildAddProductButton() {
    Future<Null> chooseSourceImageDialog(int index) async {}
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
          height: 55,
          width: 350,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 54, 54, 54),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            child: Text('Edit Product',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            onPressed: () => processEdit(),
          )),
    );
  }

  Future<Null> chooseImage(int index, ImageSource source) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source, maxHeight: 800, maxWidth: 800);
      setState(() {
        files[index] = File(result!.path);
        statusImage = true;
      });
    } catch (e) {}
  }

  Container BuildEditImage(BoxConstraints Constraints, int index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () => chooseImage(index, ImageSource.camera),
              icon: Icon(
                Icons.add_a_photo,
                size: 32,
              )),
          Container(
            width: Constraints.maxHeight * 0.3,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: files[index] == null
                    ? CachedNetworkImage(
                        imageUrl:
                            '${MyConstant.domain}/shoppingmall/${pathImages[index]}',
                        placeholder: (context, url) => ShowProgress(),
                      )
                    : Image.file(files[index]!)),
          ),
          IconButton(
              onPressed: () => chooseImage(index, ImageSource.gallery),
              icon: Icon(
                Icons.add_photo_alternate,
                size: 32,
              )),
        ],
      ),
    );
  }

  ShowTitle BuildGeneral() {
    return ShowTitle(title: 'General :', textStyle: MyConstant().H1style());
  }

  ShowTitle BuildTitleImg() {
    return ShowTitle(title: 'Image Product', textStyle: MyConstant().H1style());
  }

  Container BuildTitleProduct() {
    return Container(
      child: TextFormField(
        controller: titleController,
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
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey,
                )),
            labelText: 'ชื่อสินค้า:',
            labelStyle: TextStyle(color: Colors.grey[800])),
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Container BuildPriceProduct() {
    return Container(
      child: TextFormField(
        controller: priceController,
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
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey,
                )),
            labelText: 'ราคา:',
            labelStyle: TextStyle(color: Colors.grey[800])),
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Container BuildTypeProduct() {
    return Container(
      child: TextFormField(
        controller: typeController,
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
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey,
                )),
            labelText: 'ประเภท:',
            labelStyle: TextStyle(color: Colors.grey[800])),
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Container BuildDetailProduct() {
    return Container(
      child: TextFormField(
        maxLines: null,
        minLines: 1,
        controller: detailController,
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
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey,
                )),
            labelText: 'รายละเอียด:',
            labelStyle: TextStyle(color: Colors.grey[800])),
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Container BuildSizeProduct() {
    return Container(
      child: TextFormField(
        controller: sizeController,
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
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey,
                )),
            labelText: 'ขนาดสินค้า (เซนติเมตร):',
            labelStyle: TextStyle(color: Colors.grey[800])),
        textInputAction: TextInputAction.done,
      ),
    );
  }

  AppBar BuildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.grey[700], size: 25),
      backgroundColor: Colors.grey[50],
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Edit Product',
        style: MyConstant().H1style(),
      ),
    );
  }

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProgressDialog(context);

      String title = titleController.text;
      String price = priceController.text;
      String type = typeController.text;
      String detail = detailController.text;
      String size = sizeController.text;
      String id = productModel!.id;
      String image;
      if (statusImage) {
        // Upload Image and Refresh arry pathImage
        int index = 0;
        for (var item in files) {
          if (item != null) {
            int i = Random().nextInt(100000);
            String nameImage = 'productEdit$i.jpg';
            String apiUploadImage =
                '${MyConstant.domain}/shoppingmall/saveProduct.php';
            Map<String, dynamic> map = {};
            map['file'] =
                await MultipartFile.fromFile(item.path, filename: nameImage);
            FormData formData = FormData.fromMap(map);
            await Dio().post(apiUploadImage, data: formData).then((value) {
              pathImages[index] = '/product/$nameImage';
            });
          }
          index++;
        }

        image = pathImages.toString();
        Navigator.pop(context);
      } else {
        image = pathImages.toString();
        Navigator.pop(context);
      }
      print('## statusImage = $statusImage');
      print(
          '## id = $id, title = $title, price = $price,type = $type,detail = $detail,size = $size');
      print('## images = $image');

      String apiEditProduct =
          '${MyConstant.domain}/shoppingmall/editProductWhereId.php?isAdd=true&id=$id&image=$image&type=$type&title=$title&size=$size&price=$price&description=$detail';
      await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    }
  }
}
