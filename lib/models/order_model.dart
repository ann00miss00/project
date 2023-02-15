class OrderModel {
  String? id;
  String? idSeller;
  String? idBuyer;
  String? nameBuyer;
  String? addressBuyer;
  String? roadBuyer;
  String? idProduct;
  String? nameProduct;
  String? amountProduct;
  String? sumProduct;
  String? total;
  String? orderDateTime;

  OrderModel(
      {this.id,
      this.idSeller,
      this.idBuyer,
      this.nameBuyer,
      this.addressBuyer,
      this.roadBuyer,
      this.idProduct,
      this.nameProduct,
      this.amountProduct,
      this.sumProduct,
      this.total,
      this.orderDateTime});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idSeller = json['idSeller'];
    idBuyer = json['idBuyer'];
    nameBuyer = json['nameBuyer'];
    addressBuyer = json['addressBuyer'];
    roadBuyer = json['roadBuyer'];
    idProduct = json['idProduct'];
    nameProduct = json['nameProduct'];
    amountProduct = json['amountProduct'];
    sumProduct = json['sumProduct'];
    total = json['total'];
    orderDateTime = json['OrderDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idSeller'] = this.idSeller;
    data['idBuyer'] = this.idBuyer;
    data['nameBuyer'] = this.nameBuyer;
    data['addressBuyer'] = this.addressBuyer;
    data['roadBuyer'] = this.roadBuyer;
    data['idProduct'] = this.idProduct;
    data['nameProduct'] = this.nameProduct;
    data['amountProduct'] = this.amountProduct;
    data['sumProduct'] = this.sumProduct;
    data['total'] = this.total;
    data['OrderDateTime'] = this.orderDateTime;
    return data;
  }
}
