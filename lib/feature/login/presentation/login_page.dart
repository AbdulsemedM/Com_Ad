import 'package:flutter/material.dart';

import 'widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  static const routeName = "/login";

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: sHeight * 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: sHeight * 0.25,
                  child: const Image(
                      image: AssetImage("assets/images/app_icon.png")),
                ),
                Text("Login to continue"),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: LoginForm(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
