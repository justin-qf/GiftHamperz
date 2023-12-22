// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

SearchModel searchModelFromJson(String str) =>
    SearchModel.fromJson(json.decode(str));

String searchModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  List<SearchDataList> data;

  SearchModel({
    required this.data,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        data: List<SearchDataList>.from(json["data"].map((x) => SearchDataList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SearchDataList {
  int id;
  String name;
  int categoryId;
  int subcategoryId;
  int innerSubcategoryId;
  int brandId;
  int sku;
  String images;
  String thumbnailUrl;
  int isActive;
  String tags;
  String description;
  String productCategoryName;
  String productCategoryThumbnailUrl;
  String productSubCategoryName;
  String productSubCategoryThumbnailUrl;
  String productInnerSubCategoryName;
  String productInnerSubCategoryThumbnailUrl;
  String brandName;
  String brandThumbnailUrl;

  SearchDataList({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.subcategoryId,
    required this.innerSubcategoryId,
    required this.brandId,
    required this.sku,
    required this.images,
    required this.thumbnailUrl,
    required this.isActive,
    required this.tags,
    required this.description,
    required this.productCategoryName,
    required this.productCategoryThumbnailUrl,
    required this.productSubCategoryName,
    required this.productSubCategoryThumbnailUrl,
    required this.productInnerSubCategoryName,
    required this.productInnerSubCategoryThumbnailUrl,
    required this.brandName,
    required this.brandThumbnailUrl,
  });

  factory SearchDataList.fromJson(Map<String, dynamic> json) => SearchDataList(
        id: json["id"],
        name: json["name"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        innerSubcategoryId: json["inner_subcategory_id"],
        brandId: json["brand_id"],
        sku: json["sku"],
        images: json["images"],
        thumbnailUrl: json["thumbnail_url"],
        isActive: json["is_active"],
        tags: json["tags"],
        description: json["description"],
        productCategoryName: json["product_category_name"],
        productCategoryThumbnailUrl: json["product_category_thumbnail_url"],
        productSubCategoryName: json["product_sub_category_name"],
        productSubCategoryThumbnailUrl:
            json["product_sub_category_thumbnail_url"],
        productInnerSubCategoryName: json["product_inner_sub_category_name"],
        productInnerSubCategoryThumbnailUrl:
            json["product_inner_sub_category_thumbnail_url"],
        brandName: json["brand_name"],
        brandThumbnailUrl: json["brand_thumbnail_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "inner_subcategory_id": innerSubcategoryId,
        "brand_id": brandId,
        "sku": sku,
        "images": images,
        "thumbnail_url": thumbnailUrl,
        "is_active": isActive,
        "tags": tags,
        "description": description,
        "product_category_name": productCategoryName,
        "product_category_thumbnail_url": productCategoryThumbnailUrl,
        "product_sub_category_name": productSubCategoryName,
        "product_sub_category_thumbnail_url": productSubCategoryThumbnailUrl,
        "product_inner_sub_category_name": productInnerSubCategoryName,
        "product_inner_sub_category_thumbnail_url":
            productInnerSubCategoryThumbnailUrl,
        "brand_name": brandName,
        "brand_thumbnail_url": brandThumbnailUrl,
      };
}
