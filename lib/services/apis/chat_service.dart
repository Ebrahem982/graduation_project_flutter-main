import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/models/chat_model.dart';
import 'package:graduation_project/models/message_model.dart';
import 'package:graduation_project/services/apis/baseurl.dart';

class ChatService {
  final dio = Dio();

  Future<List<ChatModel>> getUserChats({required num userId}) async {
    try {
      Response response = await dio.get('$baseUrl/chats/user/$userId',
          options: Options(
            headers: {
              // 'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ));
      if (response.statusCode == 200) {
        List<ChatModel> chats = [];
        for (var chat in response.data) {
          chats.add(ChatModel.fromJson(chat));
        }
        return chats;
      } else {
        log(response.data.toString());
        return [];
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return [];
    }
  }

  Future<List<ChatModel>> getUserBuyingChats({required num userId}) async {
    try {
      Response response = await dio.get('$baseUrl/chats/userBuying/$userId',
          options: Options(
            headers: {
              // 'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ));
      if (response.statusCode == 200) {
        List<ChatModel> chats = [];
        for (var chat in response.data) {
          chats.add(ChatModel.fromJson(chat));
        }
        return chats;
      } else {
        log(response.data.toString());
        return [];
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return [];
    }
  }

  Future<List<ChatModel>> getUserSellingChats({required num userId}) async {
    try {
      Response response = await dio.get('$baseUrl/chats/userSelling/$userId',
          options: Options(
            headers: {
              // 'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ));
      if (response.statusCode == 200) {
        List<ChatModel> chats = [];
        for (var chat in response.data) {
          chats.add(ChatModel.fromJson(chat));
        }
        return chats;
      } else {
        log(response.data.toString());
        return [];
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return [];
    }
  }

  Future<ChatModel?> chatExists({
    required num sellerId,
    required num buyerId,
    required num bookId,
  }) async {
    try {
      Response response =
          await dio.get('$baseUrl/chats/exist/$sellerId/$buyerId/$bookId',
              options: Options(
                headers: {
                  // 'Authorization': 'Bearer $token',
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ));
      if (response.statusCode == 200) {
        return ChatModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return null;
    }
  }

  Future<String> createChat({
    required String sellerId,
    required String buyerId,
    required String bookId,
    required String token,
  }) async {
    try {
      Response response = await dio.post('$baseUrl/chats',
          data: {
            'seller_id': sellerId,
            'buyer_id': buyerId,
            'book_id': bookId,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ));
      if (response.statusCode == 201) {
        return response.data['id'];
      } else {
        return '';
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return '';
    }
  }

  Future<bool> sendMessage({
    required String message,
    required num chatId,
    required String token,
  }) async {
    try {
      Response response = await dio.post('$baseUrl/messages',
          data: {
            'content': message,
            'chat_id': chatId,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ));
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return false;
    }
  }

  Future<List<MessageModel>> getMessages({required num chatId
      // required String token,
      }) async {
    try {
      Response response = await dio.get('$baseUrl/messages/chat/$chatId',
          options: Options(
            headers: {
              // 'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ));
      if (response.statusCode == 200) {
        List<MessageModel> messages = [];
        for (var message in response.data) {
          messages.add(MessageModel.fromJson(message));
        }
        return messages;
      } else {
        log(response.data.toString());
        return [];
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return [];
    }
  }

  Future<bool> deleteChat({required num chatId, required String token}) async {
    try {
      Response response = await dio.delete('$baseUrl/chats/$chatId',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ));
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return false;
    }
  }
}
