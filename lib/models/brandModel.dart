import 'dart:convert';

BrandModel brandModelFromJson(String str) =>
    BrandModel.fromJson(json.decode(str));

String brandModelToJson(BrandModel data) => json.encode(data.toJson());

class BrandModel {
  int status;
  String message;
  List<BrandList> data;

  BrandModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        status: json["status"],
        message: json["message"],
        data: List<BrandList>.from(json["data"].map((x) => BrandList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BrandList {
  int id;
  String name;
  String thumbnailUrl;

  BrandList({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
  });

  factory BrandList.fromJson(Map<String, dynamic> json) => BrandList(
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
