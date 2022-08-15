import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userName;
  String uid;
  String photoUrl;
  String email;
  String bio;

  UserModel({
    this.userName,
    this.uid,
    this.photoUrl,
    this.email,
    this.bio,
  });
  // Map<String, dynamic> toJson() => {
  //       "username": userName,
  //       "uid": uid,
  //       "email": email,
  //       "bio": bio,
  //       "followers": followers,
  //       "following": following,
  //       "photourl": photoUrl,
  //     };

  UserModel.fromSnamshot(DocumentSnapshot data) {
    uid = data.id;
    email = data['email'] ?? "";
    photoUrl = data["photourl"] ?? "";
    bio = data["bio"] ?? "";
    userName = data["name"] ?? "";
    print('user emial is $email');
    print('user id is $uid');
  }
  //  UserModel fromSnap(DocumentSnapshot snapshot) {

  //       userName: snapshot.data()['username'] ?? '';
  //       uid: snapshot['uid'],
  //       photoUrl: snapshot['photourl'],
  //       email: snapshot['email'],
  //       bio: snapshot['bio'],
  //       followers: snapshot['followers'],
  //       following: snapshot['following']
  // }
}
