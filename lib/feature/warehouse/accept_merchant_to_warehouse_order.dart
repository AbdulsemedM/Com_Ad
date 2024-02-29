import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptMTWOrder extends StatefulWidget {
  final String ItemOrderId;
  final String userName;
  const AcceptMTWOrder(
      {Key? key, required this.ItemOrderId, required this.userName})
      : super(key: key);

  @override
  State<AcceptMTWOrder> createState() => _AcceptMTWOrderState();
}

class Warehouse {
  final String id;
  final String name;

  Warehouse(this.id, this.name);

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    final id = json.keys.first;
    final name = json.values.first;

    return Warehouse(id, name);
  }
}

class ApiResponse {
  final List<Warehouse> data;

  ApiResponse({required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List)
        .map((warehouseJson) => Warehouse.fromJson(warehouseJson))
        .toList();

    return ApiResponse(data: data);
  }
}

class _AcceptMTWOrderState extends State<AcceptMTWOrder> {
  final GlobalKey<FormState> myKey = GlobalKey();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  late String scannedQRCode;
  String? productId;
  String? suborderid;
  String? pAddress;
  String? pNumber;
  String? name;
  String? city;
  String? myware;
  String? longitude;
  String? latitude;
  var loading = false;
  var apiResponse;
  var step1 = 0;
  void initState() {
    super.initState();
    fetchWarehouse();
    fetchOrderDetails(id: widget.ItemOrderId);
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(sHeight > 896 ? sHeight * 0.27 : sHeight * 0.23),
        child: AppBar(
          primary: false,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.colorAccent,
          elevation: 1,
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(0), // Adjust the height as needed
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Warehouse",
                            style: TextStyle(
                                fontSize: sWidth * 0.06,
                                color: AppColors.bgCreamWhite,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            bool change = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Change role'),
                                  content: const Text(
                                      'Do you want to change this role?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            false); // User does not confirm deletion
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            true); // User confirms deletion
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (change) {
                              Navigator.pop(context);
                            }
                          },
                          child: Icon(
                            Icons.change_circle_outlined,
                            color: AppColors.textColor,
                            size: sWidth * 0.08,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: sHeight * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.bgCreamWhite,
                            radius: sWidth * 0.06,
                            child: Center(child: Text('${widget.userName[0]}')),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  widget.userName,
                                  style: TextStyle(
                                      fontSize: sWidth * 0.05,
                                      color: AppColors.bgCreamWhite,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "Warehouse",
                                      style: TextStyle(
                                          fontSize: sWidth * 0.04,
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: sHeight * 0.05,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(navigationKey.currentContext!)
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.textColor),
                            child: const Text(
                              "Sign Out",
                              style: TextStyle(color: AppColors.colorAccent),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: sHeight * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: sWidth,
                  height: sHeight * 0.15,
                  decoration: BoxDecoration(
                      color: AppColors.bgCreamWhite,
                      border: Border.all(color: AppColors.greyColor)),
                  child: loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Order: $suborderid(MW)"),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: sWidth * 0.6,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: sWidth * 0.06,
                                    width: sWidth * 0.06,
                                    decoration: BoxDecoration(
                                        color: AppColors.colorAccent,
                                        borderRadius: BorderRadius.circular(
                                            sWidth * 0.06)),
                                    child: Center(
                                      child: step1 == 0
                                          ? Text("1")
                                          : Icon(
                                              Icons.done,
                                              color: AppColors.bgCreamWhite,
                                            ),
                                    ),
                                  ),
                                  Container(
                                    color: step1 == 0
                                        ? AppColors.secondaryColor
                                        : AppColors.colorAccent,
                                    height: sHeight * 0.004,
                                    width: sWidth * 0.2,
                                  ),
                                  Container(
                                    height: sWidth * 0.06,
                                    width: sWidth * 0.06,
                                    decoration: BoxDecoration(
                                        color: step1 == 0
                                            ? AppColors.secondaryColor
                                            : AppColors.colorAccent,
                                        borderRadius: BorderRadius.circular(
                                            sWidth * 0.06)),
                                    child: Center(
                                      child: Text(
                                        "2",
                                        style: TextStyle(
                                            color: step1 == 0
                                                ? AppColors.colorAccent
                                                : AppColors.secondaryColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: SizedBox(
                                width: sWidth * 0.8,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("details"),
                                      SizedBox(
                                        width: sWidth * 0.14,
                                      ),
                                      Text("action"),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              if (step1 == 0)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: sHeight * 0.25,
                    width: sWidth,
                    decoration: BoxDecoration(
                        color: AppColors.bgCreamWhite,
                        border: Border.all(color: AppColors.greyColor)),
                    child: loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text("Pickup Details",
                                              style: TextStyle(
                                                  fontSize: sWidth * 0.05)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Name: $name",
                                            style: TextStyle(
                                                fontSize: sWidth * 0.03),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                              "Physical Address: $pAddress",
                                              style: TextStyle(
                                                  fontSize: sWidth * 0.03)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text("City: $city",
                                              style: TextStyle(
                                                  fontSize: sWidth * 0.03)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text("Phone: $pNumber",
                                              style: TextStyle(
                                                  fontSize: sWidth * 0.03)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        makePhoneCall(pNumber!);
                                      },
                                      child: Text("Call")),
                                  ElevatedButton(
                                      onPressed: () {
                                        openMaps(double.parse(latitude!),
                                            double.parse(longitude!));
                                      },
                                      child: Text("View on Maps")),
                                ],
                              )
                            ],
                          ),
                  ),
                ),
              if (isScannedQRCodeInitialized() && step1 == 1)
                SizedBox(
                  child: Center(child: Text("QRCode scanned successfully")),
                ),
              if (step1 == 1 && !loading)
                SizedBox(
                  height: sHeight * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: SizedBox(
                          height: sHeight * 0.4,
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (step1 == 1 && !loading)
                SizedBox(
                  child: Form(
                      key: myKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 0),
                              child: Text("Warehouse"),
                            ),
                            DropdownButtonFormField<Warehouse>(
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColors.greyColor,
                                focusedBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              items: (apiResponse.data as List<Warehouse>)
                                  .map((Warehouse ware) {
                                return DropdownMenuItem<Warehouse>(
                                  value: ware,
                                  child: Text(
                                    ware.name,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Warehouse field is required';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  myware = value
                                      ?.id; // Use a unique identifier from the Warehouse object
                                  print(myware);
                                });
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (myKey.currentState!.validate() &&
                                        isScannedQRCodeInitialized()) {
                                      bool done = await validateDelivery();
                                      if (done) {
                                        Navigator.pop(context);
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Error'),
                                              content: const Text(
                                                  "Something went wrong, please try again"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(
                                                        true); // User confirms deletion
                                                  },
                                                  child: const Text('Okay'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: const Text("Validate delivery")),
                            ),
                            SizedBox(
                              height: sHeight * 0.2,
                            )
                          ],
                        ),
                      )),
                )
            ],
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (step1 == 0) {
              step1 = 1;
            } else if (step1 == 1) {
              step1 = 0;
            }
            // step1 == 0 ? step1 = 1 : step1 == 0;
          });
        },
        child: step1 == 0
            ? const Icon(Icons.navigate_next_outlined)
            : const Icon(Icons.navigate_before_outlined),
      ),
      floatingActionButtonLocation: step1 == 0
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> fetchWarehouse() async {
    try {
      setState(() {
        loading = true;
      });
      print("hereeee");

      final response = await http.get(Uri.https(
          "api.commercepal.com:2052", "/api/v1/admin/services/wareHouses"));
      // print(response.body);
      var data = jsonDecode(response.body);
      apiResponse = ApiResponse.fromJson(data);

      print(apiResponse.data
          .map((warehouse) => "${warehouse.id}: ${warehouse.name}")
          .toList());
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

  Future<void> fetchOrderDetails(
      {int retryCount = 0, required String id}) async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https("api.commercepal.com:2095",
              "/prime/api/v1/messenger/shipping/order-item", {"ItemId": id}),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['ProductId'] != null) {
          setState(() async {
            productId = data['ProductId'].toString();
            suborderid = data['SubOrderNumber'].toString();
            print(productId);
            final response1 = await http.get(
              Uri.https(
                  "api.commercepal.com:2095",
                  "/prime/api/v1/messenger/shipping/merchant-address",
                  {"ItemId": widget.ItemOrderId}),
              headers: <String, String>{"Authorization": "Bearer $token"},
            );
            var data1 = jsonDecode(response1.body);
            print(data1);
            if (data1['Status'] == '00') {
              setState(() {
                pNumber = data1['phoneNumber'];
                city = data1['cityName'];
                longitude = data1['longitude'];
                latitude = data1['latitude'];
                name = data1['name'];
              });
              pAddress = await getAddressFromLatLng(
                  latitude ?? latitude!, longitude ?? longitude!);
              print(pAddress);
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
            await fetchOrderDetails(
                retryCount: retryCount + 1, id: widget.ItemOrderId.toString());
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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedQRCode = scanData.code!;
        print(scannedQRCode);
        controller.pauseCamera();
      });
    });
  }

  bool isScannedQRCodeInitialized() {
    try {
      scannedQRCode; // Access the variable to check if it has been initialized
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> getAddressFromLatLng(String latitude, String longitude) async {
    double lat = double.parse(latitude);
    double lng = double.parse(longitude);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "${place.name}, ${place.locality}, ${place.country}";
        return address;
      } else {
        return "No address found";
      }
    } catch (e) {
      print("Error getting address: $e");
      return "Error getting address";
    }
  }

  void makePhoneCall(String phoneNumber) async {
    String url = "tel:$phoneNumber";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch $url");
    }
  }

  void openMaps(double latitude, double longitude) async {
    try {
      String url =
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

      // if (await canLaunch(url)) {
      await launch(url);
      // } else {
      print("Could not launch $url");
      // }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> validateDelivery({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> payload = {
        "OrderItemId": int.parse(widget.ItemOrderId),
        "QrCodeNumber": scannedQRCode.toString(),
        "WareHouseId": int.parse(myware!),
        "Comments": "warehouse accepted"
      };
      print(payload);
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
          Uri.https(
            "api.commercepal.com:2095",
            "/prime/api/v1/ware-house/shipping/accept-item",
          ),
          body: jsonEncode(payload),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            loading = false;
          });
          return true;
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await validateDelivery(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              loading = false;
            });
            return false;
          }
          return false;
        }
      }
      return false;
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
      return false;
    }
  }
}
