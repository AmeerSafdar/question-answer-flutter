import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String message;
  String senderId;
  String id;

  ChatModel({this.senderId, this.message, this.id});

  ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    message = snapshot["message"] ?? "";
    senderId = snapshot["senderId"] ?? "";
  }
}
