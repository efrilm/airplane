import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:varana_apps/pages/change_profile.dart';
import 'package:varana_apps/pages/markom_absen_page.dart';
import 'package:varana_apps/pages/markom_list_tamu.dart';
import 'package:varana_apps/pages/markom_report_lead.dart';
import 'package:varana_apps/pages/master_stock_page.dart';
import 'package:varana_apps/pages/privacy_police_page.dart';
import 'package:varana_apps/pages/product_knowladge_page.dart';
import 'package:varana_apps/pages/sales_absen_page.dart';
import 'package:varana_apps/pages/term_conditions_page.dart';
import 'package:varana_apps/pages/users/markom_sales_page.dart';
import 'package:varana_apps/services/api.dart';
import 'package:varana_apps/theme/thema.dart';
import 'package:varana_apps/widget/custom_loading.dart';
import 'package:varana_apps/widget/page_reminder.dart';

class MarkomAccountPage extends StatefulWidget {
  const MarkomAccountPage({Key? key}) : super(key: key);

  @override
  _MarkomAccountPageState createState() => _MarkomAccountPageState();
}

class _MarkomAccountPageState extends State<MarkomAccountPage> {
  var isLoading = false;
  String name = "";
  String images = "";
  String username = "";
  String? idUser;
  getName() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(BaseUrl.getUser), body: {
      "id": pref.getString("idUser"),
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      setState(() {
        isLoading = false;

        name = data['nama_user'];
        username = data['username'];
        images = data['images'];
        idUser = pref.getString("idUser");
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.remove("value");
      pref.remove("idUser");
      pref.remove("username");
      pref.remove("nama_user");
      pref.remove("level");
      pref.remove("active");
      pref.remove("createDate");
      pref.remove("updateDate");
      pref.remove("images");
      pref.remove("token");
      pref.commit();
      Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false);
    });
  }

  _launchURL() async {
    const url = 'https://marketingbranding.id/api/varana/varana-web/lead';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  String? playerId;

  getPlayerId() async {
    final status = await OneSignal.shared.getDeviceState();
    playerId = status?.userId;
    print("User Id  = ${status?.userId}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
    getPlayerId();
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChangeProfile(getName)));
        },
        child: Container(
          height: 170,
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: kGreenColor,
          ),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(BaseUrl.imageUrl + images),
                radius: 35,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                name != " " ? name : "Tidak Ditemukan",
                style: whiteTextStyle.copyWith(fontSize: 18),
              ),
              Text(
                username != " " ? username : "Tidak ditemukan",
                style: whiteTextStyle,
              ),
            ],
          ),
        ),
      );
    }

    Widget content() {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: kBlueColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Id Anda adalah",
                  style: whiteTextStyle,
                ),
                GestureDetector(
                  child: Text("$idUser", style: whiteTextStyle),
                  onLongPress: () {
                    Clipboard.setData(
                      new ClipboardData(text: "$idUser"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Copy To Clipboard"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(defaultMargin),
            child: Column(
              children: [
                PageReminder(
                  icon: Icons.pan_tool_outlined,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MarkomAbsenPage()));
                  },
                  title: "Absen",
                ),
                SizedBox(
                  height: 20,
                ),
                PageReminder(
                  icon: Icons.home_outlined,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MasterStock()));
                  },
                  title: "Master Stock",
                ),
                SizedBox(
                  height: 20,
                ),
                PageReminder(
                  icon: Icons.assignment_ind_outlined,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MarkomListTamu()));
                  },
                  title: "List Tamu",
                ),
                SizedBox(
                  height: 20,
                ),
                PageReminder(
                  icon: Icons.person_outline,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MarkomSalesPage()));
                  },
                  title: "Daftar Sales",
                ),
                SizedBox(
                  height: 20,
                ),
                PageReminder(
                  icon: Icons.calculate_outlined,
                  onTap: _launchURL,
                  title: "Report Lead",
                ),
                SizedBox(
                  height: 20,
                ),
                PageReminder(
                  icon: Icons.home_work_outlined,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductKnowladgePage()));
                  },
                  title: "Product Knowledge",
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget general() {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.ac_unit,
                  color: kBlueColor,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "General",
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Divider(color: kGreenColor),
            SizedBox(height: 10),
            PageReminder(
              icon: Icons.policy_outlined,
              title: "Privacy Policy",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()));
              },
            ),
            SizedBox(
              height: 20,
            ),
            PageReminder(
              icon: Icons.warning_amber_outlined,
              title: "Term & Conditions",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermConditionPage()));
              },
            ),
          ],
        ),
      );
    }

    Widget button() {
      return Container(
        padding: EdgeInsets.all(20),
        child: TextButton(
          onPressed: () {
            signOut();
          },
          style: TextButton.styleFrom(
            backgroundColor: kGreenColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius20),
            ),
          ),
          child: Text(
            "Logout",
            style: whiteTextStyle,
          ),
        ),
      );
    }

    return Scaffold(
      body: isLoading
          ? CustomLoading()
          : ListView(
              children: [
                header(),
                content(),
                general(),
                button(),
              ],
            ),
    );
  }
}
