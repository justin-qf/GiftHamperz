// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';

SubCategoryModel subCategoryModelFromJson(String str) =>
    SubCategoryModel.fromJson(json.decode(str));

String subCategoryModelToJson(SubCategoryModel data) =>
    json.encode(data.toJson());

class SubCategoryModel {
  int status;
  String message;
  List<SubCategoryData> data;

  SubCategoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(
        status: json["status"],
        message: json["message"],
        data: List<SubCategoryData>.from(json["data"].map((x) => SubCategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SubCategoryData {
  int id;
  String name;
  String thumbnailUrl;
  String productCategoryName;
  String productCategoryThumbnailUrl;

  SubCategoryData({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.productCategoryName,
    required this.productCategoryThumbnailUrl,
  });

  factory SubCategoryData.fromJson(Map<String, dynamic> json) => SubCategoryData(
        id: json["id"],
        name: json["name"],
        thumbnailUrl: json["thumbnail_url"],
        productCategoryName: json["product_category_name"],
        productCategoryThumbnailUrl: json["product_category_thumbnail_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail_url": thumbnailUrl,
        "product_category_name": productCategoryName,
        "product_category_thumbnail_url": productCategoryThumbnailUrl,
      };
}
