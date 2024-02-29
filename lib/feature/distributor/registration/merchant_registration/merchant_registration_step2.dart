import 'dart:convert';
import 'dart:io';

import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MerchantRegistrationstep2 extends StatefulWidget {
  const MerchantRegistrationstep2({super.key});

  @override
  State<MerchantRegistrationstep2> createState() =>
      _MerchantRegistrationstep2State();
}

class CityData {
  final String cityName;
  final int cityId;
  final int countryId;
  CityData(
      {required this.countryId, required this.cityId, required this.cityName});
}

class CountryData {
  final String country;
  final String countryCode;
  CountryData({required this.country, required this.countryCode});
}

class _MerchantRegistrationstep2State extends State<MerchantRegistrationstep2> {
  List<CountryData> countries = [];
  List<CityData> cities = [];
  var loading = false;
  List<String>? hereData;
  String? merchantName;
  String? taxNumber;
  String? country;
  String? district;
  String? city;
  File? _imageShop;
  File? _imageCom;
  File? _imageBus;
  File? _imageID;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    fetchState();
    fetchCity();
    fetchCountry();
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
                            'Step 2',
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
                            'Business Information',
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
                              'Enter the details and attach the required docs to complete this step',
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
                        child: Text("Merchant Name"),
                      ),
                      TextFormField(
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
                            merchantName = value;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Merchant name is required';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Tax Number"),
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
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            taxNumber = value;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Tax Number is required';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Country"),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        items: countries.map((CountryData country) {
                          return DropdownMenuItem<String>(
                            value: country.countryCode.toString(),
                            child: Text(
                              country.country,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            country = value;
                          });
                        },
                        value: hereData!.isNotEmpty ? hereData![2] : null,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Country field is required';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("District"),
                      ),
                      TextFormField(
                        initialValue:
                            hereData!.isNotEmpty ? hereData![3] : null,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        keyboardType: TextInputType.streetAddress,
                        onChanged: (value) {
                          setState(() {
                            district = value;
                          });
                        },
                        validator: (value) {
                          // Define your regular expressions
                          if (value!.isEmpty) {
                            return 'District is required';
                          }

                          // Validation passed
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("City"),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        items: cities.map((CityData city) {
                          return DropdownMenuItem<String>(
                            value: city.cityId.toString(),
                            child: Text(
                              city.cityName,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'City field is required';
                          }
                          return null;
                        },
                        value: hereData!.isNotEmpty ? hereData![4] : null,
                        onChanged: (value) {
                          setState(() {
                            city = value;
                          });
                        },
                      ),
                      Text("Shop image"),
                      _imageShop == null
                          ? SizedBox(child: Text('JPG/PNG images'))
                          : SizedBox(
                              height: sHeight * 0.15,
                              child: Image.file(_imageShop!)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FloatingActionButton(
                              onPressed: () =>
                                  _getImageshop(ImageSource.gallery),
                              tooltip: 'Pick Image from Gallery',
                              child: Icon(Icons.photo),
                            ),
                            SizedBox(width: 16),
                            FloatingActionButton(
                              onPressed: () =>
                                  _getImageshop(ImageSource.camera),
                              tooltip: 'Take a Photo',
                              child: Icon(Icons.camera_alt),
                            ),
                          ],
                        ),
                      ),
                      Text("Commercial Certificate image"),
                      _imageCom == null
                          ? SizedBox(child: Text('JPG/PNG images'))
                          : SizedBox(
                              height: sHeight * 0.15,
                              child: Image.file(_imageCom!)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FloatingActionButton(
                              onPressed: () =>
                                  _getImageComm(ImageSource.gallery),
                              tooltip: 'Pick Image from Gallery',
                              child: Icon(Icons.photo),
                            ),
                            SizedBox(width: 16),
                            FloatingActionButton(
                              onPressed: () =>
                                  _getImageComm(ImageSource.camera),
                              tooltip: 'Take a Photo',
                              child: Icon(Icons.camera_alt),
                            ),
                          ],
                        ),
                      ),
                      Text("Business Registration image"),
                      _imageBus == null
                          ? SizedBox(child: Text('JPG/PNG images'))
                          : SizedBox(
                              height: sHeight * 0.15,
                              child: Image.file(_imageBus!)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FloatingActionButton(
                              onPressed: () =>
                                  _getImageBusiness(ImageSource.gallery),
                              tooltip: 'Pick Image from Gallery',
                              child: Icon(Icons.photo),
                            ),
                            SizedBox(width: 16),
                            FloatingActionButton(
                              onPressed: () =>
                                  _getImageBusiness(ImageSource.camera),
                              tooltip: 'Take a Photo',
                              child: Icon(Icons.camera_alt),
                            ),
                          ],
                        ),
                      ),
                      Text("ID Photo"),
                      _imageID == null
                          ? SizedBox(child: Text('JPG/PNG images'))
                          : SizedBox(
                              height: sHeight * 0.15,
                              child: Image.file(_imageID!)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FloatingActionButton(
                              onPressed: () => _getImageID(ImageSource.gallery),
                              tooltip: 'Pick Image from Gallery',
                              child: Icon(Icons.photo),
                            ),
                            SizedBox(width: 16),
                            FloatingActionButton(
                              onPressed: () => _getImageID(ImageSource.camera),
                              tooltip: 'Take a Photo',
                              child: Icon(Icons.camera_alt),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sHeight * 0.2,
                      )
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
              if (_imageShop != null &&
                  _imageID != null &&
                  _imageCom != null &&
                  _imageBus != null) {
                bool myForm = await submmitForm();
                if (!myForm) {
                  context.displayDialog(
                      title: "Failed",
                      message: 'Something went wrong, please try again');
                } else {
                  Navigator.pop(context, "yes");
                }
              } else {
                context.displaySnack("Please select all images required");
              }
            },
            child: const Text("Complete this step")),
      ),
    );
  }

  Future<bool> submmitForm() async {
    try {
      if (_formKey.currentState!.validate()) {
        List<String> myList = [
          merchantName!,
          taxNumber!,
          country!,
          district!,
          city!,
          _imageShop!.path,
          _imageCom!.path,
          _imageBus!.path,
          _imageID!.path,
          '1'
        ];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setStringList("step2", myList);
        print(myList);
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> fetchState() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        hereData = prefs.getStringList("step2");
        print("herewego");
        print(hereData);
        if (hereData!.isNotEmpty) {
          merchantName = hereData![0];
          taxNumber = hereData![1];
          country = hereData![2];
          district = hereData![3];
          city = hereData![4];
          _imageShop = File(hereData![5]);
          _imageCom = File(hereData![6]);
          _imageBus = File(hereData![7]);
          _imageID = File(hereData![8]);
        }
        // step = steps![4];
      });
      // print(step);
    } catch (e) {
      print(e.toString());
    }
  }

  Future _getImageshop(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          _imageShop = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(_imageShop!.path).then((success) {
            print("Image saved to gallery: $success");
            print("hereweare");
            print(_imageShop);
          });
        } else {
          _imageShop = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          print("herewego");
          print(_imageShop);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getImageID(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          _imageID = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(_imageID!.path).then((success) {
            print("Image saved to gallery: $success");
            print("hereweare");
            print(_imageID);
          });
        } else {
          _imageID = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          print("herewego");
          print(_imageID);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getImageBusiness(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          _imageBus = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(_imageBus!.path).then((success) {
            print("Image saved to gallery: $success");
            print("hereweare");
            print(_imageBus);
          });
        } else {
          _imageBus = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          print("herewego");
          print(_imageBus);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getImageComm(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          _imageCom = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(_imageCom!.path).then((success) {
            print("Image saved to gallery: $success");
            print("hereweare");
            print(_imageCom);
          });
        } else {
          _imageCom = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          print("herewego");
          print(_imageCom);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> fetchCity() async {
    try {
      setState(() {
        loading = true;
      });
      print("hereeee");

   
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

  Future<void> fetchCountry() async {
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
          "api.commercepal.com:2096", "/prime/api/v1/service/countries"));
      // print(response.body);
      var data = jsonDecode(response.body);
      countries.clear();
      for (var b in data['data']) {
        countries.add(
            CountryData(countryCode: b['countryCode'], country: b['country']));
      }
      print(countries.length);
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
