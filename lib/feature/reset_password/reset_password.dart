import 'dart:convert';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPassword1 extends StatefulWidget {
  static const routeName = "/reset_password";
  const ResetPassword1({super.key});

  @override
  State<ResetPassword1> createState() => _ResetPassword1State();
}

class _ResetPassword1State extends State<ResetPassword1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? password;
  String? cpassword;
  String? opassword;
  String? message;
  var loading = false;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final String router = args['router'];
    print(router);
    var sHeight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: sHeight * 0.25,
              child:
                  const Image(image: AssetImage("assets/images/app_icon.png")),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Reset Password")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                      child: Text(
                        "Old Password",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Old password is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          opassword = value;
                        });
                      },
                      // title: "Password",
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: "Enter your old password",
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                      child: Text(
                        "New Password",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'New Password is required';
                        }

                        // Password complexity requirements
                        String pattern =
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                        RegExp regex = new RegExp(pattern);

                        if (!regex.hasMatch(value!)) {
                          return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      // title: "Password",
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: "Enter your new password",
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                      child: Text(
                        "Confirm Password",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Confirm password is required';
                        }

                        if (value != password) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          cpassword = null;
                        });
                      },
                      // title: "Password",
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: "Re-enter your new password",
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: loading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      bool done = await sendPassword();
                                      if (done) {
                                        // ignore: use_build_context_synchronously
                                        final prefsData = getIt<PrefsData>();
                                        await prefsData.deleteData(
                                            PrefsKeys.userToken.name);
                                        // ignore: use_build_context_synchronously
                                        // Navigator.pop(context);
                                        if (router == "role") {
                                          Navigator.popUntil(
                                              context,
                                              (route) =>
                                                  route.settings.name ==
                                                  LoginPage.routeName);
                                        }
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            LoginPage
                                                .routeName, // Replace this with the route name of the new page
                                            (route) =>
                                                route.settings.name ==
                                                LoginPage
                                                    .routeName // Replace this with your predicate
                                            );
                                      }
                                    }
                                  },
                                  child: Text("Submit")),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<bool> sendPassword() async {
    try {
      setState(() {
        loading = true;
      });

      print("hereeeewego");
      Map<String, dynamic> payload = {
        "oldPassword": opassword,
        "newPassword": password
      };
      print(payload);
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https(
                "api.commercepal.com:2096", "/prime/api/v1/change-password"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            message = data['statusMessage'];
            loading = false;
          });
          return true;
        } else {
          setState(() {
            message = data['statusMessage'];
            loading = false;
          });
          return false;
        }
      }
    } catch (e) {
      setState(() {
        message = e.toString();
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
}
