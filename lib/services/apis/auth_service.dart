import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/services/apis/baseurl.dart';

class AuthService {
  final dio = Dio();

  Future<Map<String, dynamic>?>? login(String email, String password) async {
    try {
      final res = await dio.post(
        '$baseUrl/signin',
        data: {
          'email': email,
          'password': password,
        },
      );
      if (res.statusCode == 200) {
        return res.data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      log(e.message.toString());
      return null;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String location,
    required String password,
    required String phone,
  }) async {
    try {
      final res = await dio.post(
        '$baseUrl/signup',
        data: {
          'name': name,
          'email': email,
          'location': location,
          'phone': phone,
          'password': password,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (res.statusCode == 201) {
        if (res.data['status'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }

  Future<bool> updateProfile({
    required int id,
    required String name,
    required String email,
    required String phone,
    required String token,
    required String? profileImage,
  }) async {
    try {
      final res = await dio.put(
        '$baseUrl/users/$id',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'profile_picture': profileImage,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }

  Future<bool> changePassword({
    required int id,
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    try {
      final res = await dio.put(
        '$baseUrl/users/$id/password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }

  Future<bool> deleteAccount({
    required int id,
    required String password,
    required String token,
  }) async {
    try {
      final res = await dio.delete(
        '$baseUrl/users/$id',
        data: {
          'password': password,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      if (res.statusCode == 200) {
        if (res.data['status'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      log(e.response!.data['message'].toString());
      return false;
    }
  }
}
