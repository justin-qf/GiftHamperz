import 'dart:convert';

BannerModel bannerModelFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  int status;
  String message;
  List<BannerList> data;

  BannerModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        status: json["status"],
        message: json["message"],
        data: List<BannerList>.from(json["data"].map((x) => BannerList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
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
