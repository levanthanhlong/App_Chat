import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserInFo(String token);

  Future<Either<Failure, Image>> loadAvatar(String avatarUrl);

  Future<Either<Failure, bool>> updateUserInfo(
      String token, String newName, String newAvatarPath);

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, String?>> checkUser();
}
