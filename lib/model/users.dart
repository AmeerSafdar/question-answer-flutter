import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userName;
  String uid;
  final String photoUrl;
  final String email;
  final String bio;
  final List followers;
  final List following;

  User(
      {this.userName,
      this.uid,
      this.photoUrl,
      this.email,
      this.bio,
      this.followers,
      this.following});
  User user;
  Map<String, dynamic> toJson() => {
        "username": userName,
        "uid": uid,
        "email": email,
        "bio": bio,
        "followers": followers,
        "following": following,
        "photourl": photoUrl,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        userName: snapshot['username'],
        uid: snapshot['uid'],
        photoUrl: snapshot['photourl'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
