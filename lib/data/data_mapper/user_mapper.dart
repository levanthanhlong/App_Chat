//
//
// import '../../domain/entities/user_entity.dart';
// import '../model/user_model.dart';
//
// class UserMapper{
//
//
//   UserEntity mapToEntity(UserModel data) {
//     return UserEntity(
//       userName: data.userName,
//       fullName: data.fullName,
//       avatar: data.avatar,
//       token: data.token,
//     );
//   }
// }

import 'package:app_chat/data/data_mapper/base.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user_entity.dart';
import '../model/user_model.dart';


@LazySingleton()
class UserMapper extends BaseDataMapper<UserEntity, UserModel> {
  @override
  UserEntity mapToEntity(UserModel? data) {
    if (data == null) {
      throw 'khong co nguoi dung';
    }
    return UserEntity(
        userName: data.userName,
        fullName: data.fullName,
        token: data.token,
        avatar: data.avatar);
  }
}
