import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String email;
  String userName;
  String photoUrl;
  String token;

  UserModel({
    required this.id,
    required this.token,
    required this.email,
    required this.userName,
    required this.photoUrl,
  });

  factory UserModel.fromJson(DocumentSnapshot snap) {
    return UserModel(
      id: snap.id,
      token: snap['token'],
      email: snap["email"],
      userName: snap['userName'],
      photoUrl: snap['photoUrl'],
    );
  }
}
