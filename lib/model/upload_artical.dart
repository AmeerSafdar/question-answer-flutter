import 'package:cloud_firestore/cloud_firestore.dart';

class UploadArticle {
  String description;
  String uploaderID;
  String username;
  String postid;
  String datepublished;
  String postUrl;
  String uploaderPhotoUrl;
  String category;
  bool isLike;
  bool isclose;

  UploadArticle(
      {this.description,
      this.uploaderID,
      this.username,
      this.postid,
      this.datepublished,
      this.postUrl,
      this.uploaderPhotoUrl,
      this.category,
      this.isLike,
      this.isclose=false,

      });
  // Map<String, dynamic> toJson() => {
  //       "username": username,
  //       "uid": uid,
  //       "description": description,
  //       "postid": postid,
  //       "date": datepublished,
  //     };

  UploadArticle.fromSnap(DocumentSnapshot snapshot) {
    postid = snapshot.id;
    username = snapshot['username'] ?? '';
    uploaderID = snapshot['uploaderID'] ?? '';
    description = snapshot['description'] ?? '';
    uploaderPhotoUrl = snapshot['uploaderPhotoUrl'] ?? '';
    postUrl = snapshot['postUrl'] ?? '';
    datepublished = snapshot['datepublished'] ?? '';
    category = snapshot['category'] ?? '';
    isLike = snapshot['isLike'] ?? false;
    isclose=snapshot['isclose'] ?? false;
  }
}
