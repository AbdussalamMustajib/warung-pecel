import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../model/model_profil.dart';
import '../space_theme.dart';
import '../text_adaptive.dart';
import '../text_style_theme.dart';
import '../theme_color.dart';
import '../widget_component.dart';
import 'main_page.dart';

class UpdateSetting extends StatefulWidget {
  const UpdateSetting({Key? key, required this.profile}) : super(key: key);
  final ModelProfile profile;

  @override
  _UpdateSettingState createState() => _UpdateSettingState();
}

class _UpdateSettingState extends State<UpdateSetting> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final _picker = ImagePicker();
  File? image;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.profile.data![0].frontName!;
    _lastNameController.text = widget.profile.data![0].backName ?? "";
    _tanggalLahirController.text = widget.profile.data![0].dateOfBirth ?? "";
  }

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    } else {
      print('no image selected');
    }
  }

  Future<void> _updateProfil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final url = Uri.parse('$urlAPI/api/profile');
    final request = http.MultipartRequest('POST', url);
    var imagePart;

    image != null
        ? imagePart = await http.MultipartFile.fromPath('image', image!.path)
        : imagePart = null;

    image != null ? request.files.add(imagePart) : request.fields["image"] = '';
    request.headers['Authorization'] = 'Bearer ${prefs.getString("token")}';
    request.fields['front_name'] = _firstNameController.text;
    request.fields['back_name'] = _lastNameController.text;
    request.fields['date_of_birth'] = _tanggalLahirController.text;
    final streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 299) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil Berhasil Diupdate")));
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Connection Failed")));
    }
  }

  var selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Ubah Profile",
            style: pBoldBlackTextStyle.copyWith(
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 14)),
          ),
        ),
        body: _buildBody(),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(12),
          child: pButton("Simpan", context, onPressed: _updateProfil),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pSpaceBig(context),
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(40),
                      child: image != null
                          ? Image.file(
                              File(image!.path).absolute,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              "$urlAPI/storage/images/${widget.profile.data![0].image ?? ""}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/Ikon-User.png',
                                    width: 30, height: 41);
                              },
                            ),
                    ),
                  ),
                  Positioned(
                    left: -5,
                    bottom: 15,
                    child: RawMaterialButton(
                      onPressed: () {
                        getImage();
                      },
                      elevation: 2.0,
                      fillColor: Colors.black54,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            pSpaceMedium(context),
            _textitem('First Name *'),
            pSpaceSmall(context),
            TextField(
              showCursor: true,
              controller: _firstNameController,
              cursorColor: Colors.black45,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: pDarkBrownColor,
                  ),
                ),
                hintText: widget.profile.data![0].frontName ?? "",
                hintStyle: pBlackTextStyle,
              ),
            ),
            pSpaceBig(context),
            _textitem('Last Name'),
            pSpaceSmall(context),
            TextField(
              showCursor: true,
              controller: _lastNameController,
              cursorColor: Colors.black45,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: pDarkBrownColor,
                  ),
                ),
                hintText: widget.profile.data![0].backName ?? "",
                hintStyle: pBlackTextStyle.copyWith(
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 14)),
              ),
            ),
            pSpaceBig(context),
            _textitem('Tanggal Lahir'),
            pSpaceSmall(context),
            TextField(
              showCursor: true,
              cursorColor: Colors.black45,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: pDarkBrownColor,
                  ),
                ),
                hintText:
                    widget.profile.data![0].dateOfBirth ?? "hari-bulan-tahun",
                hintStyle: pBlackTextStyle,
                suffixIcon: const Icon(Icons.calendar_month_outlined),
              ),
              controller: _tanggalLahirController,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat("d MMMM y").format(pickedDate);
                  setState(() {
                    _tanggalLahirController.text = formattedDate;
                  });
                } else {
                  print("Date is not selected");
                }
              },
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _textitem(String teks) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(teks, style: pBlackTextStyle),
    );
  }
}
