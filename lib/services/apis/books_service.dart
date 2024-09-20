import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/services/apis/baseurl.dart';

class BooksServiceApi {
  final dio = Dio();

  Future<List<BookModel>> getBooks() async {
    try {
      final response = await dio.get('$baseUrl/books',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
          }));
      if (response.statusCode == 200) {
        final List<BookModel> books = [];
        for (var item in response.data) {
          books.add(BookModel.fromJson(item));
        }
        return books;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<BookModel>> getBooksForSwap() async {
    try {
      final response = await dio.get('$baseUrl/books/swap',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
          }));
      if (response.statusCode == 200) {
        final List<BookModel> books = [];
        for (var item in response.data) {
          books.add(BookModel.fromJson(item));
        }
        return books;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<BookModel>> getUserBooks({required int userId}) async {
    try {
      final response = await dio.get('$baseUrl/books/user/$userId',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
          }));
      if (response.statusCode == 200) {
        final List<BookModel> books = [];
        for (var item in response.data) {
          books.add(BookModel.fromJson(item));
        }
        return books;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<BookModel>> getBooksByCategory({required int categoryId}) async {
    try {
      final response = await dio.get('$baseUrl/books/category/$categoryId',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
          }));
      if (response.statusCode == 200) {
        final List<BookModel> books = [];
        for (var item in response.data) {
          books.add(BookModel.fromJson(item));
        }
        return books;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> addBook({
    required String title,
    required String author,
    required String description,
    required String category,
    required String status,
    required String availability,
    required String coverImage,
    required String token,
    String? price,
  }) async {
    log('coverImage: $coverImage');
    try {
      final response = await dio.post('$baseUrl/books',
          data: {
            'title': title,
            'author': author,
            'description': description,
            'category_id': category,
            'image': coverImage,
            'status': status,
            'availability': availability,
            'price': price,
          },
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }

  Future<bool> editBook({
    required num id,
    required String title,
    required String author,
    required String description,
    required String? price,
    required String token,
  }) async {
    try {
      final response = await dio.put('$baseUrl/books/$id',
          data: {
            'title': title,
            'author': author,
            'description': description,
            'price': price,
          },
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }

  Future<bool> deleteBook({required num bookId, required String token}) async {
    try {
      final response = await dio.delete('$baseUrl/books/$bookId',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }

  Future<List<BookModel>> searchBooks({required String query}) async {
    try {
      final response = await dio.post('$baseUrl/books/search',
          data: {'search': query},
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
          }));
      if (response.statusCode == 200) {
        final List<BookModel> books = [];
        for (var item in response.data) {
          books.add(BookModel.fromJson(item));
        }
        return books;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> markAsSold({required num bookId, required String token}) async {
    try {
      final response = await dio.put('$baseUrl/books/sold/$bookId',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }

  Future<bool> makeSubscription(
      {required num bookId,
      required num price,
      required DateTime startDate,
      required DateTime endDate,
      required num userId}) async {
    try {
      final response = await dio.post(
        '$baseUrl/books/subscribe',
        options: Options(responseType: ResponseType.json, headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token'
        }),
        data: {
          'book_id': bookId,
          'price': price,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'user_id': userId
        },
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }
}
