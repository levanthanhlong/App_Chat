import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateUserInfoUseCase {
  final UserRepository repository;

  UpdateUserInfoUseCase({required this.repository});

  Future<Either<Failure, bool>> call(
      String token, String newName, newAvatarPath) {
    return repository.updateUserInfo(token, newName, newAvatarPath);
  }
}
