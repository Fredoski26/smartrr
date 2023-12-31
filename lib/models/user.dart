import 'dart:core';

class User {
  int id;
  String username;
  String email;
  String firstName;
  String lastName;
  int gender;
  String phoneNumber;
  String password;
  String referralCode;
  String userType;
  String streetAddress;
  String? city;
  String state;
  String zipCode;
  String? bio;
  String profilePicUrl;
  bool available;
  bool isStylist;

  User({
    this.id = 0,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.gender = 2,
    required this.phoneNumber,
    this.userType = 'SP',
    this.password = '',
    this.referralCode = '',
    this.streetAddress = '',
    this.state = '',
    this.city = '',
    this.bio = '',
    this.zipCode = '',
    this.profilePicUrl = '',
    this.available = false,
    this.isStylist = true,
  });

  // convertToJSON() {
  //   var jsonMap = Map<String, dynamic>();
  //   jsonMap['id'] = this.id.toString();
  //   jsonMap['username'] = this.username == null ? '' : this.username;
  //   jsonMap['email'] = this.email == null ? '' : this.email;
  //   jsonMap['first_name'] = this.firstName == null ? '' : this.firstName;
  //   jsonMap['last_name'] = this.lastName == null ? '' : this.lastName;
  //   jsonMap['gender'] = this.gender.toString();
  //   jsonMap['phone_number'] = this.phoneNumber;
  //   jsonMap['user_type'] = this.userType;
  //   jsonMap['password'] = this.password;
  //   jsonMap['referral_code'] = this.referralCode;
  //   jsonMap['street_address'] = this.streetAddress;
  //   jsonMap['city'] = this.city;
  //   jsonMap['state'] = this.state;
  //   jsonMap['zip_code'] = this.zipCode;
  //   jsonMap['bio'] = this.bio;
  //   jsonMap['pic_url'] = this.profilePicUrl;
  //   jsonMap['availability'] = this.available ? '1' : '0';
  //   jsonMap['barber_or_stylist'] = this.isStylist ? '1' : '0';
  //   return jsonMap;
  // }

  // User.toObject(Map<String, dynamic> jsonMap) {
  //   this.id = int.parse(jsonMap['id'].toString());
  //   this.username = jsonMap['username'];
  //   this.email = jsonMap['email'] as String;
  //   this.firstName = jsonMap['first_name'];
  //   this.lastName = jsonMap['last_name'];
  //   this.gender = int.parse(jsonMap['gender'].toString());
  //   this.phoneNumber = jsonMap['phone_number'];
  //   this.userType = jsonMap['user_type'];
  //   this.password = jsonMap['password'];
  //   this.referralCode = jsonMap['referral_code'];
  //   this.streetAddress = jsonMap['street_address'];
  //   this.city = jsonMap['city'];
  //   this.state = jsonMap['state'];
  //   this.zipCode = jsonMap['zip_code'];
  //   this.bio = jsonMap['bio'];
  //   this.profilePicUrl = jsonMap['pic_url'] == null ? '' : jsonMap['pic_url'];
  //   this.available = jsonMap['availability'] == '1';
  //   this.isStylist = jsonMap['barber_or_stylist'] == '1';
  // }
}
