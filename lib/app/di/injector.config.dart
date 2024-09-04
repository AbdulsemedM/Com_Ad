// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/database/data_helper/data_helper.dart' as _i456;
import '../../core/database/data_helper/data_helper_impl.dart' as _i214;
import '../../core/database/prefs_data.dart' as _i565;
import '../../core/database/prefs_data_impl.dart' as _i644;
import '../../core/network/api_provider.dart' as _i612;
import '../../core/network/dio_client.dart' as _i571;
import '../../core/orders/data/orders_repo_imnpl.dart' as _i527;
import '../../core/orders/domain/orders_repo.dart' as _i1009;
import '../../core/orders/presentation/orders_cubit.dart' as _i180;
import '../../core/phonenumber_utils/phone_number_utils.dart' as _i261;
import '../../core/phonenumber_utils/phone_number_utils_impl.dart' as _i198;
import '../../core/products/data/parent_category_impl.dart' as _i1014;
import '../../core/products/domain/product_repo.dart' as _i953;
import '../../core/products/presentation/bloc/products_cubit.dart' as _i587;
import '../../core/session/data/session_repo_impl.dart' as _i405;
import '../../core/session/domain/session_repo.dart' as _i587;
import '../../core/session/presentation/session_cubit.dart' as _i116;
import '../../core/transactions/data/transaction_repo_impl.dart' as _i732;
import '../../core/transactions/domain/transaction_repo.dart' as _i258;
import '../../core/transactions/presentation/bloc/transaction_cubit.dart'
    as _i937;
import '../../feature/login/data/login_repo_impl.dart' as _i989;
import '../../feature/login/domain/login_repo.dart' as _i1049;
import '../../feature/login/presentation/cubit/login_cubit.dart' as _i453;
import '../../feature/merchant/dashboard_orders/bloc/dashboard_orders_cubit.dart'
    as _i983;
import '../../feature/merchant/dashboard_transactions/cubit/dashboard_transactions_cubit.dart'
    as _i390;
import '../../feature/splash/splash_cubit.dart' as _i228;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final dioClient = _$DioClient();
  gh.lazySingleton<_i361.Dio>(() => dioClient.dio);
  gh.factory<_i565.PrefsData>(() => _i644.PrefsDataImpl());
  gh.factory<_i261.PhoneNumberUtils>(() => _i198.PhoneNumberUtilsImpl());
  gh.singleton<_i612.ApiProvider>(() => _i612.ApiProvider(gh<_i361.Dio>()));
  gh.factory<_i1009.OrdersRepo>(
      () => _i527.OrdersRepoImpl(gh<_i612.ApiProvider>()));
  gh.factory<_i258.TransactionRepo>(
      () => _i732.TransactionRepoImpl(gh<_i612.ApiProvider>()));
  gh.factory<_i180.OrdersCubit>(
      () => _i180.OrdersCubit(gh<_i1009.OrdersRepo>()));
  gh.factory<_i456.DataHelper>(
      () => _i214.DataHelperImpl(gh<_i565.PrefsData>()));
  gh.factory<_i937.TransactionCubit>(() => _i937.TransactionCubit(
        gh<_i258.TransactionRepo>(),
        gh<_i261.PhoneNumberUtils>(),
      ));
  gh.factory<_i983.DashboardOrdersCubit>(
      () => _i983.DashboardOrdersCubit(gh<_i1009.OrdersRepo>()));
  gh.factory<_i390.DashboardTransactionsCubit>(
      () => _i390.DashboardTransactionsCubit(gh<_i258.TransactionRepo>()));
  gh.factory<_i953.ProductRepo>(() => _i1014.ParentCategoryImpl(
        gh<_i612.ApiProvider>(),
        gh<_i456.DataHelper>(),
      ));
  gh.factory<_i587.SessionRepo>(() => _i405.SessionRepoImpl(
        gh<_i456.DataHelper>(),
        gh<_i565.PrefsData>(),
      ));
  gh.factory<_i1049.LoginRepo>(() => _i989.LoginRepoImpl(
        gh<_i612.ApiProvider>(),
        gh<_i565.PrefsData>(),
        gh<_i456.DataHelper>(),
      ));
  gh.factory<_i116.SessionCubit>(
      () => _i116.SessionCubit(gh<_i587.SessionRepo>()));
  gh.factory<_i228.SplashCubit>(
      () => _i228.SplashCubit(gh<_i587.SessionRepo>()));
  gh.factory<_i587.ProductsCubit>(
      () => _i587.ProductsCubit(gh<_i953.ProductRepo>()));
  gh.factory<_i453.LoginCubit>(() => _i453.LoginCubit(gh<_i1049.LoginRepo>()));
  return getIt;
}

class _$DioClient extends _i571.DioClient {}
