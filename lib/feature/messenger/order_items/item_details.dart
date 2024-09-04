import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class OrdererdItemDetails extends StatefulWidget {
  final String ItemId;
  final String DeliveryId;
  final String userName;
  const OrdererdItemDetails(
      {Key? key,
      required this.ItemId,
      required this.DeliveryId,
      required this.userName})
      : super(key: key);

  @override
  State<OrdererdItemDetails> createState() => _OrdererdItemDetailsState();
}

class GetItemDetailsData {
  final String productId;
  final String subOrderNumber;
  GetItemDetailsData({required this.productId, required this.subOrderNumber});
}

class _OrdererdItemDetailsState extends State<OrdererdItemDetails> {
  @override
  void initState() {
    super.initState();
    fetchProductImages();
    fetchOrderDetails(id: widget.ItemId.toString());
  }

  List<String> productImages = [];
  String? productId;
  String? suborderid;
  String? pAddress;
  String? pNumber;
  String? name;
  String? city;
  String? longitude;
  String? latitude;
  var loading = false;
  var step1 = 0;

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
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.bgCreamWhite,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Messenger",
                            style: TextStyle(
                                fontSize: sWidth * 0.06,
                                color: AppColors.bgCreamWhite,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        )
                        // GestureDetector(
                        //   onTap: () async {
                        //     bool change = await showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return AlertDialog(
                        //           title: const Text('Change role'),
                        //           content: const Text(
                        //               'Do you want to change this role?'),
                        //           actions: <Widget>[
                        //             TextButton(
                        //               onPressed: () {
                        //                 Navigator.of(context).pop(
                        //                     false); // User does not confirm deletion
                        //               },
                        //               child: const Text('Cancel'),
                        //             ),
                        //             TextButton(
                        //               onPressed: () {
                        //                 Navigator.of(context).pop(
                        //                     true); // User confirms deletion
                        //               },
                        //               child: const Text('Yes'),
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     );
                        //     if (change) {
                        //       Navigator.pop(context);
                        //     }
                        //   },
                        //   child: Icon(
                        //     Icons.change_circle_outlined,
                        //     color: AppColors.bgCreamWhite,
                        //     size: sWidth * 0.08,
                        //   ),
                        // )
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
                                      "Messenger",
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
                            onPressed: () async {
                              final prefsData = getIt<PrefsData>();
                              await prefsData
                                  .deleteData(PrefsKeys.userToken.name);
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
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
                                  child: Text("Order: $suborderid(MC)"),
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
                            )
                          ],
                        ),
                ),
              ),
              SizedBox(
                height: sHeight * 0.015,
              ),
              if (step1 == 1)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: sWidth,
                    height: sHeight * 0.1,
                    decoration: BoxDecoration(
                        color: AppColors.bgCreamWhite,
                        border: Border.all(color: AppColors.greyColor)),
                    child: loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Row(
                                  children: [
                                    Text("Order Actions"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          bool done = await acceptOrder();
                                          if (done) {
                                            /////////////////////////////////
                                            Navigator.popUntil(
                                                context,
                                                ModalRoute.withName(
                                                    '/messenger_dashboard'));
                                            // Navigator.pop(context);
                                          } else {
                                            context.displaySnack(
                                                "Something went wrong, please try again.");
                                            await Future.delayed(
                                                Duration(seconds: 3));
                                          }
                                        },
                                        child: Text('Accept')),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Reject')),
                                  ],
                                )
                              ]),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text("Order Details"),
                          ],
                        ),
                        SizedBox(
                          height: sHeight * 0.15,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: false,
                            itemCount: productImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Image.network(productImages[index]),
                              );
                            },
                          ),
                        ),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       fetchProductImages();
                        //     },
                        //     child: Text("View product details"))
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: sHeight * 0.015,
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
              SizedBox(
                height: sHeight * 0.1,
              )
            ]),
          ),
        ],
      ),
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
                  {"ItemId": widget.ItemId}),
              headers: <String, String>{"Authorization": "Bearer $token"},
            );
            var data1 = jsonDecode(response1.body);
            print(data1);

            if (data1['Status'] == '00') {
              final pNumber = data1['phoneNumber'];
              final city = data1['cityName'];
              final longitude = data1['longitude'];
              final latitude = data1['latitude'];
              final name = data1['name'];

              print(pNumber);

              final pAddress = await getAddressFromLatLng(
                latitude ?? latitude!,
                longitude ?? longitude!,
              );
              setState(() {
                // this.productId = productId;
                // this.suborderid = suborderid;
                this.pNumber = pNumber;
                this.city = city;
                this.longitude = longitude;
                this.latitude = latitude;
                this.name = name;
                this.pAddress = pAddress;
                loading = false;
              });
              // setState(() async {
              //   pNumber = data1['phoneNumber'];
              //   city = data1['cityName'];
              //   longitude = data1['longitude'];
              //   latitude = data1['latitude'];
              //   name = data1['name'];

              //   print(pNumber);
              // });
              // setState(() async {
              //   pAddress = await getAddressFromLatLng(
              //       latitude ?? latitude!, longitude ?? longitude!);
              // });
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
                retryCount: retryCount + 1, id: widget.ItemId.toString());
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

  Future<String> getAddressFromLatLng(String latitude, String longitude) async {
    try {
      double lat = double.parse(latitude);
      double lng = double.parse(longitude);

      // If parsing is successful, use lat and lng
      print("Latitude: $lat, Longitude: $lng");
    } catch (e) {
      // If parsing fails, handle the exception
      return ("Error getting address");
    }
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

  Future<bool> acceptOrder({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> payload = {
        "DeliveryId": int.parse(widget.DeliveryId),
        "Status": 1,
        "Remarks": "I have accepted for delivery"
      };
      print(payload);
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
          Uri.https(
            "api.commercepal.com:2095",
            "/prime/api/v1/messenger/shipping/accept-order-delivery",
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
            await acceptOrder(retryCount: retryCount + 1);
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

  Future<void> fetchProductImages({int retryCount = 0}) async {
    try {
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
              "api.commercepal.com:2095",
              "/prime/api/v1/merchant/order/product-info",
              {"ItemId": widget.ItemId.toString()}),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['Status'] == "00") {
          setState(() {
            for (var pImg in data['subProductInfo']['subProductImages']) {
              productImages.add(pImg);
            }
          });
          print(productImages.length);
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchProductImages(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
          }
        }
      }
    } catch (e) {
      print(e.toString());

      // Handle other exceptions
    }
  }
}
