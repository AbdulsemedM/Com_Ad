// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../core/database/data_helper/data_helper.dart' as _i9;
import '../../core/database/data_helper/data_helper_impl.dart' as _i10;
import '../../core/database/prefs_data.dart' as _i6;
import '../../core/database/prefs_data_impl.dart' as _i7;
import '../../core/network/api_provider.dart' as _i8;
import '../../core/network/dio_client.dart' as _i29;
import '../../core/orders/data/orders_repo_imnpl.dart' as _i14;
import '../../core/orders/domain/orders_repo.dart' as _i13;
import '../../core/orders/presentation/orders_cubit.dart' as _i26;
import '../../core/phonenumber_utils/phone_number_utils.dart' as _i4;
import '../../core/phonenumber_utils/phone_number_utils_impl.dart' as _i5;
import '../../core/products/data/parent_category_impl.dart' as _i16;
import '../../core/products/domain/product_repo.dart' as _i15;
import '../../core/products/presentation/bloc/products_cubit.dart' as _i17;
import '../../core/session/data/session_repo_impl.dart' as _i19;
import '../../core/session/domain/session_repo.dart' as _i18;
import '../../core/session/presentation/session_cubit.dart' as _i27;
import '../../core/transactions/data/transaction_repo_impl.dart' as _i22;
import '../../core/transactions/domain/transaction_repo.dart' as _i21;
import '../../core/transactions/presentation/bloc/transaction_cubit.dart'
    as _i28;
import '../../feature/login/data/login_repo_impl.dart' as _i12;
import '../../feature/login/domain/login_repo.dart' as _i11;
import '../../feature/login/presentation/cubit/login_cubit.dart' as _i25;
import '../../feature/merchant/dashboard_orders/bloc/dashboard_orders_cubit.dart'
    as _i23;
import '../../feature/merchant/dashboard_transactions/cubit/dashboard_transactions_cubit.dart'
    as _i24;
import '../../feature/splash/splash_cubit.dart' as _i20;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final dioClient = _$DioClient();
  gh.lazySingleton<_i3.Dio>(() => dioClient.dio);
  gh.factory<_i4.PhoneNumberUtils>(() => _i5.PhoneNumberUtilsImpl());
  gh.factory<_i6.PrefsData>(() => _i7.PrefsDataImpl());
  gh.singleton<_i8.ApiProvider>(_i8.ApiProvider(gh<_i3.Dio>()));
  gh.factory<_i9.DataHelper>(() => _i10.DataHelperImpl(gh<_i6.PrefsData>()));
  gh.factory<_i11.LoginRepo>(() => _i12.LoginRepoImpl(
        gh<_i8.ApiProvider>(),
        gh<_i6.PrefsData>(),
        gh<_i9.DataHelper>(),
      ));
  gh.factory<_i13.OrdersRepo>(() => _i14.OrdersRepoImpl(gh<_i8.ApiProvider>()));
  gh.factory<_i15.ProductRepo>(() => _i16.ParentCategoryImpl(
        gh<_i8.ApiProvider>(),
        gh<_i9.DataHelper>(),
      ));
  gh.factory<_i17.ProductsCubit>(
      () => _i17.ProductsCubit(gh<_i15.ProductRepo>()));
  gh.factory<_i18.SessionRepo>(() => _i19.SessionRepoImpl(
        gh<_i9.DataHelper>(),
        gh<_i6.PrefsData>(),
      ));
  gh.factory<_i20.SplashCubit>(() => _i20.SplashCubit(gh<_i18.SessionRepo>()));
  gh.factory<_i21.TransactionRepo>(
      () => _i22.TransactionRepoImpl(gh<_i8.ApiProvider>()));
  gh.factory<_i23.DashboardOrdersCubit>(
      () => _i23.DashboardOrdersCubit(gh<_i13.OrdersRepo>()));
  gh.factory<_i24.DashboardTransactionsCubit>(
      () => _i24.DashboardTransactionsCubit(gh<_i21.TransactionRepo>()));
  gh.factory<_i25.LoginCubit>(() => _i25.LoginCubit(gh<_i11.LoginRepo>()));
  gh.factory<_i26.OrdersCubit>(() => _i26.OrdersCubit(gh<_i13.OrdersRepo>()));
  gh.factory<_i27.SessionCubit>(
      () => _i27.SessionCubit(gh<_i18.SessionRepo>()));
  gh.factory<_i28.TransactionCubit>(() => _i28.TransactionCubit(
        gh<_i21.TransactionRepo>(),
        gh<_i4.PhoneNumberUtils>(),
      ));
  return getIt;
}

class _$DioClient extends _i29.DioClient {}
