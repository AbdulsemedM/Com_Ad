import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/business_registration/businessDetails/add_collateral.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BusinessCollaterals extends StatefulWidget {
  final String userId;
  const BusinessCollaterals({Key? key, required this.userId}) : super(key: key);
  @override
  State<BusinessCollaterals> createState() => _BusinessCollateralsState();
}

class CollateralData {
  final String name;
  final String desc;
  final String worth;
  final String status;
  final String date;
  final String imgURL;
  CollateralData(
      {required this.name,
      required this.desc,
      required this.worth,
      required this.status,
      required this.date,
      required this.imgURL});
}

class _BusinessCollateralsState extends State<BusinessCollaterals> {
  List<CollateralData> collaterals = [];
  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchCollateralData();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
        appBar: AppBar(
          title: Text("Collaterals"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddBusinessCollatral(
                          userId: widget.userId,
                        )));
          },
          child: Icon(Icons.add),
        ),
        // appBar: AppBar(),
        body: loading == false && collaterals.isNotEmpty
            ? SingleChildScrollView(
                child: SizedBox(
                  height: sHeight * 0.9,
                  child: ListView.builder(
                      itemCount: collaterals.length,
                      itemBuilder: (BuildContext, index) {
                        return SizedBox(
                          height: sHeight * 0.15,
                          child: Card(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: sWidth * 0.07,
                                backgroundImage:
                                    NetworkImage(collaterals[index].imgURL),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [Text(collaterals[index].name)],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        collaterals[index].desc.length > 20
                                            ? '${collaterals[index].desc.substring(0, 20)}...'
                                            : collaterals[index].desc,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [Text('Estimated Worth')],
                                  ),
                                  Row(
                                    children: [Text('Approved')],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      DateFormat('dd MMM yy, HH:mm').format(
                                          DateTime.parse(
                                              collaterals[index].date)),
                                      style:
                                          TextStyle(fontSize: sWidth * 0.03)),
                                  Text(''),
                                  Text(collaterals[index].worth),
                                  Text(collaterals[index].status)
                                ],
                              )
                            ],
                          )),
                        );
                      }),
                ),
              )
            : loading == false && collaterals.isEmpty
                ? Center(
                    child: SizedBox(
                    // height: sHeight * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                            height: sHeight * 0.4,
                            image: const AssetImage(
                                "assets/images/mobile_user.png")),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                              "No collaterals added, click '+' to add one."),
                        ),
                      ],
                    ),
                  ))
                : loading == true
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.colorAccent,
                            ),
                            Text("Fetching collateral data..."),
                          ],
                        ),
                      )
                    : Container());
  }

  Future<void> fetchCollateralData({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "api.commercepal.com:2096",
            "prime/api/v1/distributor/business/collateral/get-business-collateral",
            {"businessId": widget.userId},
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            collaterals.clear();
            for (var datas in data['list']) {
              var documents = datas['documents'] as List<dynamic>;
              collaterals.add(CollateralData(
                  name: datas['CollateralName'].toString(),
                  worth: datas['EstimateWorth'].toString(),
                  status: datas['Status'].toString(),
                  desc: datas['Description'],
                  date: datas['CreatedDate'],
                  imgURL: documents.isNotEmpty ? documents[0].toString() : ''));
            }
            print(collaterals.length);
            loading = false;
          });
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchCollateralData(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              loading = false;
            });
          }
        }
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
    }
  }
}
