import 'package:app_chat/core/error/failure.dart';
import 'package:app_chat/domain/entities/message_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<MessageEntity>>> fetchMessages(
    String token,
    String friendID,
    DateTime? lastTime,
  );

  Future<Either<Failure, MessageEntity>> sendMessage(
    String token,
    String friendID,
    MessageEntity message,
  );
}
