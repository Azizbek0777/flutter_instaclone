
class User {
  String uid = "";
  String fullname = "";
  String email = "";
  String password = "";
  String img_url = "";

  bool followed = false;
  int followers_count = 0;
  int following_count = 0;

  User({this.fullname, this.email, this.password});

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        fullname = json['fullname'],
        email = json['email'],
        password = json['password'],
        img_url = json['img_url'];

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'fullname': fullname,
    'email': email,
    'password': password,
    'img_url': img_url,
  };

  @override
  bool operator ==(other) {
    return (other is User) && other.uid == uid;
  }
}
