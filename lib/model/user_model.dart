class UserModel {
  String? uId, email, name, image;
  

  UserModel({this.uId, this.email, this.name, this.image});

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return;
    }
    uId = json["uId"];
    email = json["email"];
    name = json["name"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'email': email,
      'name': name,
      'image': image,
    };
  }
}
