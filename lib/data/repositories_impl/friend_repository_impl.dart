import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/data/data_mapper/friend_mapper.dart';
import 'package:app_chat/data/data_sources/local/data.dart';
import 'package:app_chat/data/data_sources/local/db_helper.dart';
import 'package:app_chat/data/data_sources/remote/api/api_service.dart';
import 'package:app_chat/domain/entities/friend_entity.dart';
import 'package:app_chat/domain/repositories/friend_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: FriendRepository)
class FriendRepositoryImpl implements FriendRepository {
  final apiService = ApiService();
  final dbHelper = DatabaseHelper();
  final friendMapper = FriendMapper();



  @override
  Future<Either<Failure, List<FriendEntity>>> fetchFriends(String token) async {
    try {
      friendList = await apiService.getListFriends(token);
      List<FriendEntity> friendListEntity = [];
      if (friendList.isNotEmpty) {
        friendList.sort((a, b) =>
            a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
        friendListEntity = friendList
            .map((friendModel) => friendMapper.mapToEntity(friendModel))
            .toList();
      } else {
        friendList = await dbHelper.updateAllFriends(friendList);
      }

      return Right(friendListEntity);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }



  @override
  Future<void>updateNickName(String friendID, String nickname) async {
    print(nickname);
    await dbHelper.insertNickname(friendID, nickname);
  }
}
