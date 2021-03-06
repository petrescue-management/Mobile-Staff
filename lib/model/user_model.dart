class UserModel {
  String email;
  String id;
  List<String> roles;
  String lastName;
  String firstName;
  String address;
  int gender;
  String phone;
  String imgUrl;
  String dob;

  UserModel({
    this.email,
    this.id,
    this.roles,
    this.lastName,
    this.firstName,
    this.address,
    this.gender,
    this.phone,
    this.imgUrl,
    this.dob,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<String> tmpList = [];
    for (var i = 0; i < json['roles'].length; i++) {
      var tmp = json['roles'][i];
      tmpList.add(tmp);
    }
    return UserModel(
      email: json['email'],
      id: json['id'],
      roles: tmpList,
      lastName: json['lastName'],
      firstName: json['firstName'],
      address: json['address'],
      gender: json['gender'],
      phone: json['phone'],
      imgUrl: json['imgUrl'],
      dob: json['dob'].toString(),
    );
  }
}
