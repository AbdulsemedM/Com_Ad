import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/agent_registration/agent_registration_step2.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/agent_registration/agent_registration_step_1.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterAgent extends StatefulWidget {
  const RegisterAgent({super.key});

  @override
  State<RegisterAgent> createState() => _RegisterAgentState();
}

class _RegisterAgentState extends State<RegisterAgent> {
  String? userId;
  var loading = false;
  String latitude = 'Latitude: ';
  String longitude = 'Longitude: ';
  var image;
  var result;
  var result2;
  String? step = "";
  String? step2 = "";
  @override
  void initState() {
    super.initState();
    fetchState();
    fetchState2();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: sWidth * 1,
              height: sHeight * 0.35,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.purple,
                    Color.fromARGB(255, 142, 112, 181)
                  ], // Gradient colors
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 7),
                        child: Image(
                            height: sHeight * 0.15,
                            image: const AssetImage(
                                "assets/images/user_registration.png")),
                      ),
                      Text(
                        "Register Agent",
                        style: TextStyle(
                            fontSize: sWidth * 0.05,
                            color: AppColors.bgCreamWhite,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Please fill out all the required entries, upload the documents and hit enter",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: sWidth * 0.04,
                          color: AppColors.bgCreamWhite,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 18.0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: sHeight * 0.04,
                            width: sWidth * 0.08,
                            decoration: BoxDecoration(
                                color: step == '1'
                                    ? AppColors.greenColor
                                    : AppColors.colorAccent,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Center(
                                child: Text(
                              "1",
                              style: TextStyle(color: AppColors.bgCreamWhite),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Container(
                              height: sHeight * 0.015,
                              width: sWidth * 0.005,
                              color: step == '1'
                                  ? AppColors.greenColor
                                  : AppColors.colorAccent,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Container(
                              height: sHeight * 0.015,
                              width: sWidth * 0.005,
                              color: step == '1'
                                  ? AppColors.greenColor
                                  : AppColors.colorAccent,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Container(
                              height: sHeight * 0.015,
                              width: sWidth * 0.005,
                              color: step == '1'
                                  ? AppColors.greenColor
                                  : AppColors.colorAccent,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Container(
                              height: sHeight * 0.015,
                              width: sWidth * 0.005,
                              color: step == '1'
                                  ? AppColors.greenColor
                                  : AppColors.colorAccent,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Container(
                              height: sHeight * 0.015,
                              width: sWidth * 0.005,
                              color: step == '1'
                                  ? AppColors.greenColor
                                  : AppColors.colorAccent,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Container(
                              height: sHeight * 0.015,
                              width: sWidth * 0.005,
                              color: step == '1' && step2 != '1'
                                  ? AppColors.colorAccent
                                  : step2 == '1'
                                      ? AppColors.greenColor
                                      : Color.fromARGB(255, 219, 217, 217),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AgentStep1()));
                          if (result != null) {
                            // Update state based on the result
                            fetchState();
                          }
                        },
                        child: Container(
                          width: sWidth * 0.7,
                          height: sHeight * 0.1,
                          color: step == '1'
                              ? AppColors.greenColor
                              : AppColors.boxColor,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "Personal Information",
                                  style:
                                      TextStyle(color: AppColors.colorAccent),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                    "Name, Email, Phone number, Password, Profile picture",
                                    style: TextStyle(
                                        color: AppColors.colorAccent)),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Container(
                              height: sHeight * 0.015,
                              width: sWidth * 0.005,
                              color: step == '1' && step2 != '1'
                                  ? AppColors.colorAccent
                                  : step2 == '1'
                                      ? AppColors.greenColor
                                      : const Color.fromARGB(
                                          255, 219, 217, 217),
                            ),
                          ),
                          Container(
                            height: sHeight * 0.04,
                            width: sWidth * 0.08,
                            decoration: BoxDecoration(
                                color: step == '1' && step2 != '1'
                                    ? AppColors.colorAccent
                                    : step2 == '1'
                                        ? AppColors.greenColor
                                        : const Color.fromARGB(
                                            255, 219, 217, 217),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text(
                              "2",
                              style: TextStyle(
                                  color: step == '1'
                                      ? AppColors.bgCreamWhite
                                      : AppColors.secondaryTextColor),
                            )),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (step == '1') {
                            result2 = Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AgentRegistrationstep2()));
                            if (result2 != null) {
                              // Update state based on the result
                              fetchState2();
                            }
                          } else {
                            context.displaySnack(
                                "Please first complete the personal information");
                          }
                        },
                        child: Container(
                          width: sWidth * 0.7,
                          height: sHeight * 0.1,
                          color: step == '1' && step2 != '1'
                              ? AppColors.boxColor
                              : step2 == '1' && step == '1'
                                  ? AppColors.greenColor
                                  : const Color.fromARGB(255, 219, 217, 217),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("Business Information",
                                    style: TextStyle(
                                        color: step == '1'
                                            ? AppColors.colorAccent
                                            : AppColors.secondaryTextColor)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                    "Tax and Commercial Certificate Docs/ Business Location Information",
                                    style: TextStyle(
                                        color: step == '1'
                                            ? AppColors.colorAccent
                                            : AppColors.secondaryTextColor)),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () async {
                //       final SharedPreferences prefs =
                //           await SharedPreferences.getInstance();
                //       var img = prefs.getString("myImage");
                //       print(img);
                //       setState(() {
                //         image = File(img!);
                //       });
                //     },
                //     child: Text("image")),
                // SizedBox(
                //     child: image != null ? Image.file(image!) : Text("image"))
              ],
            ),
          ],
        ),
      )),
      floatingActionButton: SizedBox(
        width: sWidth * 0.9,
        height: sHeight * 0.06,
        child: ElevatedButton(
            onPressed: loading
                ? () {}
                : () async {
                    bool done = await verifyForm();
                    if (done) {
                      context.displaySnack("Uploading image");
                    }
                  },
            child: const Text("Submit for Verification")),
      ),
    );
  }

  Future<void> fetchState() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        var steps = prefs.getStringList("step1");
        step = steps![4];
      });
      print(step);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchState2() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        var steps = prefs.getStringList("step2");
        step2 = steps![9];
        print(step2);
      });
      print(step);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> verifyForm() async {
    try {
      setState(() {
        loading = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var step1 = prefs.getStringList("step1");
      var step2 = prefs.getStringList("step2");
      if (step1!.isNotEmpty && step2!.isNotEmpty) {
        print("hereeeewego");
        Map<String, dynamic> payload = {
          "userType": "AGENT",
          "firstName": step1[0].toString(),
          "email": step1[1].toString(),
          "ownerPhoneNumber": step1[2].toString(),
          "businessName": step2[0].toString(),
          "taxNumber": step2[1].toString(),
          "country": step2[2].toString(),
          "address": step2[3].toString(),
          "city": step2[4].toString(),
          "lastName": step1[0].toString(),
          "longitude": longitude.toString(),
          "latitude": latitude.toString(),
          "bankAccountNumber": "0000",
          "bankCode": "000",
          "branch": "---",
          "businessCategory": "1",
          "businessLicense": "12qwqwds",
          "businessPhoneNumber": "0721942750",
          "businessType": "Shop",
          "commercialCertNo": "12qwqwds",
          "language": "en",
          "msisdn": "07219842755",
          "postalCode": "12365",
          "registeredBy": "David Setim",
          "timestamp": "1643782801828",
        };
        print(payload);
        final prefsData = getIt<PrefsData>();
        final isUserLoggedIn =
            await prefsData.contains(PrefsKeys.userToken.name);
        if (isUserLoggedIn) {
          final token = await prefsData.readData(PrefsKeys.userToken.name);
          final response = await http.post(
              Uri.https("api.commercepal.com:2096",
                  "/prime/api/v1/distributor/user-registration"),
              body: jsonEncode(payload),
              headers: <String, String>{"Authorization": "Bearer $token"});
          // print(response.body);
          var data = jsonDecode(response.body);
          print(data);

          if (data['statusCode'] == '000') {
            userId = data["userId"];
            setState(() {
              loading = false;
            });
            return true;
          } else {
            userId = data['statusMessage:'];
            setState(() {
              loading = false;
            });
            return false;
          }
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      return false;
    } finally {
      setState(() {
        loading = false;
      });
    }
    return false;
  }

  Future<void> getLocation() async {
    try {
      var status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          latitude = position.latitude.toString();
          longitude = position.longitude.toString();
        });
        print(latitude);
        print(longitude);
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}
