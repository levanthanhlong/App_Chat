import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/entities/user_entity.dart';
import 'package:app_chat/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserInfoUseCase {
  final UserRepository repository;

  GetUserInfoUseCase({required this.repository});
  Future<Either<Failure, UserEntity>> call(String token){
    return repository.getUserInFo(token);
  }
}
