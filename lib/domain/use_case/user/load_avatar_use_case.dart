import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadAvatarUseCase {
  final UserRepository repository;

  LoadAvatarUseCase({required this.repository});

  Future<Either<Failure, Image>> call(String avatarUrl) {
    return repository.loadAvatar(avatarUrl);
  }
}
