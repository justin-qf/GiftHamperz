// import 'dart:convert';

// import 'package:get/get_rx/src/rx_types/rx_types.dart';

// HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

// String homeModelToJson(HomeModel data) => json.encode(data.toJson());

// class HomeModel {
//   int status;
//   String message;
//   Data data;

//   HomeModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });

//   factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
//         status: json["status"],
//         message: json["message"],
//         data: Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data.toJson(),
//       };
// }

// class Data {
//   List<CommonProductList> trendList;
//   List<CommonProductList> topList;
//   List<CommonProductList> popularList;

//   Data({
//     required this.trendList,
//     required this.topList,
//     required this.popularList,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         trendList: List<CommonProductList>.from(
//             json["trend_list"].map((x) => CommonProductList.fromJson(x))),
//         topList: List<CommonProductList>.from(
//             json["top_list"].map((x) => CommonProductList.fromJson(x))),
//         popularList: List<CommonProductList>.from(
//             json["popular_list"].map((x) => CommonProductList.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "trend_list": List<dynamic>.from(trendList.map((x) => x.toJson())),
//         "top_list": List<dynamic>.from(topList.map((x) => x.toJson())),
//         "popular_list": List<dynamic>.from(popularList.map((x) => x.toJson())),
//       };
// }

// class CommonProductList {
//   int id;
//   String name;
//   int categoryId;
//   int subcategoryId;
//   int innerSubcategoryId;
//   int brandId;
//   int sku;
//   String images;
//   String thumbnailUrl;
//   int isActive;
//   String tags;
//   String description;
//   int isFeatured;
//   String productCategoryName;
//   String productCategoryThumbnailUrl;
//   String productSubCategoryName;
//   String productSubCategoryThumbnailUrl;
//   String productInnerSubCategoryName;
//   String productInnerSubCategoryThumbnailUrl;
//   String brandName;
//   String brandThumbnailUrl;
//   //int quantity;
//   RxInt? quantity;
//   RxBool? isInCart;

//   CommonProductList(
//       {required this.id,
//       required this.name,
//       required this.categoryId,
//       required this.subcategoryId,
//       required this.innerSubcategoryId,
//       required this.brandId,
//       required this.sku,
//       required this.images,
//       required this.thumbnailUrl,
//       required this.isActive,
//       required this.tags,
//       required this.description,
//       required this.isFeatured,
//       required this.productCategoryName,
//       required this.productCategoryThumbnailUrl,
//       required this.productSubCategoryName,
//       required this.productSubCategoryThumbnailUrl,
//       required this.productInnerSubCategoryName,
//       required this.productInnerSubCategoryThumbnailUrl,
//       required this.brandName,
//       required this.brandThumbnailUrl,
//       int quantity = 0,
//       bool isInCart = false})
//       : quantity = RxInt(quantity),
//         isInCart = RxBool(isInCart);

//   factory CommonProductList.fromJson(Map<String, dynamic> json) =>
//       CommonProductList(
//         id: json["id"],
//         name: json["name"],
//         categoryId: json["category_id"],
//         subcategoryId: json["subcategory_id"],
//         innerSubcategoryId: json["inner_subcategory_id"],
//         brandId: json["brand_id"],
//         sku: json["sku"],
//         images: json["images"],
//         thumbnailUrl: json["thumbnail_url"],
//         isActive: json["is_active"],
//         tags: json["tags"],
//         description: json["description"],
//         isFeatured: json["is_featured"],
//         productCategoryName: json["product_category_name"],
//         productCategoryThumbnailUrl: json["product_category_thumbnail_url"],
//         productSubCategoryName: json["product_sub_category_name"],
//         productSubCategoryThumbnailUrl:
//             json["product_sub_category_thumbnail_url"],
//         productInnerSubCategoryName: json["product_inner_sub_category_name"],
//         productInnerSubCategoryThumbnailUrl:
//             json["product_inner_sub_category_thumbnail_url"],
//         brandName: json["brand_name"],
//         brandThumbnailUrl: json["brand_thumbnail_url"],
//         quantity: json["quantity"] ?? 0,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "category_id": categoryId,
//         "subcategory_id": subcategoryId,
//         "inner_subcategory_id": innerSubcategoryId,
//         "brand_id": brandId,
//         "sku": sku,
//         "images": images,
//         "thumbnail_url": thumbnailUrl,
//         "is_active": isActive,
//         "tags": tags,
//         "description": description,
//         "is_featured": isFeatured,
//         "product_category_name": productCategoryName,
//         "product_category_thumbnail_url": productCategoryThumbnailUrl,
//         "product_sub_category_name": productSubCategoryName,
//         "product_sub_category_thumbnail_url": productSubCategoryThumbnailUrl,
//         "product_inner_sub_category_name": productInnerSubCategoryName,
//         "product_inner_sub_category_thumbnail_url":
//             productInnerSubCategoryThumbnailUrl,
//         "brand_name": brandName,
//         "brand_thumbnail_url": brandThumbnailUrl,
//         "quantity": quantity?.value, // Convert RxInt to plain Dart int
//         "is_in_cart": isInCart?.value,
//       };

//   CommonProductList copyWith({
//     int? id,
//     String? name,
//     int? categoryId,
//     int? subcategoryId,
//     int? innerSubcategoryId,
//     int? brandId,
//     int? sku,
//     String? images,
//     String? thumbnailUrl,
//     int? isActive,
//     String? tags,
//     String? description,
//     int? isFeatured,
//     String? productCategoryName,
//     String? productCategoryThumbnailUrl,
//     String? productSubCategoryName,
//     String? productSubCategoryThumbnailUrl,
//     String? productInnerSubCategoryName,
//     String? productInnerSubCategoryThumbnailUrl,
//     String? brandName,
//     String? brandThumbnailUrl,
//     int? quantity,
//     bool? isInCart,
//   }) {
//     return CommonProductList(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         categoryId: categoryId ?? this.categoryId,
//         subcategoryId: subcategoryId ?? this.subcategoryId,
//         innerSubcategoryId: innerSubcategoryId ?? this.innerSubcategoryId,
//         brandId: brandId ?? this.brandId,
//         sku: sku ?? this.sku,
//         images: images ?? this.images,
//         thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
//         isActive: isActive ?? this.isActive,
//         tags: tags ?? this.tags,
//         description: description ?? this.description,
//         isFeatured: isFeatured ?? this.isFeatured,
//         productCategoryName: productCategoryName ?? this.productCategoryName,
//         productCategoryThumbnailUrl:
//             productCategoryThumbnailUrl ?? this.productCategoryThumbnailUrl,
//         productSubCategoryName:
//             productSubCategoryName ?? this.productSubCategoryName,
//         productSubCategoryThumbnailUrl: productSubCategoryThumbnailUrl ??
//             this.productSubCategoryThumbnailUrl,
//         productInnerSubCategoryName:
//             productInnerSubCategoryName ?? this.productInnerSubCategoryName,
//         productInnerSubCategoryThumbnailUrl:
//             productInnerSubCategoryThumbnailUrl ??
//                 this.productInnerSubCategoryThumbnailUrl,
//         brandName: brandName ?? this.brandName,
//         brandThumbnailUrl: brandThumbnailUrl ?? this.brandThumbnailUrl,
//         quantity: quantity ?? this.quantity!.value,
//         isInCart: isInCart == null ? this.isInCart!.value : false);
//   }

//   CommonProductList decrementQuantity() {
//     if ((quantity!.value) > 1) {
//       return copyWith(quantity: quantity!.value - 1);
//     } else {
//       // If quantity is 1, remove the item from the cart
//       return copyWith(quantity: 0, isInCart: false);
//     }
//   }

//   int getStoredQuantity() {
//     return quantity!.value ?? 0;
//   }
// }
