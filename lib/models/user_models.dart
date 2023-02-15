// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String avatar;
  final String email;
  final String password;
  final String user;
  final String type;
  final String name;
  final String phone;
  final String address;
  final String road;
  final String detail;
  UserModel({
    required this.id,
    required this.avatar,
    required this.email,
    required this.password,
    required this.user,
    required this.type,
    required this.name,
    required this.phone,
    required this.address,
    required this.road,
    required this.detail,
  });

  UserModel copyWith({
    String? id,
    String? avatar,
    String? email,
    String? password,
    String? user,
    String? type,
    String? name,
    String? phone,
    String? address,
    String? road,
    String? detail,
  }) {
    return UserModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      password: password ?? this.password,
      user: user ?? this.user,
      type: type ?? this.type,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      road: road ?? this.road,
      detail: detail ?? this.detail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'avatar': avatar,
      'email': email,
      'password': password,
      'user': user,
      'type': type,
      'name': name,
      'phone': phone,
      'address': address,
      'road': road,
      'detail': detail,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      avatar: map['avatar'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      user: map['user'] as String,
      type: map['type'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      road: map['road'] as String,
      detail: map['detail'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, avatar: $avatar, email: $email, password: $password, user: $user, type: $type, name: $name, phone: $phone, address: $address, road: $road, detail: $detail)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.avatar == avatar &&
        other.email == email &&
        other.password == password &&
        other.user == user &&
        other.type == type &&
        other.name == name &&
        other.phone == phone &&
        other.address == address &&
        other.road == road &&
        other.detail == detail;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        avatar.hashCode ^
        email.hashCode ^
        password.hashCode ^
        user.hashCode ^
        type.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        road.hashCode ^
        detail.hashCode;
  }
}
