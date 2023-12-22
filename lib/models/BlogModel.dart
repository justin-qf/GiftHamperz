// To parse this JSON data, do
//
//     final blogModel = blogModelFromJson(jsonString);

import 'dart:convert';

BlogModel blogModelFromJson(String str) => BlogModel.fromJson(json.decode(str));

String blogModelToJson(BlogModel data) => json.encode(data.toJson());

class BlogModel {
  int status;
  String message;
  Data data;

  BlogModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
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
  List<BlogDataList> data;
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
        data: List<BlogDataList>.from(
            json["data"].map((x) => BlogDataList.fromJson(x))),
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

class BlogDataList {
  int blogTypeId;
  String thumbnailUrl;
  String imgUrl;
  String slug;
  String title;
  String shortDescription;
  String description;
  int readDuration;
  String blogBy;
  String? blogByDesignation;
  int isActive;
  String createdUser;
  DateTime createdAt;
  String blogTypeName;

  BlogDataList({
    required this.blogTypeId,
    required this.thumbnailUrl,
    required this.imgUrl,
    required this.slug,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.readDuration,
    required this.blogBy,
    required this.blogByDesignation,
    required this.isActive,
    required this.createdUser,
    required this.createdAt,
    required this.blogTypeName,
  });

  factory BlogDataList.fromJson(Map<String, dynamic> json) => BlogDataList(
        blogTypeId: json["blog_type_id"],
        thumbnailUrl: json["thumbnail_url"],
        imgUrl: json["img_url"],
        slug: json["slug"],
        title: json["title"],
        shortDescription: json["short_description"],
        description: json["description"],
        readDuration: json["read_duration"],
        blogBy: json["blog_by"],
        blogByDesignation: json["blog_by_designation"],
        isActive: json["is_active"],
        createdUser: json["created_user"],
        createdAt: DateTime.parse(json["created_at"]),
        blogTypeName: json["blog_type_name"],
      );

  Map<String, dynamic> toJson() => {
        "blog_type_id": blogTypeId,
        "thumbnail_url": thumbnailUrl,
        "img_url": imgUrl,
        "slug": slug,
        "title": title,
        "short_description": shortDescription,
        "description": description,
        "read_duration": readDuration,
        "blog_by": blogBy,
        "blog_by_designation": blogByDesignation,
        "is_active": isActive,
        "created_user": createdUser,
        "created_at": createdAt.toIso8601String(),
        "blog_type_name": blogTypeName,
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
