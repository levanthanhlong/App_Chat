import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/data_type/file_data.dart';
import '../../../model/friend_model.dart';
import '../../../model/message_model.dart';
import '../../../model/user_model.dart';
import '../../local/db_helper.dart';
import 'notification_service.dart';

@LazySingleton()
class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8888/api/';
  static const String get = 'GET';
  static const String post = 'POST';

  // đăng kí tài khoản
  Future<UserModel> register(String fullName, String username, String password) async {
    const String registerUrl = '$baseUrl${ApiConstants.apiRegister}';
    final Map<String, String> data = {
      ApiConstants.fullName: fullName,
      ApiConstants.username: username,
      ApiConstants.password: password,
    };
    // gửi lên server
    final http.Response response = await http.post(
      Uri.parse(registerUrl),
      headers: <String, String>{
        ApiConstants.type: ApiConstants.contentType,
      },
      body: jsonEncode(data),
    );
    // xử lý thông tin trả về
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (responseBody[ApiConstants.status] == 1) {
      UserModel user = UserModel.fromMap(responseBody[ApiConstants.data]);
      await DatabaseHelper().insertOrUpdateUser(user);
      return user;
    } else {
      throw responseBody[ApiConstants.message];
    }
  }

  // đăng nhập
  Future<UserModel> login(String username, String password) async {
    const String loginUrl = '$baseUrl${ApiConstants.apiLogin}';
    final Map<String, String> data = {
      ApiConstants.username: username,
      ApiConstants.password: password,
    };
    // gửi lên server
    final http.Response response = await http.post(
      Uri.parse(loginUrl),
      headers: <String, String>{
        ApiConstants.type: ApiConstants.contentType,
      },
      body: jsonEncode(data),
    );
    // xử lý thông tin trả về
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (responseBody[ApiConstants.status] == 1) {
      UserModel user = UserModel.fromMap(responseBody[ApiConstants.data]);
      await DatabaseHelper().insertOrUpdateUser(user);
      return user;
    } else {
      throw responseBody[ApiConstants.message];
    }
  }

  // cập nhật thông tin người dùng
  Future<bool> updateUserInfo(
      String token, String? fullName, String? avatarFilePath) async {
    const String updateUrl = '$baseUrl${ApiConstants.updateUser}';

    // gửi thông tin lên server
    var request = http.MultipartRequest(post, Uri.parse(updateUrl))
      ..headers[ApiConstants.auth] = '${ApiConstants.bearer} $token';

    if (fullName != null) {
      request.fields[ApiConstants.fullName] = fullName;
    }

    if (avatarFilePath != null && avatarFilePath.startsWith('/')) {
      request.files.add(await http.MultipartFile.fromPath(
          ApiConstants.apiAvatar, avatarFilePath));
    }
    //  xử lý thông tin trả về
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (responseBody[ApiConstants.status] == 1) {
      return true;
    } else {
      throw responseBody[ApiConstants.message];
    }
  }

  // lấy thông tin người dùng
  Future<UserModel> getUserInfo(String token) async {
    try {
      const String userInfoUrl = '$baseUrl${ApiConstants.infoUser}';
      // gửi lên server
      final http.Response response = await http.get(
        Uri.parse(userInfoUrl),
        headers: <String, String>{
          ApiConstants.auth: '${ApiConstants.bearer} $token',
        },
      ).timeout(const Duration(seconds: 6));
      // thông tin trả về
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody[ApiConstants.status] == 1) {
        return UserModel.fromMap(
            {...responseBody[ApiConstants.data], ApiConstants.token: token});
      } else {
        throw responseBody[ApiConstants.message];
      }
    } catch (e) {
      // lấy thông tin trong db
      UserModel? user = await DatabaseHelper().getUser();
      if (user != null) {
        return user;
      } else {
        rethrow;
      }
    }
  }

  // lấy danh sách bạn bè
  Future<List<FriendModel>> getListFriends(String token) async {
    const String listFriendsUrl = '$baseUrl${ApiConstants.apiListFriend}';
    try {
      // gửi server
      final http.Response response = await http.get(
        Uri.parse(listFriendsUrl),
        headers: <String, String>{
          ApiConstants.auth: '${ApiConstants.bearer} $token',
        },
      ).timeout(const Duration(seconds: 2));
      // thông tin trả về
      final List<dynamic> data = jsonDecode(response.body)[ApiConstants.data];
      List<FriendModel> friendList = data
          .map((friendJson) => FriendModel.fromJson(friendJson))
          .where((friend) => friend.fullName.isNotEmpty)
          .toList();
      return friendList;
    } on TimeoutException {
      return [];
    } catch (e) {
      throw Exception(e);
    }
  }

  // gửi tin nhắn
  Future<MessageModel?> sendMessage(
      String token, String friendID, MessageModel message) async {
    const String sendMessageUrl = '$baseUrl${ApiConstants.apiSendMessage}';
    var headers = {
      ApiConstants.auth: '${ApiConstants.bearer} $token',
    };
    // tạo thông tin gửi đi
    var request = http.MultipartRequest(post, Uri.parse(sendMessageUrl));
    request.headers.addAll(headers);

    request.fields.addAll({
      ApiConstants.friendId: friendID,
      ApiConstants.content: message.content,
    });

    for (var file in message.files) {
      request.files.add(await http.MultipartFile.fromPath(
          ApiConstants.apiFiles, file.urlFile));
    }
    for (var image in message.images) {
      request.files.add(await http.MultipartFile.fromPath(
          ApiConstants.apiFiles, image.urlImage));
    }

    try {
      // gửi lên server
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        // thông tin trả về
        if (jsonResponse[ApiConstants.status] == 1) {
          return MessageModel.fromJson(jsonResponse[ApiConstants.data]);
        } else {
          throw Exception(jsonResponse[ApiConstants.message]);
        }
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      return null;
    }
  }

  // lấy tin nhắn
  Future<List<MessageModel>> getMessage(String token, String friendID,
      {DateTime? lastTime}) async {
    const String messageUrl = '$baseUrl${ApiConstants.apiGetMessage}';
    Uri uri = Uri.parse(messageUrl).replace(queryParameters: {
      ApiConstants.friendId: friendID,
      if (lastTime != null) ApiConstants.lastTime: lastTime.toIso8601String(),
    });
    Map<String, String> headers = {
      ApiConstants.auth: '${ApiConstants.bearer} $token',
    };
    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));
      final jsonData = json.decode(response.body);
      if (jsonData[ApiConstants.status] == 1 &&
          jsonData.containsKey(ApiConstants.data)) {
        final List<dynamic> messageDataList = jsonData[ApiConstants.data];
        return messageDataList
            .map((messageData) => MessageModel.fromJson(messageData))
            .toList();
      } else {
        throw Exception(jsonData[ApiConstants.message]);
      }
    } on TimeoutException {
      List<MessageModel> messageList = [];
      return messageList;
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<MessageModel>> getMessageStream(String token, String friendID,
      {DateTime? lastTime}) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      List<MessageModel> newMessages =
          await getMessage(token, friendID, lastTime: lastTime);
      if (newMessages.isNotEmpty) {
        lastTime = newMessages.last.createdAt;
        yield newMessages;
      }
    }
  }

  //lấy avatar
  Future<Image> loadAvatar(String avatarUrl) async {
    if (avatarUrl.isNotEmpty) {
      final DatabaseHelper dbHelper = DatabaseHelper();
      try {
        // lấy ảnh bằng đường dẫn
        final String getAvatarUrl =
            '$baseUrl${ApiConstants.apiImages}$avatarUrl';
        final response = await http
            .get(Uri.parse(getAvatarUrl))
            .timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          final Uint8List imageBytes = response.bodyBytes;
          await dbHelper.insertImage(avatarUrl, imageBytes);
          return Image.memory(imageBytes);
        }
      } catch (_) {
        // khi không lấy dc ảnh trên server thì lấy trong db
        final Uint8List imageBytesFromDb = await dbHelper.getImage(avatarUrl);
        if (imageBytesFromDb.isNotEmpty) {
          return Image.memory(imageBytesFromDb);
        } else {
          return Image.asset(AssetConstants.iconPerson);
        }
      }
    }
    return Image.asset(AssetConstants.iconPerson);
  }

  // lấy ảnh
  Future<Image> loadImage(String imageUrl) async {
    final DatabaseHelper dbHelper = DatabaseHelper();
    try {
      final String getImageUrl = '$baseUrl$imageUrl';
      final response = await http
          .get(Uri.parse(getImageUrl))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final Uint8List imageBytes = response.bodyBytes;
        await dbHelper.insertImage(imageUrl, imageBytes);
        return Image.memory(imageBytes);
      }
    } on TimeoutException {
      final Uint8List imageBytesFromDb = await dbHelper.getImage(imageUrl);
      return Image.memory(imageBytesFromDb);
    } catch (e) {
      return Image.asset(AssetConstants.iconError);
    }
    return Image.asset(AssetConstants.iconError);
  }

  // tải file
  Future<void> downloadFile(FileData fileData) async {
    try {
      http.StreamedResponse response =
          await http.Request(get, Uri.parse('$baseUrl${fileData.urlFile}'))
              .send();
      if (response.statusCode == 200) {
        final fileName =
            getUniqueFilePath(ApiConstants.downloadPath, fileData.fileName);
        final filePath = '${ApiConstants.downloadPath}$fileName';
        final file = File(filePath);

        // Kiểm tra và tạo thư mục Download nếu chưa tồn tại
        final downloadDir = Directory(ApiConstants.downloadPath);
        if (!(await downloadDir.exists())) {
          await downloadDir.create(recursive: true);
        }

        // lưu file
        final contentLength = response.contentLength ?? 0;
        int bytesReceived = 0;
        final sink = file.openWrite();

        response.stream.listen(
          (chunk) {
            bytesReceived += chunk.length;
            sink.add(chunk);
            NotificationService().showProgressNotification(
                bytesReceived, contentLength, fileName);
          },
          onDone: () async {
            await sink.close();
            NotificationService().showCompletionNotification(fileName);
          },
          onError: (e) {
            throw Exception();
          },
          cancelOnError: true,
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      NotificationService().showErrorNotification(fileData.fileName);
      throw Exception(e);
    }
  }

  String getUniqueFilePath(String basePath, String fileName) {
    var file = File('$basePath$fileName');
    if (!file.existsSync()) return fileName;

    int counter = 1;
    String newFileName;
    final fileNameWithoutExtension = fileName.split('.').first;
    final fileExtension = fileName.split('.').last;

    do {
      newFileName = '$fileNameWithoutExtension ($counter).$fileExtension';
      file = File('$basePath$newFileName');
      counter++;
    } while (file.existsSync());

    return newFileName;
  }

  // định dạng thời gian
  String formatMessageTime(DateTime timestamp) {
    final DateFormat formatter = DateFormat(ApiConstants.dateFormat);
    final String formattedTime = formatter.format(timestamp);

    final DateTime now = DateTime.now();
    final DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    if (timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day) {
      return formattedTime;
    } else if (timestamp.year == yesterday.year &&
        timestamp.month == yesterday.month &&
        timestamp.day == yesterday.day) {
      return '$formattedTime ${ApiConstants.yesterday}';
    } else {
      return '${formatter.format(timestamp)} ${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
