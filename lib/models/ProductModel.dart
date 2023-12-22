// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  int status;
  String message;
  Data data;

  ProductModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int currentPage;
  List<ProductListData> data;
  String firstPageUrl;
  String from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  String to;
  String total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<ProductListData>.from(
            json["data"].map((x) => ProductListData.fromJson(x))),
        firstPageUrl: json["first_page_url"] ?? '',
        from: json["from"].toString() ?? '',
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"] ?? '',
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"].toString() ?? '',
        path: json["path"] ?? '',
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"].toString() ?? '',
        total: json["total"].toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl ?? '',
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class ProductListData {
  int id;
  String name;
  // int categoryId;
  // int subcategoryId;
  // int innerSubcategoryId;
  // int brandId;
  // int sku;
  String images;
  // String thumbnailUrl;
  // int isActive;
  // String tags;
  int price;
  // int discount;
  // dynamic discountUnit;
  // int instockQty;
  // String description;
  // int minQty;
  // int isFreeShipping;
  // int isReturnPolicy;
  // int returnPolicyDays;
  // int shippingCharge;
  // dynamic shippingChargeUnit;
  // int isFeatured;
  // int isTrending;
  // int isHotDeals;
  // dynamic tax;
  // dynamic taxUnit;
  // int isVariations;
  // String productCategoryName;
  // String productCategoryThumbnailUrl;
  // String productSubCategoryName;
  // String productSubCategoryThumbnailUrl;
  // String productInnerSubCategoryName;
  // String productInnerSubCategoryThumbnailUrl;
  // String brandName;
  // String brandThumbnailUrl;

  ProductListData({
    required this.id,
    required this.name,
    // required this.categoryId,
    // required this.subcategoryId,
    // required this.innerSubcategoryId,
    // required this.brandId,
    // required this.sku,
    required this.images,
    // required this.thumbnailUrl,
    // required this.isActive,
    // required this.tags,
    required this.price,
    // required this.discount,
    // required this.discountUnit,
    // required this.instockQty,
    // required this.description,
    // required this.minQty,
    // required this.isFreeShipping,
    // required this.isReturnPolicy,
    // required this.returnPolicyDays,
    // required this.shippingCharge,
    // required this.shippingChargeUnit,
    // required this.isFeatured,
    // required this.isTrending,
    // required this.isHotDeals,
    // required this.tax,
    // required this.taxUnit,
    // required this.isVariations,
    // required this.productCategoryName,
    // required this.productCategoryThumbnailUrl,
    // required this.productSubCategoryName,
    // required this.productSubCategoryThumbnailUrl,
    // required this.productInnerSubCategoryName,
    // required this.productInnerSubCategoryThumbnailUrl,
    // required this.brandName,
    // required this.brandThumbnailUrl,
  });

  factory ProductListData.fromJson(Map<String, dynamic> json) =>
      ProductListData(
        id: json["id"],
        name: json["name"] ?? '',
        // categoryId: json["category_id"],
        // subcategoryId: json["subcategory_id"],
        // innerSubcategoryId: json["inner_subcategory_id"],
        // brandId: json["brand_id"],
        // sku: json["sku"],
        images: json["images"] ?? '',
        // thumbnailUrl: json["thumbnail_url"] ?? '',
        // isActive: json["is_active"],
        // tags: json["tags"] ?? '',
        price: json["price"],
        // discount: json["discount"],
        // discountUnit: json["discount_unit"],
        // instockQty: json["instock_qty"],
        // description: json["description"] ?? '',
        // minQty: json["min_qty"],
        // isFreeShipping: json["is_free_shipping"],
        // isReturnPolicy: json["is_return_policy"],
        // returnPolicyDays: json["return_policy_days"],
        // shippingCharge: json["shipping_charge"],
        // shippingChargeUnit: json["shipping_charge_unit"],
        // isFeatured: json["is_featured"],
        // isTrending: json["is_trending"],
        // isHotDeals: json["is_hot_deals"],
        // tax: json["tax"],
        // taxUnit: json["tax_unit"],
        // isVariations: json["is_variations"],
        // productCategoryName: json["product_category_name"] ?? '',
        // productCategoryThumbnailUrl:
        //     json["product_category_thumbnail_url"] ?? '',
        // productSubCategoryName: json["product_sub_category_name"] ?? '',
        // productSubCategoryThumbnailUrl:
        //     json["product_sub_category_thumbnail_url"] ?? '',
        // productInnerSubCategoryName:
        //     json["product_inner_sub_category_name"] ?? '',
        // productInnerSubCategoryThumbnailUrl:
        //     json["product_inner_sub_category_thumbnail_url"] ?? '',
        // brandName: json["brand_name"] ?? '',
        // brandThumbnailUrl: json["brand_thumbnail_url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        // "category_id": categoryId,
        // "subcategory_id": subcategoryId,
        // "inner_subcategory_id": innerSubcategoryId,
        // "brand_id": brandId,
        // "sku": sku,
        "images": images,
        // "thumbnail_url": thumbnailUrl,
        // "is_active": isActive,
        // "tags": tags,
        "price": price,
        // "discount": discount,
        // "discount_unit": discountUnit,
        // "instock_qty": instockQty,
        // "description": description,
        // "min_qty": minQty,
        // "is_free_shipping": isFreeShipping,
        // "is_return_policy": isReturnPolicy,
        // "return_policy_days": returnPolicyDays,
        // "shipping_charge": shippingCharge,
        // "shipping_charge_unit": shippingChargeUnit,
        // "is_featured": isFeatured,
        // "is_trending": isTrending,
        // "is_hot_deals": isHotDeals,
        // "tax": tax,
        // "tax_unit": taxUnit,
        // "is_variations": isVariations,
        // "product_category_name": productCategoryName,
        // "product_category_thumbnail_url": productCategoryThumbnailUrl,
        // "product_sub_category_name": productSubCategoryName,
        // "product_sub_category_thumbnail_url": productSubCategoryThumbnailUrl,
        // "product_inner_sub_category_name": productInnerSubCategoryName,
        // "product_inner_sub_category_thumbnail_url":
        //     productInnerSubCategoryThumbnailUrl,
        // "brand_name": brandName,
        // "brand_thumbnail_url": brandThumbnailUrl,
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
