// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  int status;
  String message;
  UserData user;

  LoginModel({
    required this.status,
    required this.message,
    required this.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        message: json["message"],
        user: UserData.fromJson(json["user"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user": user.toJson(),
      };
}

class UserData {
  int id;
  String userName;
  String emailId;
  String mobileNo;
  String firstName;
  String lastName;
  DateTime? dateOfBirth;
  String gender;
  dynamic profilePic;
  String isGuestLogin;
  int isActive;
  int isBlock;
  int isRegister;
  dynamic securityToken;
  String createdUser;
  DateTime createdAt;
  DateTime updatedAt;
  String deletedAt;
  String createdBy;
  String updatedBy;
  String deletedBy;
  String token;

  UserData({
    required this.id,
    required this.userName,
    required this.emailId,
    required this.mobileNo,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.profilePic,
    required this.isGuestLogin,
    required this.isActive,
    required this.isBlock,
    required this.isRegister,
    required this.securityToken,
    required this.createdUser,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedBy,
    required this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"] ?? 0,
        userName: json["user_name"] ?? '',
        emailId: json["email_id"] ?? '',
        mobileNo: json["mobile_no"] ?? '',
        firstName: json["first_name"] ?? '',
        lastName: json["last_name"] ?? '',
        dateOfBirth:
            json["date_of_birth"] != null && json["date_of_birth"] != ''
                ? DateTime.parse(json["date_of_birth"])
                : null,
        gender: json["gender"] ?? '',
        profilePic: json["profile_pic"],
        isGuestLogin: json["is_guest_login"] ?? '',
        isActive: json["is_active"],
        isBlock: json["is_block"],
        isRegister: json["is_register"],
        securityToken: json["security_token"],
        createdUser: json["created_user"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"].toString() ?? '',
        createdBy: json["created_by"].toString() ?? '',
        updatedBy: json["updated_by"].toString() ?? '',
        deletedBy: json["deleted_by"].toString() ?? '',
        token: json["token"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "email_id": emailId,
        "mobile_no": mobileNo,
        "first_name": firstName,
        "last_name": lastName,
        "date_of_birth": dateOfBirth != null
            ? "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}"
            : null,
        "gender": gender,
        "profile_pic": profilePic,
        "is_guest_login": isGuestLogin,
        "is_active": isActive,
        "is_block": isBlock,
        "is_register": isRegister,
        "security_token": securityToken,
        "created_user": createdUser,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt.toString() ?? '',
        "created_by": createdBy.toString() ?? '',
        "updated_by": updatedBy.toString() ?? '',
        "deleted_by": deletedBy.toString() ?? '',
        "token": token,
      };
}
