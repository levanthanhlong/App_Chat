import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(
      String username, String password);

  Future<Either<Failure, UserEntity>> register(
      String fullName, String username, String password);
}
