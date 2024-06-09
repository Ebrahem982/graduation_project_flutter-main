import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/models/bookmark_model.dart';
import 'package:graduation_project/services/apis/baseurl.dart';

class BookmarkService {
  final dio = Dio();

  Future<List<BookmarkModel>> getUserBookmarks({required num id}) async {
    try {
      final response = await dio.get('$baseUrl/bookmarks/user/$id',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
          }));

      if (response.statusCode == 200) {
        final List<BookmarkModel> bookmarks = [];

        for (var item in response.data) {
          bookmarks.add(BookmarkModel.fromJson(item));
        }
        return bookmarks;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> addBookmark({required num bookId, required int userId}) async {
    try {
      final response = await dio.post('$baseUrl/bookmarks',
          data: {
            'book_id': bookId,
            'user_id': userId,
          },
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
          }));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> removeBookmark(
      {required num bookMarkId, required String token}) async {
    try {
      final response = await dio.delete('$baseUrl/bookmarks/$bookMarkId',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
            'Authorization': 'Bearer $token',
          }));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
