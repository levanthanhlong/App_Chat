import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/data/data_sources/remote/api/api_service.dart';
import 'package:app_chat/domain/entities/user_entity.dart';
import 'package:app_chat/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../data_mapper/user_mapper.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  final UserMapper userMapper;

  AuthRepositoryImpl({required this.apiService, required this.userMapper});

  @override
  Future<Either<Failure, UserEntity>> login(
      String username, String password) async {
    try {
      final userModel = await apiService.login(username, password);
      final UserEntity userEntity = userMapper.mapToEntity(userModel);
      return Right(userEntity);
    } on Exception {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
      String fullName, String username, String password) async {
    try {
      final userModel = await apiService.register(fullName, username, password);
      final UserEntity userEntity = userMapper.mapToEntity(userModel);
      return Right(userEntity);
    } on Exception {
      return const Left(Failure());
    }
  }
}
