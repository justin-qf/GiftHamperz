import 'dart:convert';
import 'package:gifthamperz/models/UpdateDashboardModel.dart';

HomeDetailModel homeDetailModelFromJson(String str) =>
    HomeDetailModel.fromJson(json.decode(str));

String homeDetailModelToJson(HomeDetailModel data) =>
    json.encode(data.toJson());

class HomeDetailModel {
  int status;
  String message;
  Data data;

  HomeDetailModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HomeDetailModel.fromJson(Map<String, dynamic> json) =>
      HomeDetailModel(
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
  PopularListClass trendList;
  PopularListClass topList;
  PopularListClass popularList;

  Data({
    required this.trendList,
    required this.topList,
    required this.popularList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        trendList: PopularListClass.fromJson(json["trend_list"]),
        topList: PopularListClass.fromJson(json["top_list"]),
        popularList: PopularListClass.fromJson(json["popular_list"]),
      );

  Map<String, dynamic> toJson() => {
        "trend_list": trendList.toJson(),
        "top_list": topList.toJson(),
        "popular_list": popularList.toJson(),
      };
}

class PopularListClass {
  int currentPage;
  List<CommonProductList> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  PopularListClass({
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

  factory PopularListClass.fromJson(Map<String, dynamic> json) =>
      PopularListClass(
        currentPage: json["current_page"],
        data: List<CommonProductList>.from(
            json["data"].map((x) => CommonProductList.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  int id;
  String name;
  int categoryId;
  int subcategoryId;
  int innerSubcategoryId;
  int brandId;
  int sku;
  List<String> images;
  List<String> thumbnailUrl;
  int isActive;
  String tags;
  int price;
  int discount;
  String? discountUnit;
  int instockQty;
  String description;
  int? minQty;
  int isFreeShipping;
  int isReturnPolicy;
  int returnPolicyDays;
  int shippingCharge;
  String? shippingChargeUnit;
  int isFeatured;
  int isTrending;
  int isHotDeals;
  int? tax;
  String? taxUnit;
  int isVariations;
  String productCategoryName;
  String productCategoryThumbnailUrl;
  String productSubCategoryName;
  String productSubCategoryThumbnailUrl;
  String productInnerSubCategoryName;
  String productInnerSubCategoryThumbnailUrl;
  BrandName brandName;
  BrandThumbnailUrl brandThumbnailUrl;
  double? averageRating;

  Datum({
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
    required this.price,
    required this.discount,
    required this.discountUnit,
    required this.instockQty,
    required this.description,
    required this.minQty,
    required this.isFreeShipping,
    required this.isReturnPolicy,
    required this.returnPolicyDays,
    required this.shippingCharge,
    required this.shippingChargeUnit,
    required this.isFeatured,
    required this.isTrending,
    required this.isHotDeals,
    required this.tax,
    required this.taxUnit,
    required this.isVariations,
    required this.productCategoryName,
    required this.productCategoryThumbnailUrl,
    required this.productSubCategoryName,
    required this.productSubCategoryThumbnailUrl,
    required this.productInnerSubCategoryName,
    required this.productInnerSubCategoryThumbnailUrl,
    required this.brandName,
    required this.brandThumbnailUrl,
    required this.averageRating,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        innerSubcategoryId: json["inner_subcategory_id"],
        brandId: json["brand_id"],
        sku: json["sku"],
        images: List<String>.from(json["images"].map((x) => x)),
        thumbnailUrl: List<String>.from(json["thumbnail_url"].map((x) => x)),
        isActive: json["is_active"],
        tags: json["tags"],
        price: json["price"],
        discount: json["discount"],
        discountUnit: json["discount_unit"],
        instockQty: json["instock_qty"],
        description: json["description"],
        minQty: json["min_qty"],
        isFreeShipping: json["is_free_shipping"],
        isReturnPolicy: json["is_return_policy"],
        returnPolicyDays: json["return_policy_days"],
        shippingCharge: json["shipping_charge"],
        shippingChargeUnit: json["shipping_charge_unit"],
        isFeatured: json["is_featured"],
        isTrending: json["is_trending"],
        isHotDeals: json["is_hot_deals"],
        tax: json["tax"],
        taxUnit: json["tax_unit"],
        isVariations: json["is_variations"],
        productCategoryName: json["product_category_name"],
        productCategoryThumbnailUrl: json["product_category_thumbnail_url"],
        productSubCategoryName: json["product_sub_category_name"],
        productSubCategoryThumbnailUrl:
            json["product_sub_category_thumbnail_url"],
        productInnerSubCategoryName: json["product_inner_sub_category_name"],
        productInnerSubCategoryThumbnailUrl:
            json["product_inner_sub_category_thumbnail_url"],
        brandName: brandNameValues.map[json["brand_name"]]!,
        brandThumbnailUrl:
            brandThumbnailUrlValues.map[json["brand_thumbnail_url"]]!,
        averageRating: json["average_rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "inner_subcategory_id": innerSubcategoryId,
        "brand_id": brandId,
        "sku": sku,
        "images": List<dynamic>.from(images.map((x) => x)),
        "thumbnail_url": List<dynamic>.from(thumbnailUrl.map((x) => x)),
        "is_active": isActive,
        "tags": tags,
        "price": price,
        "discount": discount,
        "discount_unit": discountUnit,
        "instock_qty": instockQty,
        "description": description,
        "min_qty": minQty,
        "is_free_shipping": isFreeShipping,
        "is_return_policy": isReturnPolicy,
        "return_policy_days": returnPolicyDays,
        "shipping_charge": shippingCharge,
        "shipping_charge_unit": shippingChargeUnit,
        "is_featured": isFeatured,
        "is_trending": isTrending,
        "is_hot_deals": isHotDeals,
        "tax": tax,
        "tax_unit": taxUnit,
        "is_variations": isVariations,
        "product_category_name": productCategoryName,
        "product_category_thumbnail_url": productCategoryThumbnailUrl,
        "product_sub_category_name": productSubCategoryName,
        "product_sub_category_thumbnail_url": productSubCategoryThumbnailUrl,
        "product_inner_sub_category_name": productInnerSubCategoryName,
        "product_inner_sub_category_thumbnail_url":
            productInnerSubCategoryThumbnailUrl,
        "brand_name": brandNameValues.reverse[brandName],
        "brand_thumbnail_url":
            brandThumbnailUrlValues.reverse[brandThumbnailUrl],
        "average_rating": averageRating,
      };
}

enum BrandName { DKNY, ZARA }

final brandNameValues =
    EnumValues({"Dkny": BrandName.DKNY, "Zara": BrandName.ZARA});

enum BrandThumbnailUrl {
  BRAND_QFS_ECOMMERCE_1694678026_PNG,
  VENDOR_BRAND_QFS_ECOMMERCE_1694678043_PNG
}

final brandThumbnailUrlValues = EnumValues({
  "/brand/qfs_ecommerce_1694678026.png":
      BrandThumbnailUrl.BRAND_QFS_ECOMMERCE_1694678026_PNG,
  "/vendor_brand/qfs_ecommerce_1694678043.png":
      BrandThumbnailUrl.VENDOR_BRAND_QFS_ECOMMERCE_1694678043_PNG
});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
