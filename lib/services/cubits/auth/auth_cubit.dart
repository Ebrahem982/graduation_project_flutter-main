import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/user_model.dart';
import 'package:graduation_project/services/apis/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(NotAuthenticated());
  UserModel? userData;

  Future<bool> login({required String email, required String password}) async {
    emit(AuthLoading());
    // Perform login
    final Map<String, dynamic>? user =
        await AuthService().login(email, password);
    if (user == null) {
      emit(AuthError('Invalid email or password'));
      return false;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAuth', true);
    prefs.setString('user', jsonEncode(user));
    UserModel userModel = UserModel.fromJson(user);
    userData = userModel;
    emit(Authenticated(user: userModel));
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String location,
    required String phone,
  }) async {
    emit(AuthLoading());
    // Perform login
    final bool success = await AuthService().register(
        name: name,
        email: email,
        location: location,
        password: password,
        phone: phone);
    if (!success) {
      emit(AuthError('Failed to register user'));
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    emit(AuthLoading());
    // Perform logout
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAuth', false);
    prefs.remove('user');
    userData = null;
    emit(NotAuthenticated());
  }

  void checkAuth() async {
    emit(AuthLoading());
    // Check if the user is authenticated
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isAuthenticated = prefs.getBool('isAuth') ?? false;
    if (!isAuthenticated) {
      emit(NotAuthenticated());
      return;
    }
    final String? user = prefs.getString('user');
    if (user != null) {
      Map<String, dynamic> userMap = jsonDecode(user);
      userData = UserModel.fromJson(userMap);
      emit(Authenticated(user: UserModel.fromJson(userMap)));
    }
  }
}
