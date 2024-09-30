import 'dart:io';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pecel_pincuk/widget_component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../model/model_report.dart';
import '../space_theme.dart';
import '../text_adaptive.dart';
import '../text_style_theme.dart';
import '../theme_color.dart';
import 'main_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _key = GlobalKey<FormState>();

  var nominalProd = MoneyMaskedTextController(
      thousandSeparator: '.', precision: 0, decimalSeparator: '');
  final TextEditingController _tanggalController = TextEditingController();

  save() {
    final form = _key.currentState;
    print(form);
    if (form!.validate()) {
      form.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          "assets/logo-appbar.svg",
          fit: BoxFit.contain,
        ),
        backgroundColor: pWhiteColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width,
              padding: EdgeInsets.all(width * 0.03),
              child: FutureBuilder<List<ModelReport>>(
                  future: ModelReport.fetchReports(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              kontainer(
                                context: context,
                                width: width,
                                title: "Uang Masuk",
                                money: snapshot.data!
                                    .where((item) => item.tipe == "M")
                                    .toList()
                                    .fold(
                                        0,
                                        (previousValue, item) =>
                                            previousValue + item.harga!),
                              ),
                              kontainer(
                                context: context,
                                width: width,
                                title: "Uang Keluar",
                                money: snapshot.data!
                                        .where((item) => item.tipe == "K")
                                        .toList()
                                        .fold(
                                            0,
                                            (previousValue, item) =>
                                                previousValue + item.harga!) *
                                    -1,
                              ),
                            ],
                          ),
                          pSpaceSmall(context),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              kontainerButton(
                                context: context,
                                width: width,
                                height: height,
                                onPress: () {
                                  nominalProd.updateValue(0.0);
                                  addOrEditReport(method: "add", tipe: "M");
                                },
                                iconSvg: "assets/logo-jual.svg",
                              ),
                              kontainerButton(
                                context: context,
                                width: width,
                                height: height,
                                onPress: () {
                                  nominalProd.updateValue(0.0);
                                  addOrEditReport(method: "add", tipe: "K");
                                },
                                iconSvg: "assets/logo-beli.svg",
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }),
            ),
            Container(
              padding: EdgeInsets.all(width * 0.05),
              decoration: BoxDecoration(
                color: pWhiteColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(width * 0.1),
                ),
              ),
              child: Column(
                children: [
                  pSpaceSmall(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "History",
                        style: pBoldBlackTextStyle.copyWith(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 16),
                        ),
                      ),
                      Text(
                        "Last Update",
                        style: pBoldBlackTextStyle.copyWith(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 16),
                          color: pSecondGreyColor,
                        ),
                      ),
                    ],
                  ),
                  pSpaceMedium(context),
                  FutureBuilder<List<ModelReport>>(
                      future: ModelReport.fetchReports(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length > 6
                                ? 6
                                : snapshot.data!.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                        width * 0.01),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                        width * 0.05),
                                                  ),
                                                  child: snapshot.data![index]
                                                              .tipe ==
                                                          "M"
                                                      ? Icon(
                                                          Icons
                                                              .monetization_on_rounded,
                                                          color:
                                                              pLightBrownColor,
                                                          size: width * 0.1,
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .money_off_csred_rounded,
                                                          color:
                                                              pLightBrownColor,
                                                          size: width * 0.1,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.all(width * 0.02),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data![index]
                                                        .namaBarang!,
                                                    style: pBoldBlackTextStyle
                                                        .copyWith(
                                                      fontSize:
                                                          const AdaptiveTextSize()
                                                              .getadaptiveTextSize(
                                                                  context, 16),
                                                    ),
                                                  ),
                                                  pSpaceSmall(context),
                                                  Text(
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(snapshot
                                                            .data![index]
                                                            .tanggal!),
                                                    style: pBoldBlackTextStyle
                                                        .copyWith(
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
                                        Column(
                                          children: [
                                            Text(
                                              formatter.format(
                                                  snapshot.data![index].harga),
                                              style:
                                                  pBoldBlackTextStyle.copyWith(
                                                fontSize:
                                                    const AdaptiveTextSize()
                                                        .getadaptiveTextSize(
                                                            context, 16),
                                                color: snapshot.data![index]
                                                            .tipe ==
                                                        "M"
                                                    ? pGreenColor
                                                    : pRedColor,
                                              ),
                                            ),
                                            pSpaceMedium(context),
                                            Row(
                                              children: [
                                                InkWell(
                                                  child: Icon(
                                                    Icons.edit_note_sharp,
                                                    color: pDarkBrownColor,
                                                    size: width * 0.08,
                                                  ),
                                                  onTap: () {
                                                    nominalProd.updateValue(
                                                        snapshot
                                                            .data![index].harga!
                                                            .toDouble());
                                                    addOrEditReport(
                                                        method: 'edit',
                                                        tipe: snapshot
                                                            .data![index].tipe!,
                                                        id: snapshot
                                                            .data![index].id,
                                                        namaPJ: snapshot
                                                            .data![index]
                                                            .namaOrang,
                                                        namaBarang: snapshot
                                                            .data![index]
                                                            .namaBarang,
                                                        keterangan: snapshot
                                                            .data![index]
                                                            .keterangan,
                                                        tanggal: snapshot
                                                            .data![index]
                                                            .tanggal
                                                            .toString());
                                                  },
                                                ),
                                                pSpaceMedium(context),
                                                InkWell(
                                                  child: Icon(
                                                    Icons.delete_rounded,
                                                    color: pDarkBrownColor,
                                                    size: width * 0.08,
                                                  ),
                                                  onTap: () {
                                                    validationPopUp(
                                                        pesan:
                                                            "Apakah anda yakin ingin menghapus data ini?\nnama barang : ${snapshot.data![index].namaBarang}\nharga : ${snapshot.data![index].harga}\nketerangan : ${snapshot.data![index].keterangan}\nnama penanggung jawab : ${snapshot.data![index].namaOrang}",
                                                        context: context,
                                                        onPressed: () async {
                                                          SharedPreferences
                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          final response =
                                                              await http.delete(
                                                            Uri.parse(
                                                                "$urlAPI/api/reports/${snapshot.data![index].id}"),
                                                            headers: {
                                                              HttpHeaders
                                                                      .authorizationHeader:
                                                                  "Bearer ${prefs.getString("token")}",
                                                            },
                                                          );
                                                          print(response.body);
                                                          print(response.body);
                                                          if (response.statusCode >=
                                                                  200 &&
                                                              response.statusCode <
                                                                  299) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    "Berhasil Menghapus Data"),
                                                              ),
                                                            );
                                                            // ignore: use_build_context_synchronously
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const MainPage()),
                                                            );
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    "Koneksi Gagal"),
                                                              ),
                                                            );
                                                          }
                                                        });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    pSpaceSmall(context)
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  addOrEditReport({
    required String method,
    required String tipe,
    int? id,
    String? namaPJ,
    String? namaBarang,
    String? harga,
    String? keterangan,
    String? tanggal,
  }) {
    _tanggalController.text = tanggal ?? "";
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
              key: _key,
              child: ListBody(
                children: <Widget>[
                  Text(
                    method == "add"
                        ? "Tambahkan Data Laporan"
                        : "Edit Data Laporan",
                    textAlign: TextAlign.center,
                    style: pBoldBlackTextStyle.copyWith(
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 18),
                    ),
                  ),
                  pSpaceMedium(context),
                  TextFormField(
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Mohon masukkan nama penanggung jawab";
                      }
                      return null;
                    },
                    onSaved: (e) => namaPJ = e!,
                    initialValue: namaPJ,
                    style: pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "  Nama  ",
                      labelStyle:
                          pBoldWhiteTextStyle.copyWith(color: pDarkBrownColor),
                      hintText: "Nama PJ",
                      hintStyle:
                          pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                      filled: false,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: pDarkBrownColor,
                        ),
                        borderRadius: BorderRadius.circular(
                            width > height ? width * 0.02 : height * 0.02),
                      ),
                    ),
                  ),
                  pSpaceMedium(context),
                  TextFormField(
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Mohon masukkan nama barang";
                      }
                      return null;
                    },
                    onSaved: (e) => namaBarang = e!,
                    initialValue: namaBarang,
                    style: pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "  Nama Barang  ",
                      labelStyle:
                          pBoldWhiteTextStyle.copyWith(color: pDarkBrownColor),
                      hintText: "Nama Barang",
                      hintStyle:
                          pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                      filled: false,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: pDarkBrownColor,
                        ),
                        borderRadius: BorderRadius.circular(
                            width > height ? width * 0.02 : height * 0.02),
                      ),
                    ),
                  ),
                  pSpaceMedium(context),
                  TextFormField(
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Mohon masukkan harga";
                      }
                      return null;
                    },
                    onSaved: (e) => harga = e!
                        .substring(0, e.length)
                        .replaceAll(RegExp(r'[^0-9]'), ''),
                    style: pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                    controller: nominalProd,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "  Harga  ",
                      labelStyle:
                          pBoldWhiteTextStyle.copyWith(color: pDarkBrownColor),
                      prefixText: 'Rp. ',
                      hintText: "Jumlah Uang Masuk atau Keluar",
                      hintStyle:
                          pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                      filled: false,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: pDarkBrownColor,
                        ),
                        borderRadius: BorderRadius.circular(
                            width > height ? width * 0.02 : height * 0.02),
                      ),
                    ),
                  ),
                  pSpaceMedium(context),
                  TextFormField(
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Mohon masukkan keterangan laporan";
                      }
                      return null;
                    },
                    onSaved: (e) => keterangan = e!,
                    initialValue: keterangan,
                    style: pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "  Keterangan  ",
                      labelStyle:
                          pBoldWhiteTextStyle.copyWith(color: pDarkBrownColor),
                      hintText: "Keterangan",
                      hintStyle:
                          pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                      filled: false,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: pDarkBrownColor,
                        ),
                        borderRadius: BorderRadius.circular(
                            width > height ? width * 0.02 : height * 0.02),
                      ),
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
                            _tanggalController.text = formattedDateTime;
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
                        labelText: "  Tanggal  ",
                        labelStyle: pBoldWhiteTextStyle.copyWith(
                            color: pDarkBrownColor),
                        hintText: tanggal ?? "hari-bulan-tahun",
                        hintStyle:
                            pWhiteTextStyle.copyWith(color: pDarkBrownColor),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
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
                      // initialValue: tanggal ?? "",
                      onSaved: (e) => tanggal = e!,
                      controller: _tanggalController,
                    ),
                  ),
                  pSpaceMedium(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      pButton(
                        "Batal",
                        context,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      pButton(
                        "Simpan",
                        context,
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          save();
                          Map<String, dynamic> requestBody = {
                            "method": method,
                            "nama_orang": namaPJ,
                            "nama_barang": namaBarang,
                            "harga": tipe == "K"
                                ? (int.parse(harga!) * -1).toString()
                                : harga,
                            "keterangan": keterangan,
                            "tanggal": tanggal,
                          };
                          print(requestBody);

                          if (method == "edit") {
                            requestBody["id"] = id.toString();
                          }
                          final response = await http.post(
                            Uri.parse("$urlAPI/api/reports"),
                            headers: {
                              HttpHeaders.authorizationHeader:
                                  "Bearer ${prefs.getString("token")}",
                            },
                            body: requestBody,
                          );
                          print(response.body);
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget kontainer({
  required BuildContext context,
  required double width,
  required String title,
  required int money,
}) {
  return Container(
    width: width * 0.45,
    height: width * 0.25,
    padding: EdgeInsets.all(width * 0.01),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(width * 0.05),
      border: Border.all(
        width: 5.0,
        color: pDarkBrownColor,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width * 0.35,
          height: width * 0.1,
          child: FittedBox(
            child: Text(
              title,
              style: pBoldWhiteTextStyle.copyWith(
                color: pDarkBrownColor,
              ),
            ),
          ),
        ),
        SizedBox(
          width: width * 0.4,
          height: width * 0.1,
          child: FittedBox(
            child: Text(
              formatter.format(money),
              style: pBoldWhiteTextStyle.copyWith(
                color: pDarkBrownColor,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget kontainerButton({
  required BuildContext context,
  required double width,
  required double height,
  required VoidCallback onPress,
  required String iconSvg,
}) {
  return InkWell(
    onTap: onPress,
    child: Container(
      width: width * 0.45,
      height: width * 0.25,
      padding: EdgeInsets.all(width * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.05),
        border: Border.all(
          width: 5.0,
          color: pDarkBrownColor,
        ),
      ),
      child: FittedBox(
        child: SvgPicture.asset(
          iconSvg,
        ),
      ),
    ),
  );
}
