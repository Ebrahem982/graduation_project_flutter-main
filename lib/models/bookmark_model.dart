import 'package:graduation_project/models/book_model.dart';

class BookmarkModel {
  int? id;
  int? userId;
  int? bookId;
  String? createdAt;
  String? updatedAt;
  BookModel? book;
  User? user;

  BookmarkModel(
      {this.id,
      this.userId,
      this.bookId,
      this.createdAt,
      this.updatedAt,
      this.book,
      this.user});

  BookmarkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookId = json['book_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    book = json['book'] != null ? BookModel.fromJson(json['book']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? location;
  String? profilePicture;
  String? role;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.location,
      this.profilePicture,
      this.role,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    location = json['location'];
    profilePicture = json['profile_picture'];
    role = json['role'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
