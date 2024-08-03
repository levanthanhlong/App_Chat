import 'package:app_chat/data/data_mapper/base.dart';
import 'package:app_chat/data/model/friend_model.dart';
import 'package:app_chat/domain/entities/friend_entity.dart';

class FriendMapper extends BaseDataMapper<FriendEntity, FriendModel> {
  @override
  FriendEntity mapToEntity(FriendModel? data) {
    if (data == null) {
      throw 'khong co nguoi dung';
    }
    return FriendEntity(
        friendID: data.friendID,
        fullName: data.fullName,
        username: data.username,
        avatar: data.avatar,
        content: data.content,
        files: data.files,
        images: data.images,
        isSend: data.isSend,
        isOnline: data.isOnline);
  }
}
