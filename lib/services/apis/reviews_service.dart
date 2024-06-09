import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/models/review_model.dart';
import 'package:graduation_project/services/apis/baseurl.dart';

class ReviewsService {
  final dio = Dio();

  Future<List<ReviewModel>> getReviews(int bookId) async {
    try {
      final response = await dio.get('$baseUrl/reviews/book/$bookId',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
          }));
      if (response.statusCode == 200) {
        final List<ReviewModel> reviews = [];
        for (var item in response.data) {
          reviews.add(ReviewModel.fromJson(item));
        }
        return reviews;
      } else {
        return [];
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return [];
    }
  }

  Future<bool> addReview({
    required num bookId,
    required num rating,
    required String review,
    required String token,
  }) async {
    try {
      final response = await dio.post('$baseUrl/reviews',
          data: {
            'book_id': bookId,
            'rating': rating,
            'review_text': review,
          },
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
            'Authorization': 'Bearer $token'
          }));
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      log(e.message.toString());
      return false;
    }
  }

  Future<bool> deleteReview({
    required num reviewId,
    required String token,
  }) async {
    try {
      final response = await dio.delete('$baseUrl/reviews/$reviewId',
          options: Options(responseType: ResponseType.json, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'keep-alive': 'timeout=5, max=1000',
            'Authorization': 'Bearer $token'
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      log(e.message.toString());
      return false;
    }
  }
}
