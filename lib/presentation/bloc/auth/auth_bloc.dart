// import 'dart:async';
//
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../core/constants/text_constants.dart';
// import '../../../data/data_sources/remote/api/api_service.dart';
// import '../../../data/model/user_model.dart';
// import '../../../domain/use_case/auth/login_use_case.dart';
// import '../../../domain/use_case/auth/register_use_case.dart';
//
// part 'auth_event.dart';
// part 'auth_state.dart';
//
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final LoginUseCase loginUseCase;
//   final RegisterUseCase registerUseCase;
//   AuthBloc({
//     required this.loginUseCase,
//     required this.registerUseCase
// }) : super(AuthInitialState()) {
//     on<LoginButtonEvent>(_onLoginButtonEvent);
//     on<RegisterButtonEvent>(_onRegisterButtonEvent);
//   }
//
//   Future<void> _onLoginButtonEvent(
//     LoginButtonEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     String? errorMessage;
//     if (event.username.isEmpty) {
//       errorMessage = TextConstants.userNameEmpty;
//     } else if (event.password.isEmpty) {
//       errorMessage = TextConstants.passwordEmpty;
//     }
//     if (errorMessage != null) {
//       emit(AuthFailureState(errorMessage));
//       emit(AuthInitialState());
//       return;
//     }
//
//     emit(AuthLoadingState());
//
//     try {
//       final UserModel user = await ApiService()
//           .login(event.username, event.password)
//           .timeout(const Duration(seconds: 5));
//       emit(AuthSuccessState(user.token));
//     } catch (error) {
//       if (error is TimeoutException) {
//         emit(const AuthFailureState(TextConstants.internetError));
//       } else {
//         emit(AuthFailureState(error.toString()));
//       }
//       emit(AuthInitialState());
//     }
//   }
//
//   Future<void> _onRegisterButtonEvent(
//     RegisterButtonEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     String? errorMessage;
//
//     if (event.fullName.isEmpty) {
//       errorMessage = TextConstants.fullNameEmpty;
//     } else if (event.username.isEmpty) {
//       errorMessage = TextConstants.userNameEmpty;
//     } else if (event.password.isEmpty) {
//       errorMessage = TextConstants.passwordEmpty;
//     } else if (event.confirmPassword.isEmpty) {
//       errorMessage = TextConstants.confirmPasswordEmpty;
//     } else if (event.password != event.confirmPassword) {
//       errorMessage = TextConstants.passwordError;
//     }
//
//     if (errorMessage != null) {
//       emit(AuthFailureState(errorMessage));
//       emit(AuthInitialState());
//       return;
//     }
//
//     emit(AuthLoadingState());
//
//     try {
//       final UserModel user = await ApiService()
//           .register(event.fullName, event.username, event.password)
//           .timeout(const Duration(seconds: 5));
//       emit(AuthSuccessState(user.token));
//     } catch (error) {
//       if (error is TimeoutException) {
//         emit(const AuthFailureState(TextConstants.internetError));
//       } else {
//         emit(AuthFailureState(error.toString()));
//       }
//       emit(AuthInitialState());
//     }
//   }
// }
//


import 'dart:async';

import 'package:app_chat/domain/use_case/auth/register_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/text_constants.dart';
import '../../../core/di/di.dart';
import '../../../domain/use_case/auth/login_use_case.dart';

part 'auth_event.dart';part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<LoginButtonEvent>(_onLoginButtonEvent);
    on<RegisterButtonEvent>(_onRegisterButtonEvent);
  }

  Future<void> _onLoginButtonEvent(
    LoginButtonEvent event,
    Emitter<AuthState> emit,
  ) async {
    String? errorMessage;
    if (event.username.isEmpty) {
      errorMessage = TextConstants.userNameEmpty;
    } else if (event.password.isEmpty) {
      errorMessage = TextConstants.passwordEmpty;
    }
    if (errorMessage != null) {
      emit(AuthFailureState(errorMessage));
      emit(AuthInitialState());
      return;
    }

    emit(AuthLoadingState());

    try {
      final loginUseCase = getIt<LoginUseCase>();
      final result = await loginUseCase
          .call(event.username, event.password)
          .timeout(const Duration(seconds: 5));
      result.fold(
        (failure) {
          //final message = failure.message;
        },
        (user) {
          // Lấy một trường cụ thể từ UserEntity
          final token = user.token;
          emit(AuthSuccessState(token));
        },
      );
    } catch (error) {
      if (error is TimeoutException) {
        emit(const AuthFailureState(TextConstants.internetError));
      } else {
        emit(AuthFailureState(error.toString()));
      }
      emit(AuthInitialState());
    }
  }

  Future<void> _onRegisterButtonEvent(
    RegisterButtonEvent event,
    Emitter<AuthState> emit,
  ) async {
    String? errorMessage;

    if (event.fullName.isEmpty) {
      errorMessage = TextConstants.fullNameEmpty;
    } else if (event.username.isEmpty) {
      errorMessage = TextConstants.userNameEmpty;
    } else if (event.password.isEmpty) {
      errorMessage = TextConstants.passwordEmpty;
    } else if (event.confirmPassword.isEmpty) {
      errorMessage = TextConstants.confirmPasswordEmpty;
    } else if (event.password != event.confirmPassword) {
      errorMessage = TextConstants.passwordError;
    }

    if (errorMessage != null) {
      emit(AuthFailureState(errorMessage));
      emit(AuthInitialState());
      return;
    }

    emit(AuthLoadingState());

    try {
      final registerUseCase = getIt<RegisterUseCase>();
      final result = await registerUseCase
          .call(event.fullName, event.username, event.password)
          .timeout(const Duration(seconds: 5));

      result.fold(
        (failure) {
          //final message = failure.message;
        },
        (user) {
          // Lấy một trường cụ thể từ UserEntity
          final token = user.token;
          emit(AuthSuccessState(token));
        },
      );
    } catch (error) {
      if (error is TimeoutException) {
        emit(const AuthFailureState(TextConstants.internetError));
      } else {
        emit(AuthFailureState(error.toString()));
      }
      emit(AuthInitialState());
    }
  }
}
