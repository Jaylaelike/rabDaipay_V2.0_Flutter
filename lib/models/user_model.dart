class UserModel {
  String name, email, gender, uid, urlAvatar;

  UserModel({
    this.name,
    this.email,
    this.gender,
    this.uid,
    this.urlAvatar,
  });
  UserModel.fromJson(Map<String, dynamic> map) {
    name = map['Name'];
    email = map['Email'];
    gender = map['Gender'];
    uid = map['Uid'];
    urlAvatar = map['UrlAvartar'];
  }
}
