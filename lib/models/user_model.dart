class UserModel {
  String? status;
  String? token;
  Data? data;

  UserModel({this.status, this.token, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  // Added toJson method
  Map<String, dynamic> toJson() => {
        'status': status,
        'token': token,
        'data': data?.toJson(), // Handle null data gracefully
      };
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['location'] = location;
    data['profile_picture'] = profilePicture;
    data['phone'] = phone;
    data['role'] = role;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
