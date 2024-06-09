class MessageModel {
  int? id;
  String? content;
  int? senderId;
  int? chatId;
  String? createdAt;
  String? updatedAt;
  Sender? sender;

  MessageModel(
      {this.id,
      this.content,
      this.senderId,
      this.chatId,
      this.createdAt,
      this.updatedAt,
      this.sender});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    senderId = json['sender_id'];
    chatId = json['chat_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
  }
}

class Sender {
  int? id;
  String? name;
  String? email;
  String? location;
  String? profilePicture;
  String? role;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  Sender(
      {this.id,
      this.name,
      this.email,
      this.location,
      this.profilePicture,
      this.role,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  Sender.fromJson(Map<String, dynamic> json) {
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
