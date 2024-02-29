import 'package:freezed_annotation/freezed_annotation.dart';

part 'generic_cubit_state.freezed.dart';

@Freezed(genericArgumentFactories: true)
class GenericCubitState<T> with _$GenericCubitState<T> {
  const factory GenericCubitState.data(T data) = GenericCubitStateData;
  const factory GenericCubitState.error(String message) = GenericCubitStateError;
  const factory GenericCubitState.loading() = GenericCubitStateLoading;
  const factory GenericCubitState.init() = GenericCubitStateInit;
  const factory GenericCubitState.success(String message) = GenericCubitStateSuccess;
}
