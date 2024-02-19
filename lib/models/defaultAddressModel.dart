import 'dart:convert';

DefaultAddressModel defaultAddressModelFromJson(String str) =>
    DefaultAddressModel.fromJson(json.decode(str));

String defaultAddressModelToJson(DefaultAddressModel data) =>
    json.encode(data.toJson());

class DefaultAddressModel {
  int status;
  String message;
  DefaultAddressData data;

  DefaultAddressModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DefaultAddressModel.fromJson(Map<String, dynamic> json) =>
      DefaultAddressModel(
        status: json["status"],
        message: json["message"],
        data: DefaultAddressData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class DefaultAddressData {
  int id;
  int userId;
  String address;
  int cityId;
  String pincode;
  int isOffice;
  int isActive;
  int isDefault;
  String createdUser;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int createdBy;
  dynamic updatedBy;
  dynamic deletedBy;

  DefaultAddressData({
    required this.id,
    required this.userId,
    required this.address,
    required this.cityId,
    required this.pincode,
    required this.isOffice,
    required this.isActive,
    required this.isDefault,
    required this.createdUser,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedBy,
  });

  factory DefaultAddressData.fromJson(Map<String, dynamic> json) =>
      DefaultAddressData(
        id: json["id"],
        userId: json["user_id"],
        address: json["address"],
        cityId: json["city_id"],
        pincode: json["pincode"],
        isOffice: json["is_office"],
        isActive: json["is_active"],
        isDefault: json["is_default"],
        createdUser: json["created_user"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        deletedBy: json["deleted_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "address": address,
        "city_id": cityId,
        "pincode": pincode,
        "is_office": isOffice,
        "is_active": isActive,
        "is_default": isDefault,
        "created_user": createdUser,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "deleted_by": deletedBy,
      };
}
