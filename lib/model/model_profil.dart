import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

ModelProfile profileFromJson(String str) =>
    ModelProfile.fromJson(json.decode(str));

String profileToJson(ModelProfile data) => json.encode(data.toJson());

class ModelProfile {
  bool? success;
  String? message;
  List<Datum>? data;

  ModelProfile({
    this.success,
    this.message,
    this.data,
  });

  factory ModelProfile.fromJson(Map<String, dynamic> json) => ModelProfile(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  static Future<ModelProfile> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse("$urlAPI/api/profile"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}",
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ModelProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}

class Datum {
  int? id;
  String? image;
  String? frontName;
  String? backName;
  String? dateOfBirth;
  String? createdAt;
  String? updatedAt;

  Datum({
    this.id,
    this.image,
    this.frontName,
    this.backName,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        image: json["image"],
        frontName: json["front_name"],
        backName: json["back_name"],
        dateOfBirth: json["date_of_birth"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "front_name": frontName,
        "back_name": backName,
        "date_of_birth": dateOfBirth,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  static Future<ModelProfile> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse("$urlAPI/api/profile"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}",
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ModelProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}
