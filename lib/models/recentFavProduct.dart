import 'dart:convert';

import 'package:gifthamperz/models/UpdateDashboardModel.dart';

RecentFavModel recentFavModelFromJson(String str) =>
    RecentFavModel.fromJson(json.decode(str));

String recentFavModelToJson(RecentFavModel data) => json.encode(data.toJson());

class RecentFavModel {
  int status;
  String message;
  List<CommonProductList> data;

  RecentFavModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RecentFavModel.fromJson(Map<String, dynamic> json) => RecentFavModel(
        status: json["status"],
        message: json["message"],
        data: List<CommonProductList>.from(json["data"].map((x) => CommonProductList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
