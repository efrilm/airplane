import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:varana_apps/models/lead_model.dart';
import 'package:varana_apps/models/tracking_model.dart';
import 'package:varana_apps/pages/spv_add_reservasi_page.dart';
import 'package:varana_apps/pages/spv_add_tracking_page.dart';
import 'package:varana_apps/pages/spv_add_visit_page.dart';
import 'package:varana_apps/services/api.dart';
import 'package:varana_apps/theme/thema.dart';
import 'package:varana_apps/widget/custom_loading.dart';
import 'package:varana_apps/widget/data_not_found.dart';
import 'package:varana_apps/widget/information_lead.dart';
import 'package:varana_apps/widget/information_user.dart';
import 'package:varana_apps/widget/information_users.dart';

class SpvDetailFollowUp extends StatefulWidget {
  final LeadModel model;
  SpvDetailFollowUp(this.model);
  @override
  _SpvDetailFollowUpState createState() => _SpvDetailFollowUpState();
}

class _SpvDetailFollowUpState extends State<SpvDetailFollowUp> {
  var isLoading = false;

  String nameSales = "";

  getSales(String idSales) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse(BaseUrl.getUser), body: {
      "id": idSales,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      setState(() {
        isLoading = false;
        nameSales = data['nama_user'];
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

  String nameMarkom = "";

  getMarkom(String idMarkom) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse(BaseUrl.getUser), body: {
      "id": idMarkom,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      setState(() {
        isLoading = false;
        nameMarkom = data['nama_user'];
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

  var isData = false;
  List<TrackingModel> list = [];

  getTracking() async {
    setState(() {
      isLoading = false;
    });
    list.clear();
    final response =
        await http.post(Uri.parse(BaseUrl.getTrackingWhere), body: {
      "id": widget.model.id_lead,
    });
    if (response.statusCode == 200) {
      if (response.contentLength == 2) {
        setState(() {
          isLoading = false;
          isData = false;
        });
      } else {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          for (Map i in data) {
            list.add(TrackingModel.fromJson(i));
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSales(widget.model.id_sales);
    getMarkom(widget.model.id_markom);
    getTracking();
  }

  @override
  Widget build(BuildContext context) {
    AppBar header() {
      return AppBar(
        backgroundColor: kGreenColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
        ),
        title: Text(
          widget.model.nama_lengkap,
          style: whiteTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
      );
    }

    Widget informationUser() {
      return Container(
          width: double.infinity,
          child:
              InformationUsers(nameSales: nameSales, nameMarkom: nameMarkom));
    }

    Widget informationLead() {
      return InformationLead(
        name: widget.model.nama_lengkap,
        sumber: widget.model.sumber,
        noWa: widget.model.no_wa,
        tanggal: widget.model.tgl_add,
      );
    }

    Widget informationRumah() {
      return Container();
    }

    Widget informationKeterangan() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kGreenColor,
          borderRadius: BorderRadius.circular(radius12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Keterangan",
              style: blueTextStyle,
            ),
            Divider(
              color: kBlueColor,
            ),
            Text(
              widget.model.keterangan,
              style: whiteTextStyle,
            ),
          ],
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              margin: EdgeInsets.symmetric(horizontal: defaultMargin),
              decoration: BoxDecoration(
                color: kGreenColor,
                borderRadius: BorderRadius.circular(radius20),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SpvAddReservasiPage(widget.model)));
                },
                child: Text(
                  "Reservasi",
                  style: whiteTextStyle,
                ),
              ),
            ),
            Container(
              width: 120,
              margin: EdgeInsets.symmetric(horizontal: defaultMargin),
              decoration: BoxDecoration(
                color: kBlueColor,
                borderRadius: BorderRadius.circular(radius20),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpvAddVisitPage(widget.model)));
                },
                child: Text(
                  "Visit",
                  style: whiteTextStyle,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget tracking() {
      return Container(
        child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, i) {
              final a = list[i];
              return Container(
                margin: EdgeInsets.only(
                    left: defaultMargin,
                    right: defaultMargin,
                    bottom: defaultMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.tgl,
                      style: blueTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kGreenColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        a.keterangan,
                        style: whiteTextStyle,
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }

    Widget titleTracking() {
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: defaultMargin,
        ),
        child: Center(
          child: Text(
            "Tracking",
            style: blueTextStyle.copyWith(
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kGreenColor,
      appBar: header(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SpvAddTracking(widget.model, getTracking)));
        },
        backgroundColor: kBlueColor,
        child: Icon(
          Icons.add,
          color: kWhiteColor,
        ),
      ),
      body: isLoading
          ? CustomLoading()
          : Container(
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius20),
                  topRight: Radius.circular(radius20),
                ),
              ),
              child: ListView(
                children: [
                  informationUser(),
                  informationLead(),
                  informationKeterangan(),
                  titleTracking(),
                  isData ? tracking() : DataNotFound(),
                ],
              ),
            ),
      bottomNavigationBar: bottomNavbar(),
    );
  }
}
