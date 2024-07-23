import 'dart:io';

import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/capitalizer.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MerchantStep1 extends StatefulWidget {
  const MerchantStep1({super.key});

  @override
  State<MerchantStep1> createState() => _MerchantStep1State();
}

class _MerchantStep1State extends State<MerchantStep1> {
  String? fullName;
  String? email;
  String? mobileNumber;
  File? _image;
  List<String>? hereData;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchState();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () async {
                      Navigator.pop(context, "yes");
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 14),
                      child: Icon(
                        Icons.arrow_back_rounded,
                      ),
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Step 1',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: sWidth * 0.05,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Personal Information',
                            style: TextStyle(
                                fontSize: sWidth * 0.05,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: sWidth * 0.8,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(
                              'Enter the personal details and attach Profile image of the Mechcant',
                              style: TextStyle(
                                fontSize: sWidth * 0.03,
                              ),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Full Name"),
                      ),
                      TextFormField(
                        inputFormatters: [CapitalizeEachWordInputFormatter()],
                        initialValue:
                            hereData!.isNotEmpty ? hereData![0] : null,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        // : 'Full Name',
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {
                            fullName = value;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Email Address"),
                      ),
                      TextFormField(
                        initialValue:
                            hereData!.isNotEmpty ? hereData![1] : null,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return null;
                          } else if (!isValidEmail(value!)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Mobile Number"),
                      ),
                      TextFormField(
                        initialValue:
                            hereData!.isNotEmpty ? hereData![2] : null,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          setState(() {
                            mobileNumber = value;
                          });
                        },
                        validator: (value) {
                          // Define your regular expressions
                          var regExp1 = RegExp(r'^0\d{9}$');
                          var regExp2 = RegExp(r'^\+251\d{9}$');
                          var regExp3 = RegExp(r'^\251\d{9}$');

                          // Check if the entered value matches either expression
                          if (!(regExp1.hasMatch(value!) ||
                              regExp3.hasMatch(value) ||
                              regExp2.hasMatch(value))) {
                            return 'Enter a valid mobile number';
                          }

                          // Validation passed
                          return null;
                        },
                      ),
                      Text("Profile Image"),
                      _image == null
                          ? SizedBox(child: Text('JPG/PNG file'))
                          : SizedBox(
                              height: sHeight * 0.15,
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
                    ]),
              ),
            )
          ],
        ),
      )),
      floatingActionButton: SizedBox(
        width: sWidth * 0.9,
        height: sHeight * 0.06,
        child: ElevatedButton(
            onPressed: () async {
              if (_image != null) {
                bool myForm = await submmitForm();
                if (!myForm) {
                  context.displayDialog(
                      title: "Failed",
                      message: 'Something went wrong, please try again');
                } else {
                  Navigator.pop(context, "yes");
                }
              } else {
                context.displaySnack("Please select a profie image");
              }
            },
            child: const Text("Complete this step")),
      ),
    );
  }

  bool isValidEmail(String email) {
    // Regular expression for email validation limited to specific domains
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@(gmail\.com|yahoo\.com|hotmail\.com|outlook\.com|icloud\.com)$',
    );

    return emailRegex.hasMatch(email);
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

  Future<bool> submmitForm() async {
    try {
      print(_formKey.currentState!.validate());
      if (_formKey.currentState!.validate()) {
        List<String> myList = [
          fullName!,
          email ?? "",
          mobileNumber!,
          _image!.path,
          '1'
        ];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setStringList("step1", myList);
        print(myList);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchState() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        hereData = prefs.getStringList("step1");
        print("herewego");
        print(hereData);
        if (hereData!.isNotEmpty) {
          fullName = hereData![0];
          email = hereData![1];
          mobileNumber = hereData![2];
          _image = File(hereData![3]);
        }
        // step = steps![4];
      });
      // print(step);
    } catch (e) {
      print(e.toString());
    }
  }
}
