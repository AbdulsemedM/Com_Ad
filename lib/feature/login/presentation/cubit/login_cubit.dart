import 'package:bloc/bloc.dart';
import 'package:commercepal_admin_flutter/core/model/generic_cubit_state.dart';
import 'package:injectable/injectable.dart';

import '../../domain/login_repo.dart';

@injectable
class LoginCubit extends Cubit<GenericCubitState> {
  final LoginRepo loginRepo;

  LoginCubit(this.loginRepo) : super(const GenericCubitState.init());

  void login(String email, String password) async {
    // print("herewegooo");
    var regExp = RegExp(r'^0\d{9}$');
    var regExp2 = RegExp(r'^\+251\d{9}$');
    if (regExp.hasMatch(email)) {
      email = '251' + email.substring(1);
    } else if (regExp2.hasMatch(email)) {
      email = email.substring(1);
    }
    try {
      emit(const GenericCubitState.loading());
      final response = await loginRepo.login(email, password);
      emit(GenericCubitState.success(response));
    } catch (e) {
      emit(GenericCubitState.error(e.toString()));
    }
  }
}
