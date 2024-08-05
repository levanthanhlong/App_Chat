import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/entities/message_entity.dart';
import 'package:app_chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';


@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<Either<Failure, List<MessageEntity>>> fetchMessages(String token, String friendID, DateTime? lastTime) {
    // TODO: implement fetchMessages
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(String token, String friendID, MessageEntity message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

}