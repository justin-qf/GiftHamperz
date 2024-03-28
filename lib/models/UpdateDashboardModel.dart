import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  int status;
  String message;
  Data data;

  HomeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
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
  List<CommonProductList> trendList;
  List<CommonProductList> topList;
  List<CommonProductList> popularList;
  List<CategoryList> categoryList;
  List<BannerList> bannerList;
  List<OfferList> offerList;

  Data({
    required this.trendList,
    required this.topList,
    required this.popularList,
    required this.categoryList,
    required this.bannerList,
    required this.offerList,
  });
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        trendList: (json["trend_list"] as List)
            .map((x) => CommonProductList.fromJson(x as Map<String, dynamic>))
            .toList(),
        topList: (json["top_list"] as List)
            .map((x) => CommonProductList.fromJson(x as Map<String, dynamic>))
            .toList(),
        popularList: (json["popular_list"] as List)
            .map((x) => CommonProductList.fromJson(x as Map<String, dynamic>))
            .toList(),
        categoryList: (json["category_list"] as List)
            .map((x) => CategoryList.fromJson(x as Map<String, dynamic>))
            .toList(),
        bannerList: (json["banner_list"] as List)
            .map((x) => BannerList.fromJson(x as Map<String, dynamic>))
            .toList(),
        offerList: List<OfferList>.from(
            json["offer_list"].map((x) => OfferList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trend_list": List<dynamic>.from(trendList.map((x) => x.toJson())),
        "top_list": List<dynamic>.from(topList.map((x) => x.toJson())),
        "popular_list": List<dynamic>.from(popularList.map((x) => x.toJson())),
        "category_list":
            List<dynamic>.from(categoryList.map((x) => x.toJson())),
        "banner_list": List<dynamic>.from(bannerList.map((x) => x.toJson())),
        "offer_list": List<dynamic>.from(offerList.map((x) => x.toJson())),
      };
}

class OfferList {
  int id;
  List<String> url;

  OfferList({
    required this.id,
    required this.url,
  });

  factory OfferList.fromJson(Map<String, dynamic> json) => OfferList(
        id: json["id"],
        url: List<String>.from(json["url"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": List<dynamic>.from(url.map((x) => x)),
      };
}

class BannerList {
  int id;
  String url;

  BannerList({
    required this.id,
    required this.url,
  });

  factory BannerList.fromJson(Map<String, dynamic> json) => BannerList(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}

class CategoryList {
  int id;
  String name;
  String thumbnailUrl;

  CategoryList({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        id: json["id"],
        name: json["name"],
        thumbnailUrl: json["thumbnail_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail_url": thumbnailUrl,
      };
}

class CommonProductList {
  int id;
  String name;
  int categoryId;
  int productId;
  int subcategoryId;
  int innerSubcategoryId;
  int brandId;
  int sku;
  String qty;
  List<String> images;
  List<String> thumbnailUrl;
  int isActive;
  String tags;
  int price;
  int discount;
  String discountUnit;
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
  String brandName;
  String brandThumbnailUrl;
  double? averageRating;
  RxInt? quantity;
  RxBool? isInCart;

  CommonProductList(
      {required this.id,
      required this.name,
      required this.categoryId,
      required this.productId,
      required this.subcategoryId,
      required this.innerSubcategoryId,
      required this.brandId,
      required this.sku,
      required this.qty,
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
      int quantity = 0,
      bool isInCart = false})
      : quantity = RxInt(quantity),
        isInCart = RxBool(isInCart);

  factory CommonProductList.fromJson(Map<String, dynamic> json) =>
      CommonProductList(
        id: json["id"],
        name: json["name"] ?? '',
        productId: json["product_id"] ?? 0,
        categoryId: json["category_id"] ?? 0,
        subcategoryId: json["subcategory_id"] ?? 0,
        innerSubcategoryId: json["inner_subcategory_id"] ?? 0,
        brandId: json["brand_id"] ?? 0,
        sku: json["sku"] ?? 0,
        qty: json["qty"] ?? '',
        images: List<String>.from(json["images"].map((x) => x) ?? ''),
        thumbnailUrl: List<String>.from(json["thumbnail_url"].map((x) => x)),
        isActive: json["is_active"] ?? 0,
        tags: json["tags"] ?? '',
        price: json["price"] ?? 0,
        discount: json["discount"] ?? 0,
        discountUnit: json["discount_unit"] ?? '',
        instockQty: json["instock_qty"] ?? 0,
        description: json["description"] ?? '',
        minQty: json["min_qty"] ?? 0,
        isFreeShipping: json["is_free_shipping"] ?? 0,
        isReturnPolicy: json["is_return_policy"] ?? 0,
        returnPolicyDays: json["return_policy_days"] ?? 0,
        shippingCharge: json["shipping_charge"] ?? 0,
        shippingChargeUnit: json["shipping_charge_unit"] ?? '',
        isFeatured: json["is_featured"] ?? 0,
        isTrending: json["is_trending"] ?? 0,
        isHotDeals: json["is_hot_deals"] ?? 0,
        tax: json["tax"] ?? 0,
        taxUnit: json["tax_unit"] ?? '',
        isVariations: json["is_variations"] ?? 0,
        productCategoryName: json["product_category_name"] ?? '',
        productCategoryThumbnailUrl:
            json["product_category_thumbnail_url"] ?? '',
        productSubCategoryName: json["product_sub_category_name"] ?? '',
        productSubCategoryThumbnailUrl:
            json["product_sub_category_thumbnail_url"] ?? '',
        productInnerSubCategoryName:
            json["product_inner_sub_category_name"] ?? '',
        productInnerSubCategoryThumbnailUrl:
            json["product_inner_sub_category_thumbnail_url"] ?? '',
        brandName: json["brand_name"] ?? '',
        brandThumbnailUrl: json["brand_thumbnail_url"] ?? '',
        averageRating: json["average_rating"]?.toDouble(),
        quantity: json["quantity"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "product_id": productId,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "inner_subcategory_id": innerSubcategoryId,
        "brand_id": brandId,
        "sku": sku,
        "qty": qty,
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
        "brand_name": brandName,
        "brand_thumbnail_url": brandThumbnailUrl,
        "average_rating": averageRating,
        "quantity": quantity?.value, // Convert RxInt to plain Dart int
        "is_in_cart": isInCart?.value,
      };

  CommonProductList copyWith({
    int? id,
    String? name,
    int? productId,
    int? categoryId,
    int? subcategoryId,
    int? innerSubcategoryId,
    int? brandId,
    int? sku,
    String? qty,
    List<String>? images,
    List<String>? thumbnailUrl,
    int? isActive,
    String? tags,
    int? price,
    int? discount,
    String? discountUnit,
    int? instockQty,
    String? description,
    int? minQty,
    int? isFreeShipping,
    int? isReturnPolicy,
    int? returnPolicyDays,
    int? shippingCharge,
    String? shippingChargeUnit,
    int? isFeatured,
    int? isTrending,
    int? isHotDeals,
    int? tax,
    String? taxUnit,
    int? isVariations,
    String? productCategoryName,
    String? productCategoryThumbnailUrl,
    String? productSubCategoryName,
    String? productSubCategoryThumbnailUrl,
    String? productInnerSubCategoryName,
    String? productInnerSubCategoryThumbnailUrl,
    String? brandName,
    String? brandThumbnailUrl,
    double? averageRating,
    int? quantity,
    bool? isInCart,
  }) {
    return CommonProductList(
        id: id ?? this.id,
        name: name ?? this.name,
        productId: productId ?? this.productId,
        categoryId: categoryId ?? this.categoryId,
        subcategoryId: subcategoryId ?? this.subcategoryId,
        innerSubcategoryId: innerSubcategoryId ?? this.innerSubcategoryId,
        brandId: brandId ?? this.brandId,
        sku: sku ?? this.sku,
        qty: qty ?? this.qty,
        images: images ?? this.images,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        isActive: isActive ?? this.isActive,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        discountUnit: discountUnit ?? this.discountUnit,
        tags: tags ?? this.tags,
        description: description ?? this.description,
        isFeatured: isFeatured ?? this.isFeatured,
        productCategoryName: productCategoryName ?? this.productCategoryName,
        productCategoryThumbnailUrl:
            productCategoryThumbnailUrl ?? this.productCategoryThumbnailUrl,
        productSubCategoryName:
            productSubCategoryName ?? this.productSubCategoryName,
        productSubCategoryThumbnailUrl: productSubCategoryThumbnailUrl ??
            this.productSubCategoryThumbnailUrl,
        productInnerSubCategoryName:
            productInnerSubCategoryName ?? this.productInnerSubCategoryName,
        productInnerSubCategoryThumbnailUrl:
            productInnerSubCategoryThumbnailUrl ??
                this.productInnerSubCategoryThumbnailUrl,
        brandName: brandName ?? this.brandName,
        brandThumbnailUrl: brandThumbnailUrl ?? this.brandThumbnailUrl,
        instockQty: instockQty ?? this.instockQty,
        minQty: minQty ?? this.minQty,
        isFreeShipping: isFreeShipping ?? this.isFreeShipping,
        isReturnPolicy: isReturnPolicy ?? this.isReturnPolicy,
        returnPolicyDays: returnPolicyDays ?? this.returnPolicyDays,
        shippingCharge: shippingCharge ?? this.shippingCharge,
        shippingChargeUnit: shippingChargeUnit ?? this.shippingChargeUnit,
        isTrending: isTrending ?? this.isTrending,
        isHotDeals: isHotDeals ?? this.isHotDeals,
        averageRating: averageRating ?? this.averageRating,
        tax: tax ?? this.tax,
        taxUnit: taxUnit ?? this.taxUnit,
        isVariations: isVariations ?? this.isVariations,
        quantity: quantity ?? this.quantity!.value,
        isInCart: isInCart == null ? this.isInCart!.value : false);
  }

  CommonProductList decrementQuantity() {
    if ((quantity!.value) > 1) {
      return copyWith(quantity: quantity!.value - 1);
    } else {
      // If quantity is 1, remove the item from the cart
      return copyWith(quantity: 0, isInCart: false);
    }
  }

  double getFinalPrice() {
    return price.toDouble() + shippingCharge.toDouble() - discount.toDouble();
  }

  int getStoredQuantity() {
    return quantity!.value ?? 0;
  }
}
