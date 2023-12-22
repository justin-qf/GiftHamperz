import 'dart:convert';

BlogTypeModel blogTypeModelFromJson(String str) =>
    BlogTypeModel.fromJson(json.decode(str));

String blogTypeModelToJson(BlogTypeModel data) => json.encode(data.toJson());

class BlogTypeModel {
  int status;
  String message;
  List<BlogTypeList> data;

  BlogTypeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BlogTypeModel.fromJson(Map<String, dynamic> json) => BlogTypeModel(
        status: json["status"],
        message: json["message"],
        data: List<BlogTypeList>.from(json["data"].map((x) => BlogTypeList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BlogTypeList {
  int id;
  String name;

  BlogTypeList({
    required this.id,
    required this.name,
  });

  factory BlogTypeList.fromJson(Map<String, dynamic> json) => BlogTypeList(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
