import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase {
  final UserRepository repository;

  LogoutUseCase({required this.repository});

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
