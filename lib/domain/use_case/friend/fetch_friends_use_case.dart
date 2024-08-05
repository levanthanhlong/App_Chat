import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/entities/friend_entity.dart';
import 'package:app_chat/domain/repositories/friend_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchFriendsUseCase {
  final FriendRepository repository;

  FetchFriendsUseCase({required this.repository});

  Future<Either<Failure, List<FriendEntity>>> call(String token) async {
    return await repository.fetchFriends(token);
  }
}
