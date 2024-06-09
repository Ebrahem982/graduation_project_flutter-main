class NotificationModel {
  String? id;
  String? type;
  String? notifiableType;
  int? notifiableId;
  Data? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  NotificationModel(
      {this.id,
      this.type,
      this.notifiableType,
      this.notifiableId,
      this.data,
      this.readAt,
      this.createdAt,
      this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiable_type'];
    notifiableId = json['notifiable_id'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class Data {
  int? postId;
  String? image;
  String? userName;
  String? title;

  Data({this.postId, this.image, this.userName, this.title});

  Data.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    image = json['image'];
    userName = json['userName'];
    title = json['title'];
  }
}
