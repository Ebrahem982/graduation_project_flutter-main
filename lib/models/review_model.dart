class ReviewModel {
  int? id;
  int? userId;
  int? bookId;
  num? rating;
  String? reviewText;
  String? createdAt;
  String? updatedAt;
  User? user;

  ReviewModel(
      {this.id,
      this.userId,
      this.bookId,
      this.rating,
      this.reviewText,
      this.createdAt,
      this.updatedAt,
      this.user});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookId = json['book_id'];
    rating = json['rating'];
    reviewText = json['review_text'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}

class User {
  int? id;
  String? name;
  String? email;
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
    location = json['location'];
    profilePicture = json['profile_picture'];
    role = json['role'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
