import 'dart:convert';
import 'dart:io';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptedOrder extends StatefulWidget {
  final String ItemId;
  final String DeliveryId;
  final String userName;
  const AcceptedOrder(
      {Key? key,
      required this.ItemId,
      required this.DeliveryId,
      required this.userName})
      : super(key: key);

  @override
  State<AcceptedOrder> createState() => _AcceptedOrderState();
}

class _AcceptedOrderState extends State<AcceptedOrder> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  late String scannedQRCode;
  String? productId;
  String? suborderid;
  String? pAddress;
  String? pNumber;
  String? name;
  String? city;
  String? longitude;
  String? latitude;
  String otp = "";
  String? message;
  List<String> productImages = [];
  var loading = false;
  var step1 = 0;
  var step2 = 0;
  var step3 = 0;
  var step4 = 0;
  var scanned = false;
  File? _image;
  @override
  void initState() {
    super.initState();
    fetchOrderDetails(id: widget.ItemId.toString());
    fetchProductImages();
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
                        SizedBox(width: 20)
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
                                    child: Text("Order: $suborderid(MC)"),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: sWidth * 0.9,
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
                                      width: sWidth * 0.15,
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
                                        child: step1 == 1 && step2 == 1
                                            ? const Icon(
                                                Icons.done,
                                                color: AppColors.bgCreamWhite,
                                              )
                                            : Text(
                                                "2",
                                                style: TextStyle(
                                                    color:
                                                        step1 == 1 && step2 == 0
                                                            ? AppColors
                                                                .secondaryColor
                                                            : AppColors
                                                                .colorAccent),
                                              ),
                                      ),
                                    ),
                                    Container(
                                      color: step1 == 1 && step2 == 1
                                          ? AppColors.colorAccent
                                          : AppColors.secondaryColor,
                                      height: sHeight * 0.004,
                                      width: sWidth * 0.15,
                                    ),
                                    Container(
                                      height: sWidth * 0.06,
                                      width: sWidth * 0.06,
                                      decoration: BoxDecoration(
                                          color: step1 == 1 &&
                                                  step2 == 1 &&
                                                  step3 == 1
                                              ? AppColors.colorAccent
                                              : AppColors.secondaryColor,
                                          borderRadius: BorderRadius.circular(
                                              sWidth * 0.06)),
                                      child: Center(
                                        child: step1 == 1 &&
                                                step2 == 1 &&
                                                step3 == 1
                                            ? const Icon(
                                                Icons.done,
                                                color: AppColors.bgCreamWhite,
                                              )
                                            : Text(
                                                "3",
                                                style: TextStyle(
                                                    color: step1 == 1 &&
                                                            step2 == 1 &&
                                                            step3 == 1
                                                        ? AppColors.bgCreamWhite
                                                        : AppColors
                                                            .colorAccent),
                                              ),
                                      ),
                                    ),
                                    Container(
                                      color:
                                          step1 == 1 && step2 == 1 && step3 == 1
                                              ? AppColors.colorAccent
                                              : AppColors.secondaryColor,
                                      height: sHeight * 0.004,
                                      width: sWidth * 0.15,
                                    ),
                                    Container(
                                      height: sWidth * 0.06,
                                      width: sWidth * 0.06,
                                      decoration: BoxDecoration(
                                          color: step1 == 1 &&
                                                  step2 == 1 &&
                                                  step3 == 1
                                              ? AppColors.colorAccent
                                              : AppColors.secondaryColor,
                                          borderRadius: BorderRadius.circular(
                                              sWidth * 0.06)),
                                      child: Center(
                                        child: Text(
                                          "4",
                                          style: TextStyle(
                                              color: step1 == 1 &&
                                                      step2 == 1 &&
                                                      step3 == 1
                                                  ? AppColors.bgCreamWhite
                                                  : AppColors.colorAccent),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: SizedBox(
                                  width: sWidth * 0.9,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("details"),
                                        SizedBox(
                                          width: sWidth * 0.1,
                                        ),
                                        Text("OTP"),
                                        SizedBox(
                                          width: sWidth * 0.1,
                                        ),
                                        Text("QRCode"),
                                        SizedBox(
                                          width: sWidth * 0.1,
                                        ),
                                        Text("Image"),
                                      ]),
                                ),
                              ),
                              SizedBox(
                                height: sHeight * 0.015,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Text("Product Images"),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
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
                if (step2 == 0 && !loading && step1 == 1)
                  SizedBox(
                    height: sHeight * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            otp,
                            style: TextStyle(fontSize: sWidth * 0.06),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await getOTP();
                          },
                          child: Text("Generate OTP"),
                        ),
                      ],
                    ),
                  ),
                if (step2 == 1 && !loading && step1 == 1 && step3 == 0)
                  SizedBox(
                    height: sHeight * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
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
                if (step2 == 1 &&
                    !loading &&
                    step1 == 1 &&
                    step3 == 1 &&
                    step4 == 0)
                  Column(
                    children: [
                      Text("Upload Product Image"),
                      _image == null
                          ? SizedBox(child: Text('JPG/PNG file'))
                          : SizedBox(
                              height: sHeight * 0.25,
                              child: Image.file(_image!)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FloatingActionButton(
                              onPressed: () => _getImage(ImageSource.gallery),
                              tooltip: 'Pick Image from Gallery',
                              child: Icon(Icons.photo),
                            ),
                            SizedBox(width: 16),
                            FloatingActionButton(
                              onPressed: () => _getImage(ImageSource.camera),
                              tooltip: 'Take a Photo',
                              child: Icon(Icons.camera_alt),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: sHeight * 0.15,
                ),
                if (!loading &&
                    step2 == 1 &&
                    step1 == 1 &&
                    step3 == 1 &&
                    step4 == 0)
                  SizedBox(
                    height: sHeight * 0.15,
                  )
              ],
            ),
          ),
          if (!loading && step1 == 0)
            Positioned(
              bottom: 10,
              right: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), backgroundColor: Colors.orange),
                    onPressed: () {
                      setState(() {
                        if (step1 == 0) {
                          step1 = 1;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!loading && step1 == 1 && step2 == 0 && step3 == 0 && step4 == 0)
            Positioned(
              bottom: 10,
              left: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), backgroundColor: Colors.orange),
                    onPressed: () {
                      setState(() {
                        if (step1 == 1) {
                          step1 = 0;
                          step2 = 0;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.navigate_before_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!loading && step2 == 0 && step1 == 1 && step3 == 0 && step4 == 0)
            Positioned(
              bottom: 10,
              right: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), backgroundColor: Colors.orange),
                    onPressed: () {
                      setState(() {
                        if (step2 == 0) {
                          step2 = 1;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!loading && step1 == 1 && step2 == 1 && step3 == 0 && step4 == 0)
            Positioned(
              bottom: 10,
              left: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), backgroundColor: Colors.orange),
                    onPressed: () {
                      setState(() {
                        if (step2 == 1) {
                          // step1 = 0;
                          step2 = 0;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.navigate_before_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!loading && step2 == 1 && step1 == 1 && step3 == 0 && step4 == 0)
            Positioned(
              bottom: 10,
              right: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), backgroundColor: Colors.orange),
                    onPressed: () {
                      setState(() {
                        if (step3 == 0) {
                          step3 = 1;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!loading && step2 == 1 && step1 == 1 && step3 == 1 && step4 == 0)
            Positioned(
              bottom: 10,
              left: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), backgroundColor: Colors.orange),
                    onPressed: () {
                      setState(() {
                        if (step3 == 1) {
                          step3 = 0;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.navigate_before_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!loading && step2 == 1 && step1 == 1 && step3 == 1 && step4 == 0)
            Positioned(
              bottom: 10,
              right: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), backgroundColor: Colors.orange),
                    onPressed: () async {
                      if (otp == "") {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('OTP'),
                              content: const Text(
                                  "You have to generate an OTP first."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(true); // User confirms deletion
                                  },
                                  child: const Text('Okay'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (!isScannedQRCodeInitialized()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('QRCode is empty'),
                              content: Text("You ahve to scan the QR Code"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(true); // User confirms deletion
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (_image == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Image'),
                              content: Text("A product image is required."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(true); // User confirms deletion
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        await collectOrder();
                        if (message == "000") {
                          ///////////////////////////////////////////////////////////////
                          // ignore: use_build_context_synchronously
                          context.displaySnack("Order collected successfully.");
                          await Future.delayed(Duration(seconds: 3));
                          // ignore: use_build_context_synchronously
                          Navigator.popUntil(context,
                              ModalRoute.withName('/messenger_dashboard'));
                          // Navigator.pop(context);
                        } else {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text("$message"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // User confirms deletion
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
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.done,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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

  Future<bool> getOTP({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> payload = {
        "OrderItemId": int.parse(widget.ItemId),
      };
      print(payload);
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        print(payload);
        final response = await http.post(
          Uri.https(
            "api.commercepal.com:2095",
            "/prime/api/v1/messenger/shipping/generate-otp-code",
          ),
          body: jsonEncode(payload),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            otp = data['ValidCode'];
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
            await getOTP(retryCount: retryCount + 1);
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

  Future _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          _image = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(_image!.path).then((success) {
            print("Image saved to gallery: $success");
            print("hereweare");
            print(_image);
          });
        } else {
          _image = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          print("herewego");
          print(_image);
        }
      } else {
        print('No image selected.');
      }
    });
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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedQRCode = scanData.code!;
        step3 = 1;
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> collectOrder({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> QRpayload = {
        "OrderItemId": int.parse(widget.ItemId),
        "QrCodeNumber": scannedQRCode.toString()
      };
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
          Uri.https(
            "api.commercepal.com:2095",
            "/prime/api/v1/messenger/shipping/attach-qr-code-item",
          ),
          body: jsonEncode(QRpayload),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() async {
            setState(() {
              message = data['statusCode'];
              loading = false;
            });
            await uploadImage(
                userType: widget.ItemId, userId: widget.DeliveryId);
          });
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await collectOrder(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              message = data['statusDescription'];
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

  Future<void> uploadImage({
    required String userType,
    required String userId,
  }) async {
    final prefsData = getIt<PrefsData>();
    final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
    if (isUserLoggedIn) {
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api.commercepal.com:2096/prime/api/v1/upload/upload-pick-up',
        ),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['orderItemId'] = userType;
      request.fields['id'] = userId;

      // Add the image file
      var image = await http.MultipartFile.fromPath('file', _image!.path);
      request.files.add(image);
      try {
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        print(response);

        if (responseBody == '000') {
          print('Image uploaded successfully');
        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
          print('Error message: $responseBody');
        }
      } catch (error) {
        print('Error uploading image: $error');
      }
    }

    // Add other fields
  }
}
