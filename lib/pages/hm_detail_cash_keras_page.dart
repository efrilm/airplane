import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:varana_apps/models/lead_model.dart';
import 'package:varana_apps/models/tracking_model.dart';
import 'package:varana_apps/services/api.dart';
import 'package:varana_apps/theme/thema.dart';
import 'package:varana_apps/widget/custom_loading.dart';
import 'package:varana_apps/widget/data_not_found.dart';
import 'package:varana_apps/widget/information_lead.dart';
import 'package:varana_apps/widget/information_user.dart';

class HmDetailCashKerasPage extends StatefulWidget {
  final LeadModel model;
  HmDetailCashKerasPage(this.model);
  @override
  _HmDetailCashKerasPageState createState() => _HmDetailCashKerasPageState();
}

class _HmDetailCashKerasPageState extends State<HmDetailCashKerasPage> {
  var isLoading = false;

  String nameSales = "";
  String imagesSales = "";

  getSales(String idSales) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse(BaseUrl.getUser), body: {
      "id_users": idSales,
    });
    if (response.statusCode != 200) {
      final data = jsonDecode(response.body)[0];
      setState(() {
        isLoading = false;
        nameSales = data['nama_user'];
        imagesSales = data['image'];
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
  String imagesMarkom = "";

  getMarkom(String idMarkom) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse(BaseUrl.getUser), body: {
      "id_users": idMarkom,
    });
    if (response.statusCode != 200) {
      final data = jsonDecode(response.body)[0];
      setState(() {
        isLoading = false;
        nameMarkom = data['nama_user'];
        imagesMarkom = data['image'];
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

  int feeReservasi = 0;
  int feeBooking = 0;
  int total = 0;
  getFeeDetail(String idLead) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse(BaseUrl.getFeeDetail), body: {
      "id_lead": idLead,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      setState(() {
        isLoading = false;
        feeReservasi = data['fee_reservasi'];
        feeBooking = data['fee_booking'];
        total = data['total'];
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

  String noRumah = "";
  String tipeRumah = "";
  int harga = 0;
  getRumahDetail(String idLead) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse(BaseUrl.getRumahDetail), body: {
      "id_lead": idLead,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      setState(() {
        isLoading = false;
        noRumah = data['no_rumah'];
        tipeRumah = data['tipe_rumah'];
        harga = data['harga'];
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

  int subtotal = 0;
  int diskon = 0;
  int dp = 0;
  int diskonDp = 0;
  int dpDibayar = 0;

  getPembayaranDetail(String idLead) async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.post(Uri.parse(BaseUrl.getPembayaranDetail), body: {
      "id_lead": idLead,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      setState(() {
        isLoading = false;
        subtotal = data['subtotal'];
        dp = data['downpayment'];
        diskon = data['diskon'];
        diskonDp = data['diskon_dp'];
        dpDibayar = data['dp_dibayar'];
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

  String namaBank = "";

  getBankDetail(String idLead) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse(BaseUrl.getBankDetail), body: {
      "id_lead": idLead,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      setState(() {
        isLoading = false;
        namaBank = data['nama_bank'];
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

  final price = NumberFormat("#,##0", "en_us");

  var isData = false;
  List<TrackingModel> list = [];

  getTracking() async {
    setState(() {
      isLoading = false;
    });
    list.clear();
    final response = await http.post(Uri.parse(BaseUrl.getTracking), body: {
      "id_lead": widget.model.id_lead,
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
    getFeeDetail(widget.model.id_lead);
    getRumahDetail(widget.model.id_lead);
    getPembayaranDetail(widget.model.id_lead);
    getBankDetail(widget.model.id_lead);
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

    Widget informationSales() {
      return InformationUser(
        imageUrl: BaseUrl.imageUrl + imagesSales,
        name: nameSales,
      );
    }

    Widget informationMarkom() {
      return InformationUser(
        imageUrl: BaseUrl.imageUrl + imagesMarkom,
        name: nameMarkom,
      );
    }

    Widget informationLead() {
      return InformationLead(
        name: widget.model.nama_lengkap,
        sumber: widget.model.sumber,
        noWa: widget.model.no_wa,
        tanggal: widget.model.tgl_add,
      );
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

    Widget informationFee() {
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
              "Information Fee",
              style: blueTextStyle,
            ),
            Divider(
              color: kBlueColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fee Reservasi",
                  style: whiteTextStyle,
                ),
                Text(
                  feeReservasi == null
                      ? "Rp. ${price.format(feeReservasi)}"
                      : "Rp. 0",
                  style: whiteTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fee Booking",
                  style: whiteTextStyle,
                ),
                Text(
                  feeBooking != null
                      ? "Rp. ${price.format(feeBooking)}"
                      : "Rp. 0",
                  style: whiteTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: whiteTextStyle,
                ),
                Text(
                  total != null ? "Rp. ${price.format(total)}" : "Rp. 0",
                  style: whiteTextStyle,
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget informationPembayaran() {
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
              "Information Pembayaran",
              style: blueTextStyle,
            ),
            Divider(
              color: kBlueColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Harga",
                  style: whiteTextStyle,
                ),
                Text(
                  harga != null ? "Rp. ${price.format(harga)}" : "Rp. 0",
                  style: whiteTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Diskon Harga",
                  style: whiteTextStyle,
                ),
                Text(
                  diskon != null ? "Rp. ${price.format(diskon)}" : "Rp. 0",
                  style: whiteTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Downpayment",
                  style: whiteTextStyle,
                ),
                Text(
                  dp != null ? "Rp. ${price.format(dp)}" : "Rp. 0",
                  style: whiteTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Diskon Dp",
                  style: whiteTextStyle,
                ),
                Text(
                  diskonDp != null ? "Rp. ${price.format(diskonDp)}" : "Rp. 0",
                  style: whiteTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dp Dibayar",
                  style: whiteTextStyle,
                ),
                Text(
                  diskonDp != null ? "Rp. ${price.format(dpDibayar)}" : "Rp. 0",
                  style: whiteTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtotal",
                  style: whiteTextStyle,
                ),
                Text(
                  subtotal != null ? "Rp. ${price.format(subtotal)}" : "Rp. 0",
                  style: whiteTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtotal",
                  style: whiteTextStyle,
                ),
                Text(
                  namaBank,
                  style: whiteTextStyle,
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget informationRumah() {
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
              "Information Rumah",
              style: blueTextStyle,
            ),
            Divider(
              color: kBlueColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "No. Rumah",
                  style: whiteTextStyle,
                ),
                Text(
                  noRumah,
                  style: whiteTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tipe Rumah",
                  style: whiteTextStyle,
                ),
                Text(
                  tipeRumah,
                  style: whiteTextStyle,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Jenis Pembayaran",
                  style: whiteTextStyle,
                ),
                Text(
                  widget.model.jenis_pembayaran,
                  style: whiteTextStyle,
                ),
              ],
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
        child: Center(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: defaultMargin),
            decoration: BoxDecoration(
              color: kBlueColor,
              borderRadius: BorderRadius.circular(radius20),
            ),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Sold",
                style: whiteTextStyle,
              ),
            ),
          ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.nama_user,
                            style: blueTextStyle,
                          ),
                          Divider(
                            color: kBlueColor,
                          ),
                          Text(
                            a.keterangan,
                            style: whiteTextStyle,
                          ),
                        ],
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    informationSales(),
                    informationMarkom(),
                    informationLead(),
                    informationKeterangan(),
                    informationFee(),
                    informationRumah(),
                    informationPembayaran(),
                    titleTracking(),
                    isData ? tracking() : DataNotFound(),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
