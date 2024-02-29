import 'dart:convert';
import 'dart:io';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/distributor/registration/agent_registration/agent_registration_step2.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AgentDetails extends StatefulWidget {
  final String userId;

  const AgentDetails({Key? key, required this.userId}) : super(key: key);

  @override
  _AgentDetailsState createState() => _AgentDetailsState();
}

class AgentData {
  final String businessLicense;
  final String ownerPhoneNumber;
  final int city;
  final String country;
  final String BusinessRegistrationPhoto;
  final String commercialCertNo;
  final String TaxPhoto;
  final String email;
  final String TillNumberImage;
  final String OwnerPhoto;
  final String ShopImage;
  final String CommercialCertImage;
  final String phoneNumber;
  final String firstName;
  final String tillNumber;
  AgentData({
    required this.tillNumber,
    required this.country,
    required this.businessLicense,
    required this.ownerPhoneNumber,
    required this.city,
    required this.BusinessRegistrationPhoto,
    required this.commercialCertNo,
    required this.TaxPhoto,
    required this.email,
    required this.TillNumberImage,
    required this.OwnerPhoto,
    required this.ShopImage,
    required this.CommercialCertImage,
    required this.phoneNumber,
    required this.firstName,
  });
}

class _AgentDetailsState extends State<AgentDetails> {
  var edit1 = false;
  var edit2 = false;
  String? email;
  String? mobileNumber;
  String? taxNumber;
  String? comCerNum;
  String? country;
  String? businessMobileNumber;
  String? _imageShopPath;
  File? _imageShop;
  String? _imageComCerPath;
  File? _imageComCer;
  String? _imageTaxDocPath;
  File? _imageTaxDoc;
  int? city;
  @override
  void initState() {
    super.initState();
    fetchUser(retryCount: 0, userId: widget.userId.toString());
    fetchCity();
    fetchCountry();
  }

  List<CityData> cities = [];
  List<CountryData> countries = [];
  List<AgentData>? agent = [];
  var loading = false;
  var loading1 = false;

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var Swidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
        appBar: AppBar(
          title: Text('Agent Details'),
        ),
        body: loading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  Text("Fetching user data")
                ],
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: Swidth * 0.1,
                          backgroundImage: NetworkImage(
                              agent!.isNotEmpty ? agent![0].OwnerPhoto : ""),
                        ),
                        Text(
                          agent!.isNotEmpty ? agent![0].firstName : "",
                          style: TextStyle(
                              fontSize: Swidth * 0.05,
                              fontWeight: FontWeight.w700),
                        ),
                        Text("Aproved Agent"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: sHeight * 0.1,
                            width: Swidth * 01,
                            decoration:
                                BoxDecoration(color: AppColors.colorAccent),
                            // child: ,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Personal Information",
                                style: TextStyle(fontSize: Swidth * 0.05),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      edit1 = !edit1;
                                    });
                                  },
                                  child: Text("Edit"))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Email Address"),
                                ),
                                TextFormField(
                                  enabled: edit1,
                                  initialValue: email!.isNotEmpty && !loading
                                      ? email
                                      : null,
                                  decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.greyColor,
                                      disabledBorder: InputBorder.none,
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
                                      return 'Email is required';
                                    } else if (!isValidEmail(value!)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Mobile Number"),
                                ),
                                TextFormField(
                                  enabled: edit1,
                                  initialValue: mobileNumber!.isNotEmpty
                                      ? mobileNumber
                                      : null,
                                  decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.greyColor,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Business Information",
                                      style: TextStyle(fontSize: Swidth * 0.05),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            edit2 = !edit2;
                                          });
                                        },
                                        child: Text("Edit"))
                                  ],
                                ),
                                const Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Tax Number"),
                                ),
                                TextFormField(
                                  enabled: edit2,
                                  initialValue:
                                      taxNumber!.isNotEmpty ? taxNumber : null,
                                  decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.greyColor,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
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
                                const Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Commercial certificate number"),
                                ),
                                TextFormField(
                                  enabled: edit2,
                                  initialValue:
                                      comCerNum!.isNotEmpty ? comCerNum : null,
                                  decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.greyColor,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      comCerNum = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value?.isEmpty == true) {
                                      return 'Cemmercial certificate Number is required';
                                    }
                                    return null;
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Country"),
                                ),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.greyColor,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
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
                                  onChanged: edit2
                                      ? (value) {
                                          setState(() {
                                            country = value;
                                          });
                                        }
                                      : null,
                                  value: country!.isNotEmpty && !loading1
                                      ? country
                                      : null,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Country field is required';
                                    }
                                    return null;
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("City"),
                                ),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.greyColor,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
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
                                      return 'Country field is required';
                                    }
                                    return null;
                                  },
                                  value: city != null && !loading1
                                      ? city.toString()
                                      : null,
                                  onChanged: edit2
                                      ? (value) {
                                          setState(() {
                                            city = int.parse(value!);
                                          });
                                        }
                                      : null,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Business Mobile Number"),
                                ),
                                TextFormField(
                                  enabled: edit1,
                                  initialValue: businessMobileNumber!.isNotEmpty
                                      ? businessMobileNumber
                                      : null,
                                  decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.greyColor,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    setState(() {
                                      businessMobileNumber = value;
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
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Shop image"),
                                ),
                                _imageShop != null && edit2
                                    ? SizedBox(
                                        height: sHeight * 0.2,
                                        child: Image.file(_imageShop!),
                                      )
                                    : _imageShopPath == null
                                        ? SizedBox(
                                            child: Text('JPG/PNG images'))
                                        : SizedBox(
                                            height: sHeight * 0.15,
                                            child: Image(
                                                image: NetworkImage(
                                                    _imageShopPath!)),
                                            // Image.file(_imageShop!)
                                          ),
                                if (edit2)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        FloatingActionButton(
                                          onPressed: !edit2
                                              ? null
                                              : () => _getImageshop(
                                                  ImageSource.gallery),
                                          tooltip: 'Pick Image from Gallery',
                                          child: Icon(Icons.photo),
                                        ),
                                        SizedBox(width: 16),
                                        FloatingActionButton(
                                          onPressed: () => !edit2
                                              ? null
                                              : _getImageshop(
                                                  ImageSource.camera),
                                          tooltip: 'Take a Photo',
                                          child: Icon(Icons.camera_alt),
                                        ),
                                      ],
                                    ),
                                  ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Commercial Certificate image"),
                                ),
                                _imageComCer != null && edit2
                                    ? SizedBox(
                                        height: sHeight * 0.2,
                                        child: Image.file(_imageComCer!),
                                      )
                                    : _imageComCerPath == null
                                        ? SizedBox(
                                            child: Text('JPG/PNG images'))
                                        : SizedBox(
                                            height: sHeight * 0.15,
                                            child: Image(
                                                image: NetworkImage(
                                                    _imageComCerPath!)),
                                            // Image.file(_imageShop!)
                                          ),
                                if (edit2)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        FloatingActionButton(
                                          onPressed: !edit2
                                              ? null
                                              : () => _getImageComm(
                                                  ImageSource.gallery),
                                          tooltip: 'Pick Image from Gallery',
                                          child: Icon(Icons.photo),
                                        ),
                                        SizedBox(width: 16),
                                        FloatingActionButton(
                                          onPressed: () => !edit2
                                              ? null
                                              : _getImageComm(
                                                  ImageSource.camera),
                                          tooltip: 'Take a Photo',
                                          child: Icon(Icons.camera_alt),
                                        ),
                                      ],
                                    ),
                                  ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Agent Tax Document image"),
                                ),
                                _imageTaxDoc != null && edit2
                                    ? SizedBox(
                                        height: sHeight * 0.2,
                                        child: Image.file(_imageTaxDoc!),
                                      )
                                    : _imageTaxDocPath == null
                                        ? SizedBox(
                                            child: Text('JPG/PNG images'))
                                        : SizedBox(
                                            height: sHeight * 0.15,
                                            child: Image(
                                                image: NetworkImage(
                                                    _imageTaxDocPath!)),
                                            // Image.file(_imageShop!)
                                          ),
                                if (edit2)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        FloatingActionButton(
                                          onPressed: !edit2
                                              ? null
                                              : () => _getImageTaxDoc(
                                                  ImageSource.gallery),
                                          tooltip: 'Pick Image from Gallery',
                                          child: Icon(Icons.photo),
                                        ),
                                        SizedBox(width: 16),
                                        FloatingActionButton(
                                          onPressed: () => !edit2
                                              ? null
                                              : _getImageTaxDoc(
                                                  ImageSource.camera),
                                          tooltip: 'Take a Photo',
                                          child: Icon(Icons.camera_alt),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ));
  }

  bool isValidEmail(String email) {
    // Regular expression for a basic email validation
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    );

    return emailRegex.hasMatch(email);
  }

  Future<void> fetchUser({int retryCount = 0, required String userId}) async {
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
            "/prime/api/v1/distributor/get-user",
            {"userType": "BUSINESS", "userId": userId},
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['statusDescription'] == 'success') {
          setState(() {
            email = data['data']['email'];
            mobileNumber = data['data']['ownerPhoneNumber'];
            taxNumber = data['data']['tillNumber'];
            comCerNum = data['data']['commercialCertNo'];
            country = data['data']['country'];
            city = data['data']['city'];
            businessMobileNumber = data['data']['phoneNumber'];
            _imageShopPath = data['data']['ShopImage'];
            _imageComCerPath = data['data']['CommercialCertImage'];
            _imageTaxDocPath = data['data']['TaxPhoto'];
            print(_imageShopPath);
            agent!.clear();

            agent!.add(AgentData(
              tillNumber: data['data']['tillNumber'],
              country: data['data']['country'],
              OwnerPhoto: data['data']['OwnerPhoto'],
              firstName: data['data']['firstName'],
              ownerPhoneNumber: data['data']['ownerPhoneNumber'],
              TillNumberImage: data['data']['TillNumberImage'],
              TaxPhoto: data['data']['TaxPhoto'],
              email: data['data']['email'],
              businessLicense: data['data']['businessLicense'],
              BusinessRegistrationPhoto: data['data']
                  ['BusinessRegistrationPhoto'],
              city: data['data']['city'],
              commercialCertNo: data['data']['commercialCertNo'],
              CommercialCertImage: data['data']['CommercialCertImage'],
              ShopImage: data['data']['ShopImage'],
              phoneNumber: data['data']['phoneNumber'],
            ));

            loading = false;
          });
          print(agent!.length);
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchUser(
                retryCount: retryCount + 1, userId: widget.userId.toString());
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

  Future<void> fetchCountry() async {
    try {
      setState(() {
        loading1 = true;
      });
      // print("hereeee");
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
        loading1 = false;
      });
      // }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading1 = false;
      });
    }
    setState(() {
      loading1 = false;
    });
  }

  Future<void> fetchCity() async {
    try {
      setState(() {
        loading1 = true;
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
        loading1 = false;
      });
      // }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading1 = false;
      });
    }
    setState(() {
      loading1 = false;
    });
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

  Future _getImageComm(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          _imageComCer = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(_imageComCer!.path).then((success) {
            print("Image saved to gallery: $success");
            print("hereweare");
            print(_imageComCer);
          });
        } else {
          _imageComCer = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          print("herewego");
          print(_imageComCer);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future _getImageTaxDoc(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          _imageTaxDoc = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(_imageTaxDoc!.path).then((success) {
            print("Image saved to gallery: $success");
            print("hereweare");
            print(_imageTaxDoc);
          });
        } else {
          _imageTaxDoc = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          print("herewego");
          print(_imageTaxDoc);
        }
      } else {
        print('No image selected.');
      }
    });
  }
}
