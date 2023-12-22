// To parse this JSON data, do
//
//     final innerSubCategoryModel = innerSubCategoryModelFromJson(jsonString);

import 'dart:convert';

InnerSubCategoryModel innerSubCategoryModelFromJson(String str) =>
    InnerSubCategoryModel.fromJson(json.decode(str));

String innerSubCategoryModelToJson(InnerSubCategoryModel data) =>
    json.encode(data.toJson());

class InnerSubCategoryModel {
  int status;
  String message;
  List<InnerSubCategoryData> data;

  InnerSubCategoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory InnerSubCategoryModel.fromJson(Map<String, dynamic> json) =>
      InnerSubCategoryModel(
        status: json["status"],
        message: json["message"],
        data: List<InnerSubCategoryData>.from(
            json["data"].map((x) => InnerSubCategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class InnerSubCategoryData {
  int id;
  String name;
  int categoryId;
  int subcategoryId;
  String thumbnailUrl;
  String productSubCategoryName;
  String productSubCategoryThumbnailUrl;
  String productCategoryName;
  String productCategoryThumbnailUrl;

  InnerSubCategoryData({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.subcategoryId,
    required this.thumbnailUrl,
    required this.productSubCategoryName,
    required this.productSubCategoryThumbnailUrl,
    required this.productCategoryName,
    required this.productCategoryThumbnailUrl,
  });

  factory InnerSubCategoryData.fromJson(Map<String, dynamic> json) =>
      InnerSubCategoryData(
        id: json["id"],
        name: json["name"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        thumbnailUrl: json["thumbnail_url"],
        productSubCategoryName: json["product_sub_category_name"],
        productSubCategoryThumbnailUrl:
            json["product_sub_category_thumbnail_url"],
        productCategoryName: json["product_category_name"],
        productCategoryThumbnailUrl: json["product_category_thumbnail_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "thumbnail_url": thumbnailUrl,
        "product_sub_category_name": productSubCategoryName,
        "product_sub_category_thumbnail_url": productSubCategoryThumbnailUrl,
        "product_category_name": productCategoryName,
        "product_category_thumbnail_url": productCategoryThumbnailUrl,
      };
}
