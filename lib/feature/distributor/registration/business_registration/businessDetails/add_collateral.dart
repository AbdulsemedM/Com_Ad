import 'dart:convert';
import 'dart:io';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddBusinessCollatral extends StatefulWidget {
  final String userId;
  const AddBusinessCollatral({Key? key, required this.userId})
      : super(key: key);
  @override
  State<AddBusinessCollatral> createState() => _AddBusinessCollatralState();
}

class _AddBusinessCollatralState extends State<AddBusinessCollatral> {
  final GlobalKey<FormState> myForm = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController estimatedController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  File? _image;
  var loading = false;
  String? bId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Collateral',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: myForm,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Name",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColors.greyColor,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Estimated Worth",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextFormField(
                    controller: estimatedController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColors.greyColor,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Estimated worth is required';
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Description",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextFormField(
                    maxLines: 3,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColors.greyColor,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Description is required';
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Comments",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextFormField(
                    maxLines: 3,
                    controller: commentsController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColors.greyColor,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Comment is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Text("Attach Image"),
                  _image == null
                      ? SizedBox(child: Text('JPG/PNG file'))
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
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
                  loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (myForm.currentState!.validate() &&
                                    _image != null) {
                                  bool done = await submitForm();
                                  if (done) {
                                    context.displaySnack(
                                        "Collateral added successfully");
                                    Navigator.pop(context);
                                  } else {
                                    context.displaySnack(
                                        "something went wrong, please try again");
                                  }
                                } else {
                                  context.displaySnack(
                                      "Please add the required information");
                                }
                              },
                              child: Text('Submit')))
                ],
              ),
            )),
      ),
    );
  }

  Future<bool> submitForm() async {
    try {
      setState(() {
        loading = true;
      });

      print("hereeeewego");
      Map<String, dynamic> payload = {
        "BusinessId": int.parse(widget.userId),
        "FinancialInstitution": 1,
        "CollateralName": nameController.text,
        "CollateralType": "CollateralType",
        "Description": descriptionController.text,
        "EstimateWorth": estimatedController.text,
        "Comments": commentsController.text,
        "filePath": _image!.path
      };
      print(payload);
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https("api.commercepal.com:2096",
                "/prime/api/v1/distributor/business/collateral/add-collateral"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          bId = data["CollateralId"].toString();
          print(bId);
          await uploadImage(
            imageFile: _image!.path,
            collateralId: bId!,
          );
          setState(() {
            loading = false;
          });
          return true;
        } else {
          bId = data['statusMessage:'];
          setState(() {
            loading = false;
          });
          return false;
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

  Future<void> uploadImage({
    required String imageFile,
    required String collateralId,
  }) async {
    final prefsData = getIt<PrefsData>();
    final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
    if (isUserLoggedIn) {
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api.commercepal.com:2096/prime/api/v1/distributor/business/collateral/upload-document',
        ),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['collateralId'] = collateralId;

      // Add the image file
      var image = await http.MultipartFile.fromPath('file', imageFile);
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
}
