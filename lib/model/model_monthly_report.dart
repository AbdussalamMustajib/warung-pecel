import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

ModelMonthlyReport modelMonthlyReportFromJson(String str) =>
    ModelMonthlyReport.fromJson(json.decode(str));

String modelMonthlyReportToJson(ModelMonthlyReport data) =>
    json.encode(data.toJson());

class ModelMonthlyReport {
  List<Reports>? reportsIn;
  List<Reports>? reportsOut;
  int? highestReportIn;
  int? highestReportOut;

  ModelMonthlyReport({
    this.reportsIn,
    this.reportsOut,
    this.highestReportIn,
    this.highestReportOut,
  });

  factory ModelMonthlyReport.fromJson(Map<String, dynamic> json) =>
      ModelMonthlyReport(
        reportsIn: json["reports_in"] == null
            ? []
            : List<Reports>.from(
                json["reports_in"]!.map((x) => Reports.fromJson(x))),
        reportsOut: json["reports_out"] == null
            ? []
            : List<Reports>.from(
                json["reports_out"]!.map((x) => Reports.fromJson(x))),
        highestReportIn: json["highest_report_in"] == 0
            ? 0
            : int.parse(json["highest_report_in"]),
        highestReportOut: json["highest_report_out"] == 0
            ? 0
            : int.parse(json["highest_report_out"]) * -1,
      );

  Map<String, dynamic> toJson() => {
        "reports_in": reportsIn == null
            ? []
            : List<dynamic>.from(reportsIn!.map((x) => x.toJson())),
        "reports_out": reportsOut == null
            ? []
            : List<dynamic>.from(reportsOut!.map((x) => x.toJson())),
        "highest_report_in": highestReportIn,
        "highest_report_out": highestReportOut,
      };

  static Future<ModelMonthlyReport> fetchDataReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse("$urlAPI/api/monthlyReport"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}",
      },
    );
    print(response.body);
    return ModelMonthlyReport.fromJson(jsonDecode(response.body));
  }
}

class Reports {
  DateTime? date;
  int? totalHarga;

  Reports({
    this.date,
    this.totalHarga,
  });

  factory Reports.fromJson(Map<String, dynamic> json) => Reports(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        totalHarga: json["total_harga"] != 0
            ? int.parse(json["total_harga"]) < 0
                ? int.parse(json["total_harga"]) * -1
                : int.parse(json["total_harga"])
            : 0,
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "total_harga": totalHarga,
      };
}
