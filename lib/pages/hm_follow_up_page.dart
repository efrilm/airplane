import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:varana_apps/models/lead_model.dart';
import 'package:varana_apps/pages/hm_detail_follow_up.dart';
import 'package:varana_apps/services/api.dart';
import 'package:varana_apps/theme/thema.dart';
import 'package:varana_apps/widget/custom_loading.dart';
import 'package:varana_apps/widget/data_not_found.dart';

class HmFollowUpPage extends StatefulWidget {
  @override
  _HmFollowUpPageState createState() => _HmFollowUpPageState();
}

class _HmFollowUpPageState extends State<HmFollowUpPage> {
  var isLoading = false;
  var isData = false;

  List<LeadModel> list = [];

  Future<void> getLead() async {
    setState(() {
      isLoading = true;
    });
    list.clear();
    SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(BaseUrl.tampilFollowUpHm));
    if (response.statusCode == 200) {
      if (response.contentLength == 2) {
        setState(() {
          isLoading = false;
          isData = false;
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          for (Map i in data) {
            list.add(LeadModel.fromJson(i));
          }
          isLoading = false;
          isData = true;
        });
      }
    } else {
      setState(() {
        isLoading = false;
        isData = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: getLead,
        child: isLoading
            ? CustomLoading()
            : isData
                ? ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final a = list[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HmDetailFollowUp(a)));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: defaultMargin,
                            left: defaultMargin,
                            right: defaultMargin,
                          ),
                          decoration: BoxDecoration(
                            color: kGreenColor,
                            borderRadius: BorderRadius.circular(radius20),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Nama",
                                      style: whiteTextStyle,
                                    ),
                                    Text(
                                      a.nama_lengkap,
                                      style: whiteTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "No. Whatsapp",
                                      style: whiteTextStyle,
                                    ),
                                    Text(
                                      a.no_wa,
                                      style: whiteTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Tanggal",
                                      style: whiteTextStyle,
                                    ),
                                    Text(
                                      a.tgl_add,
                                      style: whiteTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : DataNotFound(),
      ),
    );
  }
}
