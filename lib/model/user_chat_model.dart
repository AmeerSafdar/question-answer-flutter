import 'package:cloud_firestore/cloud_firestore.dart';

class UserchatModel {
  String sellerName;
  String imageUrl;
  String id;

  UserchatModel({this.imageUrl, this.sellerName, this.id});

  UserchatModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    sellerName = snapshot["sellerName"] ?? "";
    imageUrl = snapshot["imageUrl"] ?? "";
    print('User id is $id');
  }
}
