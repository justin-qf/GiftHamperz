import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int status;
  String message;
  UserDetailData data;

  UserModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"],
        message: json["message"],
        data: UserDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class UserDetailData {
  int? id;
  String? userName;
  String? emailId;
  DateTime? dateOfBirth;
  String? gender;
  String? profilePic;

  UserDetailData({
    required this.id,
    required this.userName,
    required this.emailId,
    required this.dateOfBirth,
    required this.gender,
    required this.profilePic,
  });

  factory UserDetailData.fromJson(Map<String, dynamic> json) => UserDetailData(
        id: json["id"] ?? 0,
        userName: json["user_name"] ?? '',
        emailId: json["email_id"] ?? '',
        dateOfBirth: json["date_of_birth"] != null
            ? DateTime.parse(json["date_of_birth"])
            : null,
        gender: json["gender"] ?? '',
        profilePic: json["profile_pic"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "user_name": userName,
        "email_id": emailId,
        "date_of_birth":
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "profile_pic": profilePic,
      };
}
