import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/data/data_mapper/user_mapper.dart';
import 'package:app_chat/data/data_sources/local/db_helper.dart';
import 'package:app_chat/data/data_sources/remote/api/api_service.dart';
import 'package:app_chat/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final apiService = ApiService();
  final dataHelper = DatabaseHelper();
  final userMapper = UserMapper();

  @override
  Future<Either<Failure, String?>> checkUser() async {
    try{
      final String? token = await dataHelper.hasUser();
      return Right(token);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserInFo(String token) async {
    try {
      final userModel = await apiService.getUserInfo(token);
      final UserEntity userEntity = userMapper.mapToEntity(userModel);
      return Right(userEntity);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Image>> loadAvatar(String avatarUrl) async {
    try {
      final image = await apiService.loadAvatar(avatarUrl);
      return Right(image);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try{
      await DatabaseHelper().deleteDatabase();
      return const Right(null);
    } catch (e) {
      throw('Error when logout');
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserInfo(
      String token, String newName, String newAvatarPath) async {
    try {
      final result =
          await apiService.updateUserInfo(token, newName, newAvatarPath);

      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
