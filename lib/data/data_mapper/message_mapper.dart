import 'package:app_chat/data/data_mapper/base.dart';
import 'package:app_chat/data/model/message_model.dart';
import 'package:app_chat/domain/entities/message_entity.dart';

class MessageMapper extends BaseDataMapper<MessageEntity, MessageModel> {
  @override
  MessageEntity mapToEntity(MessageModel? data) {
    if (data == null) {
      throw 'khong co tin nhan nao ca';
    }
    return MessageEntity(
        content: data.content,
        files: data.files,
        images: data.images,
        isSend: data.isSend,
        createdAt: data.createdAt,
        messageType: data.messageType);
  }
}
