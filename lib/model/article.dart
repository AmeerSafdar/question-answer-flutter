import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  String description;
  String uid;
  String username;
  String postid;
  String datepublished;
  List<int> likes;

  Article(
      {this.description,
      this.uid,
      this.username,
      this.postid,
      this.datepublished,
      this.likes});
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "postid": postid,
        "date": datepublished,
        "likes": likes,
      };

  Article.fromSnap(DocumentSnapshot snapshot) {
    username = snapshot['username'];
    uid = snapshot['uid'];
    description = snapshot['description'];
    postid = snapshot.id;
    datepublished = snapshot['datepublished'];
    //likes = snapshot['likes'];
  }
}
