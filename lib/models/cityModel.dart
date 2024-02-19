import 'dart:convert';

CityModel cityModelFromJson(String str) => CityModel.fromJson(json.decode(str));

String cityModelToJson(CityModel data) => json.encode(data.toJson());

class CityModel {
  int status;
  String message;
  List<CityList> data;

  CityModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        status: json["status"],
        message: json["message"],
        data: List<CityList>.from(json["data"].map((x) => CityList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CityList {
  int id;
  String name;
  int stateId;
  String stateName;

  CityList({
    required this.id,
    required this.name,
    required this.stateId,
    required this.stateName,
  });

  factory CityList.fromJson(Map<String, dynamic> json) => CityList(
        id: json["id"],
        name: json["name"],
        stateId: json["state_id"],
        stateName: json["state_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "state_id": stateId,
        "state_name": stateName,
      };
}
