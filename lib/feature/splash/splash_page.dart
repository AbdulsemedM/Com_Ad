import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/app/utils/app_colors.dart';
import 'package:commercepal_admin_flutter/app/utils/assets.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data.dart';
import 'package:commercepal_admin_flutter/core/database/prefs_data_impl.dart';
import 'package:commercepal_admin_flutter/feature/login/presentation/login_page.dart';
import 'package:commercepal_admin_flutter/app/utils/roles/roles_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/model/generic_cubit_state.dart';
import 'splash_cubit.dart';

class SplashPage extends StatelessWidget {
  static const routeName = "/splash_page";

  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SplashCubit>()..redirect(),
      child: BlocConsumer<SplashCubit, GenericCubitState>(
        listener: (context, state) async {
          if (state is GenericCubitStateSuccess) {
            final prefsData = getIt<PrefsData>();
            bool isLoggedIn =
                await prefsData.contains(PrefsKeys.userToken.name);
            if (isLoggedIn) {
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RoleChecker(),
                ),
              );
            } else {
              Navigator.popAndPushNamed(context, LoginPage.routeName);
            }
          }

          if (state is GenericCubitStateError) {
            Navigator.popAndPushNamed(context, LoginPage.routeName);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Assets.managementAppLogo),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: AppColors.colorPrimary,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
