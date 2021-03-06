import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:varana_apps/services/api.dart';
import 'package:varana_apps/theme/thema.dart';
import 'package:varana_apps/widget/button_in_loading.dart';

class HmUserAddSpvPage extends StatefulWidget {
  final VoidCallback reload;
  HmUserAddSpvPage(this.reload);

  @override
  _HmUserAddSpvPageState createState() => _HmUserAddSpvPageState();
}

class _HmUserAddSpvPageState extends State<HmUserAddSpvPage> {
  var isLoading = false;
  var markomSelection;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  var listMarkom = [];

  selectedMarkom() async {
    final response = await http.post(Uri.parse(BaseUrl.getUserByLevel), body: {
      'level': '2',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        listMarkom = data;
      });
    }
  }

  addUser() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(Uri.parse(BaseUrl.addUser), body: {
      "username": usernameController.text,
      "password": passwordController.text,
      "nama_user": nameController.text,
      "level": "4",
      "id_markom": markomSelection,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      int value = data['value'];
      String message = data['message'];
      if (value == 1) {
        print(message);
        Navigator.pop(context);
        setState(() {
          widget.reload();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedMarkom();
  }

  @override
  Widget build(BuildContext context) {
    AppBar header() {
      return AppBar(
        backgroundColor: kGreenColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Tambah Spv",
          style: whiteTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
      );
    }

    Widget usernameTextField() {
      return Container(
        margin:
            EdgeInsets.only(top: 30, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: kGreenColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(radius20),
        ),
        child: TextFormField(
          style: blackTextStyle,
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "Username",
            border: InputBorder.none,
          ),
        ),
      );
    }

    Widget passwordTextField() {
      return Container(
        margin:
            EdgeInsets.only(top: 30, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: kGreenColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(radius20),
        ),
        child: TextFormField(
          style: blackTextStyle,
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: InputBorder.none,
          ),
        ),
      );
    }

    Widget nameTextField() {
      return Container(
        margin:
            EdgeInsets.only(top: 30, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: kGreenColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(radius20),
        ),
        child: TextFormField(
          style: blackTextStyle,
          controller: nameController,
          decoration: InputDecoration(
            hintText: "Nama Lengkap",
            border: InputBorder.none,
          ),
        ),
      );
    }

    Widget markomDropdown() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: kLightGreenColor,
          borderRadius: BorderRadius.circular(radius20),
        ),
        child: DropdownButtonFormField(
          hint: Text(
            "Pilih markom",
          ),
          onSaved: (e) => markomSelection,
          value: markomSelection,
          style: blackTextStyle,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          items: listMarkom.map((value) {
            return DropdownMenuItem(
              child: Text(
                "${value['nama_user']}",
                style: blackTextStyle,
              ),
              value: value['id_user'],
            );
          }).toList(),
          onChanged: (newvalue) {
            setState(() {
              markomSelection = newvalue;
            });
          },
        ),
      );
    }

    Widget bottomNavbar() {
      return Container(
        height: 80,
        decoration: BoxDecoration(
          color: kWhiteColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -10),
              color: kLightGreenColor,
              blurRadius: 20,
            ),
          ],
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: defaultMargin),
            width: double.infinity,
            decoration: BoxDecoration(
              color: kBlueColor,
              borderRadius: BorderRadius.circular(radius20),
            ),
            child: TextButton(
              onPressed: () {
                addUser();
              },
              child: isLoading
                  ? LoadingInButton()
                  : Text(
                      "Konfirmasi",
                      style: whiteTextStyle,
                    ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: header(),
      body: ListView(
        children: [
          usernameTextField(),
          passwordTextField(),
          nameTextField(),
          markomDropdown(),
        ],
      ),
      bottomNavigationBar: bottomNavbar(),
    );
  }
}
