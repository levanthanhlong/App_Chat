import 'package:app_chat/domain/repositories/friend_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateNicknameUseCase {
  final FriendRepository repository;

  UpdateNicknameUseCase({required this.repository});

  Future<void> call(String friendID, String nickname) async {
    await repository.updateNickName(friendID, nickname);
  }
}
