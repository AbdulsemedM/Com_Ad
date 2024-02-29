import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/business_registration/business_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BussinessTab extends StatefulWidget {
  const BussinessTab({super.key});

  @override
  State<BussinessTab> createState() => _BussinessTabState();
}

class BusinessData {
  final String imgUrl;
  final String name;
  final String ownerPhoneNumber;
  final String userId;
  BusinessData(
      {required this.imgUrl,
      required this.name,
      required this.userId,
      required this.ownerPhoneNumber});
}

class _BussinessTabState extends State<BussinessTab> {
  List<BusinessData> business = [];
  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchBusinessData(retryCount: 0);
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return loading == false && business.isNotEmpty
        ? SizedBox(
            height: sHeight * 0.5,
            child: ListView.builder(
                itemCount: business.length,
                itemBuilder: (BuildContext, index) {
                  return SizedBox(
                    height: sHeight * 0.09,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BusinessDetails(
                                    userId:
                                        business[index].userId.toString())));
                      },
                      child: Card(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: sWidth * 0.07,
                            backgroundImage:
                                NetworkImage(business[index].imgUrl),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: sWidth * 0.02,
                                    backgroundColor: AppColors.textColor,
                                    child: Icon(
                                      Icons.done,
                                      color: AppColors.colorAccent,
                                      size: sWidth * 0.03,
                                    ),
                                  ),
                                  Text(business[index].name)
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: AppColors.colorAccent,
                                    size: sWidth * 0.04,
                                  ),
                                  const Text("Ethiopia")
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Phone Number"),
                              Text(business[index].ownerPhoneNumber)
                            ],
                          )
                        ],
                      )),
                    ),
                  );
                }),
          )
        : loading == false && business.isEmpty
            ? Center(
                child: SizedBox(
                // height: sHeight * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        height: sHeight * 0.4,
                        image:
                            const AssetImage("assets/images/mobile_user.png")),
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                          "No data to show you. Register some business and their data will showup here."),
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
                        Text("Fetching business data..."),
                      ],
                    ),
                  )
                : Container();
  }

  Future<void> fetchBusinessData({int retryCount = 0}) async {
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
            "prime/api/v1/distributor/get-users",
            {"userType": "BUSINESS"},
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            for (var datas in data['list']) {
              business.add(BusinessData(
                  userId: datas['userId'].toString(),
                  imgUrl: datas['OwnerPhoto'],
                  name: datas['firstName'],
                  ownerPhoneNumber: datas['phoneNumber']));
            }
            loading = false;
          });
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchBusinessData(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              loading = false;
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      // Handle other exceptions
    }
  }
}
