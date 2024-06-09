class ChatModel {
  int? id;
  int? sellerId;
  int? buyerId;
  int? bookId;
  String? createdAt;
  String? updatedAt;
  Book? book;
  Buyer? buyer;
  Buyer? seller;

  ChatModel(
      {this.id,
      this.sellerId,
      this.buyerId,
      this.bookId,
      this.createdAt,
      this.updatedAt,
      this.book,
      this.buyer,
      this.seller});

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = json['seller_id'];
    buyerId = json['buyer_id'];
    bookId = json['book_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    book = json['book'] != null ? Book.fromJson(json['book']) : null;
    buyer = json['buyer'] != null ? Buyer.fromJson(json['buyer']) : null;
    seller = json['seller'] != null ? Buyer.fromJson(json['seller']) : null;
  }
}

class Book {
  int? id;
  String? title;
  String? author;
  String? description;
  int? categoryId;
  String? status;
  String? availability;
  int? price;
  String? image;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Book(
      {this.id,
      this.title,
      this.author,
      this.description,
      this.categoryId,
      this.status,
      this.availability,
      this.price,
      this.image,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    description = json['description'];
    categoryId = json['category_id'];
    status = json['status'];
    availability = json['availability'];
    price = json['price'];
    image = json['image'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class Buyer {
  int? id;
  String? name;
  String? email;
  String? location;
  String? profilePicture;
  String? phone;
  String? role;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  Buyer(
      {this.id,
      this.name,
      this.email,
      this.location,
      this.profilePicture,
      this.phone,
      this.role,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  Buyer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    location = json['location'];
    profilePicture = json['profile_picture'];
    phone = json['phone'];
    role = json['role'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
