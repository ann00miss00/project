// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SQLiteModel {
  final int? id;
  final String idProduct;
  final String title;
  final String price;
  final String amount;
  final String sum;
  SQLiteModel({
     this.id,
    required this.idProduct,
    required this.title,
    required this.price,
    required this.amount,
    required this.sum,
  });

  SQLiteModel copyWith({
    int? id,
    String? idProduct,
    String? title,
    String? price,
    String? amount,
    String? sum,
  }) {
    return SQLiteModel(
      id: id ?? this.id,
      idProduct: idProduct ?? this.idProduct,
      title: title ?? this.title,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      sum: sum ?? this.sum,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idProduct': idProduct,
      'title': title,
      'price': price,
      'amount': amount,
      'sum': sum,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: map['id'] as int,
      idProduct: map['idProduct'] as String,
      title: map['title'] as String,
      price: map['price'] as String,
      amount: map['amount'] as String,
      sum: map['sum'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) => SQLiteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SQLiteModel(id: $id, idProduct: $idProduct, title: $title, price: $price, amount: $amount, sum: $sum)';
  }

  @override
  bool operator ==(covariant SQLiteModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.idProduct == idProduct &&
      other.title == title &&
      other.price == price &&
      other.amount == amount &&
      other.sum == sum;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idProduct.hashCode ^
      title.hashCode ^
      price.hashCode ^
      amount.hashCode ^
      sum.hashCode;
  }
}
