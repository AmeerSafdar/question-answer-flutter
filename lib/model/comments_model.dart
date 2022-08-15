import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String commentText;
  String userId;
  String username;
  String id;
  String datepublished;
  String postUrl;
  String uploaderPhotoUrl;

  CommentModel({
    this.commentText,
    this.userId,
    this.username,
    this.id,
    this.datepublished,
    this.postUrl,
    this.uploaderPhotoUrl,
  });
  // Map<String, dynamic> toJson() => {
  //       "username": username,
  //       "uid": uid,
  //       "commentText": commentText,
  //       "id": id,
  //       "date": datepublished,
  //     };

  CommentModel.fromSnap(DocumentSnapshot snapshot) {
    id = snapshot.id;
    username = snapshot['username'] ?? '';
    userId = snapshot['userId'] ?? '';
    commentText = snapshot['commentText'] ?? '';
    uploaderPhotoUrl = snapshot['uploaderPhotoUrl'] ?? '';
    postUrl = snapshot['postUrl'] ?? '';
    datepublished = snapshot['datepublished'] ?? '';
  }
}
