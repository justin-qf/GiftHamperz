import 'dart:convert';

import 'package:gifthamperz/models/ProductModel.dart';
import 'package:gifthamperz/models/UpdateDashboardModel.dart';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  int status;
  String message;
  Data data;

  OrderModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
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
  List<OrderData> data;
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
        data: List<OrderData>.from(
            json["data"].map((x) => OrderData.fromJson(x))),
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

class OrderData {
  int id;
  String orderId;
  int customerId;
  DateTime dateOfOrder;
  int billingAddressId;
  int shippingAddressId;
  String totalAmount;
  dynamic promocodeId;
  String discount;
  DateTime dateOfDelivery;
  String timeOfDelivery;
  String shipingCharge;
  int isPackingSeperetly;
  String gstNumber;
  String address;
  int cityId;
  String pincode;
  int isOffice;
  int isActive;
  String cityName;
  int stateId;
  String stateName;
  int stateCode;
  String shippingAddress;
  int shippingAddressCityId;
  String shippingAddressPincode;
  int shippingAddressIsOffice;
  int shippingAddressIsActive;
  String shippingAddressCityName;
  int shippingAddressStateId;
  String shippingAddressStateName;
  int shippingAddressStateCode;
  List<OrderDetail> orderDetails;

  OrderData({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.dateOfOrder,
    required this.billingAddressId,
    required this.shippingAddressId,
    required this.totalAmount,
    required this.promocodeId,
    required this.discount,
    required this.dateOfDelivery,
    required this.timeOfDelivery,
    required this.shipingCharge,
    required this.isPackingSeperetly,
    required this.gstNumber,
    required this.address,
    required this.cityId,
    required this.pincode,
    required this.isOffice,
    required this.isActive,
    required this.cityName,
    required this.stateId,
    required this.stateName,
    required this.stateCode,
    required this.shippingAddress,
    required this.shippingAddressCityId,
    required this.shippingAddressPincode,
    required this.shippingAddressIsOffice,
    required this.shippingAddressIsActive,
    required this.shippingAddressCityName,
    required this.shippingAddressStateId,
    required this.shippingAddressStateName,
    required this.shippingAddressStateCode,
    required this.orderDetails,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        id: json["id"],
        orderId: json["order_id"],
        customerId: json["customer_id"],
        dateOfOrder: DateTime.parse(json["date_of_order"].toString() ?? ''),
        billingAddressId: json["billing_address_id"],
        shippingAddressId: json["shipping_address_id"],
        totalAmount: json["total_amount"],
        promocodeId: json["promocode_id"] ?? 0,
        discount: json["discount"],
        dateOfDelivery:
            DateTime.parse(json["date_of_delivery"].toString() ?? ''),
        timeOfDelivery: json["time_of_delivery"] ?? '',
        shipingCharge: json["shiping_charge"],
        isPackingSeperetly: json["is_packing_seperetly"],
        gstNumber: json["gst_number"],
        address: json["address"],
        cityId: json["city_id"],
        pincode: json["pincode"],
        isOffice: json["is_office"],
        isActive: json["is_active"],
        cityName: json["city_name"],
        stateId: json["state_id"],
        stateName: json["state_name"],
        stateCode: json["state_code"],
        shippingAddress: json["shipping_address"],
        shippingAddressCityId: json["shipping_address_city_id"],
        shippingAddressPincode: json["shipping_address_pincode"],
        shippingAddressIsOffice: json["shipping_address_is_office"],
        shippingAddressIsActive: json["shipping_address_is_active"],
        shippingAddressCityName: json["shipping_address_city_name"],
        shippingAddressStateId: json["shipping_address_state_id"],
        shippingAddressStateName: json["shipping_address_state_name"],
        shippingAddressStateCode: json["shipping_address_state_code"],
        orderDetails: List<OrderDetail>.from(
            json["order_details"].map((x) => OrderDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "customer_id": customerId,
        "date_of_order":
            "${dateOfOrder.year.toString().padLeft(4, '0')}-${dateOfOrder.month.toString().padLeft(2, '0')}-${dateOfOrder.day.toString().padLeft(2, '0')}",
        "billing_address_id": billingAddressId,
        "shipping_address_id": shippingAddressId,
        "total_amount": totalAmount,
        "promocode_id": promocodeId,
        "discount": discount,
        "date_of_delivery":
            "${dateOfDelivery.year.toString().padLeft(4, '0')}-${dateOfDelivery.month.toString().padLeft(2, '0')}-${dateOfDelivery.day.toString().padLeft(2, '0')}",
        "time_of_delivery": timeOfDelivery,
        "shiping_charge": shipingCharge,
        "is_packing_seperetly": isPackingSeperetly,
        "gst_number": gstNumber,
        "address": address,
        "city_id": cityId,
        "pincode": pincode,
        "is_office": isOffice,
        "is_active": isActive,
        "city_name": cityName,
        "state_id": stateId,
        "state_name": stateName,
        "state_code": stateCode,
        "shipping_address": shippingAddress,
        "shipping_address_city_id": shippingAddressCityId,
        "shipping_address_pincode": shippingAddressPincode,
        "shipping_address_is_office": shippingAddressIsOffice,
        "shipping_address_is_active": shippingAddressIsActive,
        "shipping_address_city_name": shippingAddressCityName,
        "shipping_address_state_id": shippingAddressStateId,
        "shipping_address_state_name": shippingAddressStateName,
        "shipping_address_state_code": shippingAddressStateCode,
        "order_details":
            List<dynamic>.from(orderDetails.map((x) => x.toJson())),
      };
}

class OrderDetail {
  int id;
  int orderId;
  String qty;
  String rate;
  String totalAmount;
  dynamic dateOfDelivery;
  dynamic timeOfDelivery;
  int productId;
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
  String discountUnit;
  int instockQty;
  String description;
  dynamic minQty;
  int isFreeShipping;
  int isReturnPolicy;
  int returnPolicyDays;
  int shippingCharge;
  String shippingChargeUnit;
  int isFeatured;
  int isTrending;
  int isHotDeals;
  dynamic tax;
  dynamic taxUnit;
  int isVariations;
  String productCategoryName;
  String productCategoryThumbnailUrl;
  String productSubCategoryName;
  String productSubCategoryThumbnailUrl;
  String productInnerSubCategoryName;
  String productInnerSubCategoryThumbnailUrl;
  String brandName;
  String brandThumbnailUrl;

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.qty,
    required this.rate,
    required this.totalAmount,
    required this.dateOfDelivery,
    required this.timeOfDelivery,
    required this.productId,
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
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["id"],
        orderId: json["order_id"],
        qty: json["qty"] ?? '',
        rate: json["rate"] ?? '',
        totalAmount: json["total_amount"] ?? '',
        dateOfDelivery: json["date_of_delivery"],
        timeOfDelivery: json["time_of_delivery"],
        productId: json["product_id"],
        name: json["name"] ?? '',
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        innerSubcategoryId: json["inner_subcategory_id"],
        brandId: json["brand_id"],
        sku: json["sku"],
        images: List<String>.from(json["images"].map((x) => x) ?? ''),
        thumbnailUrl:
            List<String>.from(json["thumbnail_url"].map((x) => x) ?? ''),
        isActive: json["is_active"],
        tags: json["tags"] ?? '',
        price: json["price"],
        discount: json["discount"],
        discountUnit: json["discount_unit"] ?? '',
        instockQty: json["instock_qty"],
        description: json["description"] ?? '',
        minQty: json["min_qty"],
        isFreeShipping: json["is_free_shipping"],
        isReturnPolicy: json["is_return_policy"],
        returnPolicyDays: json["return_policy_days"],
        shippingCharge: json["shipping_charge"],
        shippingChargeUnit: json["shipping_charge_unit"] ?? '',
        isFeatured: json["is_featured"],
        isTrending: json["is_trending"],
        isHotDeals: json["is_hot_deals"],
        tax: json["tax"],
        taxUnit: json["tax_unit"],
        isVariations: json["is_variations"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "qty": qty,
        "rate": rate,
        "total_amount": totalAmount,
        "date_of_delivery": dateOfDelivery,
        "time_of_delivery": timeOfDelivery,
        "product_id": productId,
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
        "brand_name": brandName,
        "brand_thumbnail_url": brandThumbnailUrl,
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
