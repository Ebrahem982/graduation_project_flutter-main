class BookModel {
  int? id;
  String? title;
  String? author;
  String? description;
  int? categoryId;
  String? status;
  String? availability;
  String? approvalStatus;
  num? price;
  String? image;
  int? userId;
  String? createdAt;
  String? updatedAt;
  num? reviewsAvgRating;
  User? user;
  Category? category;

  BookModel(
      {this.id,
      this.title,
      this.author,
      this.description,
      this.categoryId,
      this.status,
      this.availability,
      this.approvalStatus,
      this.price,
      this.image,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.reviewsAvgRating,
      this.user,
      this.category});

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    description = json['description'];
    categoryId = json['category_id'];
    status = json['status'];
    availability = json['availability'];
    approvalStatus = json['approval_status'];
    price = json['price'];
    image = json['image'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reviewsAvgRating = json['reviews_avg_rating'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
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

class Category {
  int? id;
  String? name;
  String? icon;
  String? color;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
      this.name,
      this.icon,
      this.color,
      this.createdAt,
      this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    color = json['color'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
