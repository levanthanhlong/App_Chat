import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckUserUseCase {
  final UserRepository repository;

  CheckUserUseCase({required this.repository});

  Future<Either<Failure, String?>> call() {
    return repository.checkUser();
  }
}
