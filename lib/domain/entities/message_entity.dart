import '../../core/data_type/file_data.dart';
import '../../core/data_type/img_data.dart';

class MessageEntity {
  final String? id;
  final String content;
  final List<FileData> files;
  final List<ImageData> images;
  int isSend;
  final DateTime createdAt;
  final int messageType;

  MessageEntity({
    this.id,
    required this.content,
    required this.files,
    required this.images,
    required this.isSend,
    required this.createdAt,
    required this.messageType,
  });
}
