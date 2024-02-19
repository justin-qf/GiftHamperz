// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

ReviewModel reviewModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  int status;
  String message;
  Data data;

  ReviewModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
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
  List<ReviewData> data;
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
        data: List<ReviewData>.from(
            json["data"].map((x) => ReviewData.fromJson(x))),
        firstPageUrl: json["first_page_url"] ?? '',
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"] ?? '',
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"] ?? '',
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

class ReviewData {
  int id;
  int userId;
  int productId;
  String review;
  String comment;
  String createdAt;
  List<String> images;
  dynamic userName;
  dynamic firstName;
  dynamic lastName;
  dynamic profilePic;

  ReviewData({
    required this.id,
    required this.userId,
    required this.productId,
    required this.review,
    required this.comment,
    required this.createdAt,
    required this.images,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        review: json["review"] ?? '',
        comment: json["comment"] ?? '',
        createdAt: json["created_at"] ?? '',
        images: List<String>.from(json["images"].map((x) => x) ?? ''),
        userName: json["user_name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePic: json["profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "review": review,
        "comment": comment,
        "created_at": createdAt,
        "images": List<dynamic>.from(images.map((x) => x)),
        "user_name": userName,
        "first_name": firstName,
        "profile_pic": profilePic,
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
        url: json["url"] ?? '',
        label: json["label"] ?? '',
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
