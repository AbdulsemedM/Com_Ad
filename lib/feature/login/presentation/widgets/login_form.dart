import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
// import 'package:commercepal_admin_flutter/app/utils/routes.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/core/model/generic_cubit_state.dart';
import 'package:commercepal_admin_flutter/feature/forgot_password/forgot_password.dart';
// import 'package:commercepal_admin_flutter/feature/login/data/login_repo_impl.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/cubit/login_cubit.dart';
// import 'package:commercepal_admin_flutter/feature/merchant/dashboard/merchant_dashboard_page.dart';
import 'package:commercepal_admin_flutter/app/utils/roles/roles_checker.dart';
// import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:commercepal_admin_flutter/feature/reset_password/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_button.dart';
// import '../../../../core/widgets/app_textfield.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: BlocConsumer<LoginCubit, GenericCubitState>(
        listener: (ctx, state) {
          if (state is GenericCubitStateSuccess) {
            _email.clear();
            _password.clear();
            ctx.displaySnack(state.message);
            Navigator.pushReplacementNamed(context, RoleChecker.routeName);
          }

          if (state is GenericCubitStateError) {
            if (state.message.toString() ==
                "Instance of 'ChangePinException'") {
              print("heree hte erreo");
              _password.clear();
              _email.clear();
              Navigator.pushNamed(context, ResetPassword1.routeName,
                  arguments: {"router": "login"});
            }
            print(state.message.toString());
            ctx.displaySnack(state.message);
          }
        },
        builder: (ctx, state) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                  child: Text(
                    "Email",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Email is required';
                    }
                    return null;
                  },
                  controller: _email,
                  // onChanged: (value) {
                  //   setState(() {
                  //     _password = value;
                  //   });
                  // },
                  // title: "Password",
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    errorBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedErrorBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: "Enter your Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                  child: Text(
                    "Password",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextFormField(
                  obscureText: obscureText,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  controller: _password,
                  // onChanged: (value) {
                  //   setState(() {
                  //     _password = value;
                  //   });
                  // },
                  // title: "Password",
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    errorBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedErrorBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: "Enter your password",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassword()));
                        },
                        child: const Text(
                          "Forgot your password?",
                          style: TextStyle(color: AppColors.colorAccent),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButtonWidget(
                      text: 'Login',
                      isLoading: state is GenericCubitStateLoading,
                      onClick: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(ctx).unfocus();

                          ctx
                              .read<LoginCubit>()
                              .login(_email.text, _password.text);
                          // print();
                          // Navigator.of(navigationKey.currentContext!)
                          //     .pushAndRemoveUntil(
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 const RoleChecker()),
                          //         (route) => false);
                        }
                      }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
