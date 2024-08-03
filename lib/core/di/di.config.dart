// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_chat/data/data_mapper/user_mapper.dart' as _i833;
import 'package:app_chat/data/data_sources/remote/api/api_service.dart'
    as _i1023;
import 'package:app_chat/data/repositories_impl/auth_repository_impl.dart'
    as _i111;
import 'package:app_chat/data/repositories_impl/user_repository_impl.dart'
    as _i584;
import 'package:app_chat/domain/repositories/auth_repository.dart' as _i410;
import 'package:app_chat/domain/repositories/user_repository.dart' as _i210;
import 'package:app_chat/domain/use_case/auth/login_use_case.dart' as _i483;
import 'package:app_chat/domain/use_case/auth/register_use_case.dart' as _i501;
import 'package:app_chat/domain/use_case/user/check_user_use_case.dart'
    as _i251;
import 'package:app_chat/domain/use_case/user/get_user_info_use_case.dart'
    as _i422;
import 'package:app_chat/domain/use_case/user/load_avatar_use_case.dart'
    as _i131;
import 'package:app_chat/domain/use_case/user/logout_use_case.dart' as _i453;
import 'package:app_chat/domain/use_case/user/update_user_info_use_case.dart'
    as _i473;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i833.UserMapper>(() => _i833.UserMapper());
    gh.lazySingleton<_i1023.ApiService>(() => _i1023.ApiService());
    gh.lazySingleton<_i210.UserRepository>(() => _i584.UserRepositoryImpl());
    gh.factory<_i131.LoadAvatarUseCase>(
        () => _i131.LoadAvatarUseCase(repository: gh<_i210.UserRepository>()));
    gh.factory<_i422.GetUserInfoUseCase>(
        () => _i422.GetUserInfoUseCase(repository: gh<_i210.UserRepository>()));
    gh.factory<_i453.LogoutUseCase>(
        () => _i453.LogoutUseCase(repository: gh<_i210.UserRepository>()));
    gh.factory<_i251.CheckUserUseCase>(
        () => _i251.CheckUserUseCase(repository: gh<_i210.UserRepository>()));
    gh.factory<_i473.UpdateUserInfoUseCase>(() =>
        _i473.UpdateUserInfoUseCase(repository: gh<_i210.UserRepository>()));
    gh.lazySingleton<_i410.AuthRepository>(() => _i111.AuthRepositoryImpl(
          apiService: gh<_i1023.ApiService>(),
          userMapper: gh<_i833.UserMapper>(),
        ));
    gh.factory<_i501.RegisterUseCase>(
        () => _i501.RegisterUseCase(repository: gh<_i410.AuthRepository>()));
    gh.factory<_i483.LoginUseCase>(
        () => _i483.LoginUseCase(gh<_i410.AuthRepository>()));
    return this;
  }
}
