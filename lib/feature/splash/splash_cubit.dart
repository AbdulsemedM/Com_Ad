import 'package:bloc/bloc.dart';
import 'package:commercepal_admin_flutter/core/model/generic_cubit_state.dart';
import 'package:injectable/injectable.dart';

import '../../core/session/domain/session_repo.dart';

@injectable
class SplashCubit extends Cubit<GenericCubitState> {
  final SessionRepo sessionRepo;

  SplashCubit(this.sessionRepo) : super(const GenericCubitState.init());

  void redirect() async {
    try {
      emit(const GenericCubitState.loading());

      // will throw an exception if user is not found locally
      final user = await sessionRepo.getUser();
      print(user);
      // user found so redirect to dashboard
      emit(const GenericCubitState.success("redirect"));
    } catch (e) {
      // redirect to login
      emit(const GenericCubitState.error(''));
    }
  }
}
