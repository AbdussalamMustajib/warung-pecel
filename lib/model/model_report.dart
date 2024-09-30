// To parse this JSON data, do
//
//     final modelReport = modelReportFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

List<ModelReport> modelReportFromJson(String str) => List<ModelReport>.from(
    json.decode(str).map((x) => ModelReport.fromJson(x)));

String modelReportToJson(List<ModelReport> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelReport {
  int? id;
  String? tipe;
  String? namaBarang;
  String? namaOrang;
  int? harga;
  String? keterangan;
  DateTime? tanggal;
  DateTime? createdAt;
  DateTime? updatedAt;

  ModelReport({
    this.id,
    this.tipe,
    this.namaBarang,
    this.namaOrang,
    this.harga,
    this.keterangan,
    this.tanggal,
    this.createdAt,
    this.updatedAt,
  });

  factory ModelReport.fromJson(Map<String, dynamic> json) => ModelReport(
        id: json["id"],
        tipe: json["tipe"],
        namaBarang: json["nama_barang"],
        namaOrang: json["nama_orang"],
        harga: json["harga"],
        keterangan: json["keterangan"],
        tanggal:
            json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipe": tipe,
        "nama_barang": namaBarang,
        "nama_orang": namaOrang,
        "harga": harga,
        "keterangan": keterangan,
        "tanggal": tanggal?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  static Future<List<ModelReport>> fetchReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse("$urlAPI/api/reports"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      var hasil = modelReportFromJson(response.body);
      return hasil;
    } else {
      throw Exception('Failed to load orders from API');
    }
  }
}
