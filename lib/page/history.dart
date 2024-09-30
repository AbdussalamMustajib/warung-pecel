import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../model/model_monthly_report.dart';
import '../model/model_report.dart';
import '../space_theme.dart';
import '../text_adaptive.dart';
import '../text_style_theme.dart';
import '../theme_color.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final TextEditingController _tanggalMulaiController = TextEditingController();
  final TextEditingController _tanggalAkhirController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<ModelMonthlyReport>(
              future: ModelMonthlyReport.fetchDataReport(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: width * 0.05,
                        right: width * 0.05,
                        bottom: width * 0.05,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(width * 0.05),
                        child: GraphicReports(
                          context: context,
                          data: snapshot.data!,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            pSpaceMedium(context),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    DateTime finalDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    setState(() {
                      // Mengubah finalDateTime menjadi format yyyy-MM-dd HH:mm:ss
                      String formattedDateTime =
                          DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(finalDateTime);
                      _tanggalMulaiController.text = formattedDateTime;
                    });
                  } else {
                    print("Time is not selected");
                  }
                } else {
                  print("Date is not selected");
                }
              },
              child: TextFormField(
                showCursor: true,
                cursorColor: Colors.black45,
                enabled: false,
                style: pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "  Tanggal Awal  ",
                  labelStyle:
                      pBoldWhiteTextStyle.copyWith(color: pDarkBrownColor),
                  hintText: _tanggalMulaiController.text,
                  hintStyle: pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                      color: pDarkBrownColor,
                    ),
                    borderRadius: BorderRadius.circular(
                        width > height ? width * 0.02 : height * 0.02),
                  ),
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                ),
                controller: _tanggalMulaiController,
              ),
            ),
            pSpaceMedium(context),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    DateTime finalDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    setState(() {
                      // Mengubah finalDateTime menjadi format yyyy-MM-dd HH:mm:ss
                      String formattedDateTime =
                          DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(finalDateTime);
                      _tanggalAkhirController.text = formattedDateTime;
                    });
                  } else {
                    print("Time is not selected");
                  }
                } else {
                  print("Date is not selected");
                }
              },
              child: TextFormField(
                showCursor: true,
                cursorColor: Colors.black45,
                enabled: false,
                style: pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "  Tanggal Akhir  ",
                  labelStyle:
                      pBoldWhiteTextStyle.copyWith(color: pDarkBrownColor),
                  hintText: _tanggalAkhirController.text,
                  hintStyle: pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                      color: pDarkBrownColor,
                    ),
                    borderRadius: BorderRadius.circular(
                        width > height ? width * 0.02 : height * 0.02),
                  ),
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                ),
                controller: _tanggalAkhirController,
              ),
            ),
            pSpaceMedium(context),
            FutureBuilder<List<ModelReport>>(
              future: ModelReport.fetchReports(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.all(width * 0.02),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(width * 0.02),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: width * 0.2,
                                        height: width * 0.2,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: pDarkBrownColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(width * 0.05),
                                          ),
                                        ),
                                        child: Container(
                                          width: width * 0.18,
                                          height: width * 0.18,
                                          decoration: BoxDecoration(
                                            color: pDarkBrownColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(width * 0.01),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(width * 0.05),
                                            ),
                                            child: snapshot.data![index].tipe ==
                                                    "M"
                                                ? Icon(
                                                    Icons
                                                        .monetization_on_rounded,
                                                    color: pLightBrownColor,
                                                    size: width * 0.1,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .money_off_csred_rounded,
                                                    color: pLightBrownColor,
                                                    size: width * 0.1,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(width * 0.02),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index].namaBarang!,
                                              style:
                                                  pBoldBlackTextStyle.copyWith(
                                                fontSize:
                                                    const AdaptiveTextSize()
                                                        .getadaptiveTextSize(
                                                            context, 16),
                                              ),
                                            ),
                                            pSpaceSmall(context),
                                            Text(
                                              DateFormat('dd-MM-yyyy').format(
                                                  snapshot
                                                      .data![index].tanggal!),
                                              style:
                                                  pBoldBlackTextStyle.copyWith(
                                                fontSize:
                                                    const AdaptiveTextSize()
                                                        .getadaptiveTextSize(
                                                            context, 16),
                                                color: pSecondGreyColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    formatter
                                        .format(snapshot.data![index].harga),
                                    style: pBoldBlackTextStyle.copyWith(
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 12),
                                      color: snapshot.data![index].tipe == "M"
                                          ? pGreenColor
                                          : pRedColor,
                                    ),
                                  ),
                                ],
                              ),
                              pSpaceSmall(context),
                              Text(
                                "Pencatatan oleh ${snapshot.data![index].namaOrang} berupa ${snapshot.data![index].namaBarang} dengan keterangan ${snapshot.data![index].keterangan} dengan total harga ${formatter.format(snapshot.data![index].harga)}",
                                style: pBlackTextStyle.copyWith(
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 14),
                                ),
                              ),
                              const Divider(
                                thickness: 5,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget GraphicReports({
  required BuildContext context,
  required ModelMonthlyReport data,
}) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      interval: 1,
      getTitlesWidget: (value, meta) {
        String date = value.toInt() < data.reportsIn!.length
            ? "${data.reportsIn![value.toInt()].date!.day}/${data.reportsIn![value.toInt()].date!.month}"
            : "";
        return SideTitleWidget(
            axisSide: meta.axisSide,
            child: Column(
              children: [
                value.toInt() % 2 == 1
                    ? Container(
                        height: height * 0.02,
                      )
                    : SizedBox(),
                Text(date),
              ],
            ));
      },
    );
  }

  return Container(
    height: width * 0.7,
    width: width * 2,
    child: LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(),
            rightTitles: AxisTitles(),
            bottomTitles: AxisTitles(sideTitles: _bottomTitles())),
        borderData: FlBorderData(
          show: false,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        minX: 0,
        maxX: data.reportsIn!.length.toDouble(),
        minY: 0,
        maxY: data.highestReportIn! == 0 && data.highestReportOut! == 0
            ? 100000
            : data.highestReportIn! > data.highestReportOut!
                ? data.highestReportIn!.toDouble() +
                    data.highestReportIn!.toDouble() * 0.2
                : data.highestReportOut!.toDouble() +
                    data.highestReportOut!.toDouble() * 0.2,
        lineBarsData: [
          LineChartBarData(
            spots: data.reportsOut!
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(),
                    double.parse(entry.value.totalHarga.toString())))
                .toList(),
            isCurved: false,
            color: Colors.red,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.withAlpha(100),
            ),
          ),
          LineChartBarData(
            spots: data.reportsIn!
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(),
                    double.parse(entry.value.totalHarga.toString())))
                .toList(),
            isCurved: false,
            color: Colors.green,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withAlpha(100),
            ),
          ),
        ],
      ),
    ),
  );
}
