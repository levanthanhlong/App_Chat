import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/entities/user_entity.dart';
import 'package:app_chat/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call(
      String fullName, String username, String password) {
    return repository.register(fullName, username, password);
  }
}
