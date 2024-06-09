import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/models/notification_model.dart';
import 'package:graduation_project/services/apis/baseurl.dart';

class NotificationService {
  final dio = Dio();

  Future<List<NotificationModel>> getNotifications(
      {required String token}) async {
    final response = await dio.get('$baseUrl/notifications',
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'keep-alive': 'timeout=5, max=1000',
          'Authorization': 'Bearer $token'
        }));
    try {
      if (response.statusCode == 200) {
        final List<NotificationModel> notifications = [];
        for (var item in response.data) {
          notifications.add(NotificationModel.fromJson(item));
        }
        return notifications;
      } else {
        return [];
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return [];
    }
  }
}
