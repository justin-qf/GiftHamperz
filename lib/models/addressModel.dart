// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  int status;
  String message;
  AddressListData data;

  AddressModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        status: json["status"],
        message: json["message"],
        data: AddressListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class AddressListData {
  int currentPage;
  List<AddressListItem> data;
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

  AddressListData({
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

  factory AddressListData.fromJson(Map<String, dynamic> json) =>
      AddressListData(
        currentPage: json["current_page"],
        data: List<AddressListItem>.from(
            json["data"].map((x) => AddressListItem.fromJson(x))),
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

class AddressListItem {
  int id;
  int userId;
  String address;
  int cityId;
  String pincode;
  int isOffice;
  int isActive;
  String cityName;
  int stateId;
  String name;
  int stateCode;

  AddressListItem({
    required this.id,
    required this.userId,
    required this.address,
    required this.cityId,
    required this.pincode,
    required this.isOffice,
    required this.isActive,
    required this.cityName,
    required this.stateId,
    required this.name,
    required this.stateCode,
  });

  factory AddressListItem.fromJson(Map<String, dynamic> json) =>
      AddressListItem(
        id: json["id"],
        userId: json["user_id"],
        address: json["address"],
        cityId: json["city_id"],
        pincode: json["pincode"],
        isOffice: json["is_office"],
        isActive: json["is_active"],
        cityName: json["city_name"],
        stateId: json["state_id"],
        name: json["name"],
        stateCode: json["state_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "address": address,
        "city_id": cityId,
        "pincode": pincode,
        "is_office": isOffice,
        "is_active": isActive,
        "city_name": cityName,
        "state_id": stateId,
        "name": name,
        "state_code": stateCode,
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
