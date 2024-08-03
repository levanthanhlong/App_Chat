// import 'dart:async';
//
// import 'package:app_chat/data/data_sources/local/db_helper.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../data/data_sources/remote/api/api_service.dart';
// import '../../../../data/model/user_model.dart';
//
// part 'user_event.dart';
// part 'user_state.dart';
//
// class UserBloc extends Bloc<UserEvent, UserState> {
//   UserBloc() : super(UserInitialState()) {
//     on<GetUserInfo>(_onGetUserInfo);
//     on<UpdateUserInfo>(_onUpdateUserInfo);
//     on<CheckUser>(_onCheckUser);
//     on<Logout>(_onLogout);
//   }
//
//   void _onGetUserInfo(GetUserInfo event, Emitter<UserState> emit) async {
//     emit(UserLoadingState());
//     try {
//       // lấy thông tin người dùng
//       final UserModel user = await ApiService().getUserInfo(event.token);
//       final avatarImage = await ApiService().loadAvatar(user.avatar ?? '');
//       emit(UserLoadedState(
//         userName: user.userName,
//         fullName: user.fullName,
//         avatar: user.avatar ?? '',
//         avatarImage: avatarImage,
//       ));
//     } catch (e) {
//       emit(UserErrorState(e.toString()));
//     }
//   }
//
//   void _onUpdateUserInfo(UpdateUserInfo event, Emitter<UserState> emit) async {
//     try {
//       if (state is UserLoadedState) {
//         // chỉ xử lý khi đã tải xong thông tin trong home
//         final response = await ApiService()
//             .updateUserInfo(event.token, event.newName, event.newAvatarPath)
//             .timeout(const Duration(seconds: 5));
//         if (response == true) {
//           add(GetUserInfo(event.token));
//         }
//       }
//     } catch (error) {
//       if (error is TimeoutException) {
//         // time out thì giữ nguyên trạng thái của home
//         return;
//       } else {
//         emit(UserErrorState(error.toString()));
//       }
//     }
//   }
//
//   void _onLogout(Logout event, Emitter<UserState> emit) async {
//     // xóa db và đăng xuất
//     await DatabaseHelper().deleteDatabase();
//     emit(UserLoggedOutState());
//   }
//
//   Future<void> _onCheckUser(CheckUser event, Emitter<UserState> emit) async {
//     // kiểm tra thông tin người dùng trong db
//     String? token = await DatabaseHelper().hasUser();
//     if (token != null) {
//       emit(UserAuthenticatedState(token));
//     } else {
//       emit(UserUnauthenticatedState());
//     }
//   }
// }

import 'dart:async';

import 'package:app_chat/domain/use_case/user/get_user_info_use_case.dart';
import 'package:app_chat/domain/use_case/user/load_avatar_use_case.dart';
import 'package:app_chat/domain/use_case/user/logout_use_case.dart';
import 'package:app_chat/domain/use_case/user/update_user_info_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/di.dart';
import '../../../domain/use_case/user/check_user_use_case.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitialState()) {
    on<GetUserInfo>(_onGetUserInfo);
    on<UpdateUserInfo>(_onUpdateUserInfo);
    on<CheckUser>(_onCheckUser);
    on<Logout>(_onLogout);
  }

  Future<void> _onGetUserInfo(
      GetUserInfo event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final getInfoUserCase = getIt<GetUserInfoUseCase>();
      final loadAvatar = getIt<LoadAvatarUseCase>();
      final result = await getInfoUserCase
          .call(event.token)
          .timeout(const Duration(seconds: 5));
      await result.fold(
        (failure) async {
          emit(UserErrorState(failure.message ?? 'Unknown error'));
        },
        (user) async {
          final avatarImage = await loadAvatar.call(user.avatar ?? '');
          await avatarImage.fold(
            (failure) async {
              emit(UserErrorState(failure.message ?? 'Unknown error'));
            },
            (avatarImage) async {
              emit(UserLoadedState(
                userName: user.userName,
                fullName: user.fullName,
                avatar: user.avatar ?? '',
                avatarImage: avatarImage,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateUserInfo(
      UpdateUserInfo event, Emitter<UserState> emit) async {
    try {
      final updateInfoUserUseCase = getIt<UpdateUserInfoUseCase>();
      if (state is UserLoadedState) {
        // chỉ xử lý khi đã tải xong thông tin trong home
        final response = await updateInfoUserUseCase
            .call(event.token, event.newName ?? '', event.newAvatarPath ?? '')
            .timeout(const Duration(seconds: 5));
        response.fold((failure) {
          emit(UserErrorState(failure as String));
        }, (result) {
          if (result) {
            add(GetUserInfo(event.token));
          }
        });
      }
    } catch (error) {
      if (error is TimeoutException) {
        // time out thì giữ nguyên trạng thái của home
        return;
      } else {
        emit(UserErrorState(error.toString()));
      }
    }
  }

  Future<void> _onLogout(Logout event, Emitter<UserState> emit) async {
    // xóa db và đăng xuất
    final logoutUseCase = getIt<LogoutUseCase>();
    await logoutUseCase.call();
    emit(UserLoggedOutState());
  }

  Future<void> _onCheckUser(CheckUser event, Emitter<UserState> emit) async {
    final checkUserUseCase = getIt<CheckUserUseCase>();
    final result = await checkUserUseCase.call();

    result.fold(
      (failure) => {},
      (token) {
        if (token != null) {
          emit(UserAuthenticatedState(token));
        } else {
          emit(UserUnauthenticatedState());
        }
      },
    );
  }
}
