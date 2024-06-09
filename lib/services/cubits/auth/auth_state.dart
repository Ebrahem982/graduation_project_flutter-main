import 'package:graduation_project/models/user_model.dart';

class AuthState {}

class NotAuthenticated extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  Authenticated({required this.user});
}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
