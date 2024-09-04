

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/user.dart';

part 'session_state.freezed.dart';

@freezed
class SessionState with _$SessionState {
  const factory  SessionState.init() = SessionStateInit;
  const factory  SessionState.loading() = SessionStateLoading;
  const factory  SessionState.error(String message) = SessionStateError;
  const factory  SessionState.merchant(MerchantInfo user) = SessionStateUser;
}
