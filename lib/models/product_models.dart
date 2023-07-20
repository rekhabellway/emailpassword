import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String? name;
  String? image;
  List<String>? size;
  String? offersDetails;
  String? brandName;
  String? price;
  String? descriptions;

  ProductModel({
    this.name,
    this.image,
    this.size,
    this.offersDetails,
    this.brandName,
    this.price,
    this.descriptions,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        name: json["name"],
        image: json["image"],
        size: json["size"] == null
            ? []
            : List<String>.from(json["size"]!.map((x) => x)),
        offersDetails: json["offers_details"],
        brandName: json["brand_name"],
        price: json["price"],
        descriptions: json["descriptions"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "size": size == null ? [] : List<dynamic>.from(size!.map((x) => x)),
        "offers_details": offersDetails,
        "brand_name": brandName,
        "price": price,
        "descriptions": descriptions,
      };
}
