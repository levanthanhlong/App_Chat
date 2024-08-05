import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/entities/friend_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FriendRepository {
  Future<Either <Failure, List<FriendEntity>>> fetchFriends(String token);
  Future<void> updateNickName(String friendId, String nickName);
}