// To parse this JSON data, do
//
//     final favouriteModel = favouriteModelFromJson(jsonString);

import 'dart:convert';

import 'package:gifthamperz/models/UpdateDashboardModel.dart';

FavouriteModel favouriteModelFromJson(String str) =>
    FavouriteModel.fromJson(json.decode(str));

String favouriteModelToJson(FavouriteModel data) => json.encode(data.toJson());

class FavouriteModel {
  int status;
  String message;
  List<CommonProductList> data;

  FavouriteModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json) => FavouriteModel(
        status: json["status"],
        message: json["message"],
        data: List<CommonProductList>.from(
            json["data"].map((x) => CommonProductList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FavouriteList {
  int id;
  int userId;
  int productId;
  String type;
  String name;

  FavouriteList({
    required this.id,
    required this.userId,
    required this.productId,
    required this.type,
    required this.name,
  });

  factory FavouriteList.fromJson(Map<String, dynamic> json) => FavouriteList(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        type: json["type"] ?? '',
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "type": type ?? '',
        "name": name ?? '',
      };
}
