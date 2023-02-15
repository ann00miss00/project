// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String idSeller;
  final String nameSeller;
  final String image;
  final String type;
  final String title;
  final String size;
  final String price;
  final String description;
  ProductModel({
    required this.id,
    required this.idSeller,
    required this.nameSeller,
    required this.image,
    required this.type,
    required this.title,
    required this.size,
    required this.price,
    required this.description,
  });

  ProductModel copyWith({
    String? id,
    String? idSeller,
    String? nameSeller,
    String? image,
    String? type,
    String? title,
    String? size,
    String? price,
    String? description,
  }) {
    return ProductModel(
      id: id ?? this.id,
      idSeller: idSeller ?? this.idSeller,
      nameSeller: nameSeller ?? this.nameSeller,
      image: image ?? this.image,
      type: type ?? this.type,
      title: title ?? this.title,
      size: size ?? this.size,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idSeller': idSeller,
      'nameSeller': nameSeller,
      'image': image,
      'type': type,
      'title': title,
      'size': size,
      'price': price,
      'description': description,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      idSeller: map['idSeller'] as String,
      nameSeller: map['nameSeller'] as String,
      image: map['image'] as String,
      type: map['type'] as String,
      title: map['title'] as String,
      size: map['size'] as String,
      price: map['price'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, idSeller: $idSeller, nameSeller: $nameSeller, image: $image, type: $type, title: $title, size: $size, price: $price, description: $description)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.idSeller == idSeller &&
      other.nameSeller == nameSeller &&
      other.image == image &&
      other.type == type &&
      other.title == title &&
      other.size == size &&
      other.price == price &&
      other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idSeller.hashCode ^
      nameSeller.hashCode ^
      image.hashCode ^
      type.hashCode ^
      title.hashCode ^
      size.hashCode ^
      price.hashCode ^
      description.hashCode;
  }
}
