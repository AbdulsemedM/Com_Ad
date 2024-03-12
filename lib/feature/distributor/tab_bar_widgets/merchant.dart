import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/merchant_registration/merchant_registration_step2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MerchantTab extends StatefulWidget {
  const MerchantTab({super.key});

  @override
  State<MerchantTab> createState() => _MerchantTabState();
}

class MerchantData {
  final String userId;
  final String name;
  final String city;
  final String ownerPhoneNumber;
  MerchantData(
      {required this.userId,
      required this.city,
      required this.name,
      required this.ownerPhoneNumber});
}

class _MerchantTabState extends State<MerchantTab> {
  List<MerchantData> merchants = [];
  List<CityData> cities = [];
  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchMerchantData(retryCount: 0);
    fetchCity();
  }

  String getCityName(int cityId, List<CityData> cityList) {
    // Find the CityData object with matching cityId
    CityData? cityData = cityList.firstWhere(
      (city) => city.cityId == cityId,
      orElse: () => CityData(cityName: "Unknown City", cityId: 0, countryId: 0),
    );

    return cityData.cityName;
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return loading == false && merchants.isNotEmpty
        ? SizedBox(
            height: sHeight * 0.5,
            child: ListView.builder(
                itemCount: merchants.length,
                itemBuilder: (BuildContext, index) {
                  return SizedBox(
                    height: sHeight * 0.09,
                    child: Card(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: sWidth * 0.07,
                          backgroundImage: NetworkImage(
                              "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png"),
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
                                Text(merchants[index].name)
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.colorAccent,
                                  size: sWidth * 0.04,
                                ),
                                Text(getCityName(
                                    int.parse(merchants[index].city), cities)),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Phone Number"),
                            Text(merchants[index].ownerPhoneNumber)
                          ],
                        )
                      ],
                    )),
                  );
                }),
          )
        : loading == false && merchants.isEmpty
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
                          "No data to show you. Register some merchants and their data will showup here."),
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
                        Text("Fetching merchants data..."),
                      ],
                    ),
                  )
                : Container();
  }

  Future<void> fetchMerchantData({int retryCount = 0}) async {
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
            {"userType": "MERCHANT"},
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        Map<String, dynamic> data = json.decode(response.body);
        print(data);

        print(data['statusCode']);
        if (data['statusCode'] == '000') {
          setState(() {
            for (var datas in data['list']) {
              merchants.add(MerchantData(
                  userId: datas['userId'].toString(),
                  city: datas['city'].toString(),
                  name: datas['name'],
                  ownerPhoneNumber: datas['ownerPhoneNumber']));
            }
            loading = false;
          });
          print("hey merchant");
          print(merchants.length);
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchMerchantData(retryCount: retryCount + 1);
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
        print(e.toString());
        loading = false;
      });
      // Handle other exceptions
    }
  }

  Future<void> fetchCity() async {
    try {
      setState(() {
        loading = true;
      });
      print("hereeee");

      // final prefsData = getIt<PrefsData>();
      // final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      // if (isUserLoggedIn) {
      // final token = await prefsData.readData(PrefsKeys.userToken.name);
      final response = await http.get(Uri.https(
          "api.commercepal.com:2096", "/prime/api/v1/service/cities"));
      // print(response.body);
      var data = jsonDecode(response.body);
      cities.clear();
      for (var b in data['data']) {
        cities.add(CityData(
            cityId: b['cityId'],
            cityName: b['cityName'],
            countryId: b['countryId']));
      }
      print(cities.length);
      setState(() {
        loading = false;
      });
      // }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }
}
