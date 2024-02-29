import 'package:bloc/bloc.dart';
import 'package:commercepal_admin_flutter/core/session/presentation/session_state.dart';
import 'package:injectable/injectable.dart';

import '../domain/session_repo.dart';

@injectable
class SessionCubit extends Cubit<SessionState> {
  final SessionRepo sessionRepo;

  SessionCubit(this.sessionRepo) : super(const SessionState.init());

  void fetchMerchantDetails() async {
    final user = await sessionRepo.getUser();
    emit(SessionState.merchant(user.merchantInfo!));
  }
}
