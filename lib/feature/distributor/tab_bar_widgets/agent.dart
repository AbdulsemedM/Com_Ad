import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/agent_registration/agent_details.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/agent_registration/agent_registration_step2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgentData {
  final userId;
  final String imgUrl;
  final String name;
  final String city;
  final String ownerPhoneNumber;
  AgentData(
      {required this.userId,
      required this.imgUrl,
      required this.city,
      required this.name,
      required this.ownerPhoneNumber});
}

class AgentTab extends StatefulWidget {
  const AgentTab({super.key});

  @override
  State<AgentTab> createState() => _AgentTabState();
}

class _AgentTabState extends State<AgentTab> {
  var loading = false;
  List<AgentData> agents = [];
  List<CityData> cities = [];
  @override
  void initState() {
    super.initState();
    fetchagentData(retryCount: 0);
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
    return loading == false && agents.isNotEmpty
        ? SizedBox(
            height: sHeight * 0.5,
            child: ListView.builder(
                itemCount: agents.length,
                itemBuilder: (BuildContext, index) {
                  return SizedBox(
                    height: sHeight * 0.09,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AgentDetails(
                                    userId: agents[index].userId.toString())));
                      },
                      child: Card(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: sWidth * 0.07,
                            backgroundImage: NetworkImage(agents[index].imgUrl),
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
                                  Text(agents[index].name)
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
                                      int.parse(agents[index].city), cities)),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Phone Number"),
                              Text(agents[index].ownerPhoneNumber)
                            ],
                          )
                        ],
                      )),
                    ),
                  );
                }),
          )
        : loading == false && agents.isEmpty
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
                          "No data to show you. Register some agents and their data will showup here."),
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
                        Text("Fetching agents data..."),
                      ],
                    ),
                  )
                : Container();
  }

  Future<void> fetchagentData({int retryCount = 0}) async {
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
              agents.add(AgentData(
                  city: datas['city'].toString(),
                  userId: datas['userId'],
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
            await fetchagentData(retryCount: retryCount + 1);
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
