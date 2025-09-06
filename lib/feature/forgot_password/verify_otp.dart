import 'dart:convert';

import 'package:commercepal_admin_flutter/feature/forgot_password/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;

class VerifyOTP extends StatefulWidget {
  final String userName;
  const VerifyOTP({Key? key, required this.userName}) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  var loading = false;
  String? myOTP;
  String? jwttoken;
  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              height: sHeight * 0.25,
              child:
                  const Image(image: AssetImage("assets/images/app_icon.png")),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
                child: Text(
              "OTP Verification",
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "Please enter the OTP sent to you",
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: OTPTextField(
                length: 4,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 50,
                style: TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceEvenly,
                fieldStyle: FieldStyle.underline,
                onCompleted: (pin) {
                  setState(() {
                    myOTP = pin;
                  });
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            !loading && myOTP != null
                ? ElevatedButton(
                    onPressed: () async {
                      if (myOTP!.isNotEmpty) {
                        bool done = await sendOTP();
                        if (done) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPassword(
                                        jwttoken: myOTP!,
                                        email: widget.userName,
                                      )));
                        } else {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error '),
                                content: const Text(
                                    'Something went wrong, please try again'),
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
                        }
                      }
                    },
                    child: const Text(
                      "Send",
                    ), // Button text
                  )
                : CircularProgressIndicator(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      )),
    );
  }

  Future<bool> sendOTP({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      
      // Simple validation - just check if OTP is not empty and has correct length
      if (myOTP != null && myOTP!.length == 4) {
        setState(() {
          loading = false;
        });
        return true;
      } else {
        setState(() {
          loading = false;
        });
        return false;
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      return false;
    }
  }
}
