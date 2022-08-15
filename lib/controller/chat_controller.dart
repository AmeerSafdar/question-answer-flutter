import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/model/chat_model.dart';
import 'package:instaclone/model/user_chat_model.dart';

class ChatController extends GetxController {
  @override
  void onInit() {
    alluserForchat.bindStream((getUserforChat()));
  }

  final TextEditingController chattextController = TextEditingController();

  UserController athenticationController = Get.put(UserController());

  Rx<List<UserchatModel>> alluserForchat = Rx<List<UserchatModel>>([]);
  List<UserchatModel> get getAlluserForchat => alluserForchat.value;

  Rx<List<ChatModel>> allchat = Rx<List<ChatModel>>([]);
  List<ChatModel> get getAllchat => allchat.value;
  void chatStream(String uid) {
    allchat.bindStream(getChatStream(uid));
  }

  Stream<List<ChatModel>> getChatStream(String uid) {
    return athenticationController.firebaseFirestore
        .collection('users')
        .doc(athenticationController.auth.currentUser?.uid)
        .collection('usersforchat')
        .doc(uid)
        .collection('Allchat')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ChatModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(ChatModel.fromSnapshot(element));
      }
      print(' chat model legth is ${retVal.length}');

      return retVal;
    });
  }

  Stream<List<UserchatModel>> getUserforChat() {
    return athenticationController.firebaseFirestore
        .collection('users')
        .doc(athenticationController.auth.currentUser?.uid)
        .collection('usersforchat')
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserchatModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(UserchatModel.fromSnapshot(element));
      }
      print('User chat model legth is ${retVal.length}');

      return retVal;
    });
  }

  sendMessage({
    String sellerId,
    String txtMessage,
    String postUploaderName,
    String postUploaderImage,
  }) {
    print('seller id $sellerId');
    print('text message $txtMessage');
    print('seller id is $sellerId');

    athenticationController.firebaseFirestore
        .collection('users')
        .doc(athenticationController.auth.currentUser?.uid)
        .collection('usersforchat')
        .doc(sellerId)
        .get()
        .then((value) {
      if (value.exists) {
        athenticationController.firebaseFirestore
            .collection('users')
            .doc(athenticationController.auth.currentUser?.uid)
            .collection('usersforchat')
            .doc(sellerId)
            .collection('Allchat')
            .add({
          'message': txtMessage,
          'senderId': athenticationController.auth.currentUser?.uid,
          'dateTime': DateTime.now()
        }).then((value) {
          chattextController.clear();
          athenticationController.firebaseFirestore
              .collection('users')
              .doc(sellerId)
              .collection('usersforchat')
              .doc(athenticationController.auth.currentUser?.uid)
              .collection('Allchat')
              .add({
            'message': txtMessage,
            'senderId': athenticationController.auth.currentUser?.uid,
            'dateTime': DateTime.now()
          });
        });
      } else {
        athenticationController.firebaseFirestore
            .collection('users')
            .doc(athenticationController.auth.currentUser?.uid)
            .collection('usersforchat')
            .doc(sellerId)
            .set({
          'sellerName': postUploaderName,
          'imageUrl': postUploaderImage,
        }).then((value) {
          athenticationController.firebaseFirestore
              .collection('users')
              .doc(athenticationController.auth.currentUser?.uid)
              .collection('usersforchat')
              .doc(sellerId)
              .collection('Allchat')
              .add({
            'message': txtMessage,
            'senderId': athenticationController.auth.currentUser?.uid,
            'dateTime': DateTime.now()
          }).then((value) {
            athenticationController.firebaseFirestore
                .collection('users')
                .doc(sellerId)
                .collection('usersforchat')
                .doc(athenticationController.auth.currentUser?.uid)
                .set({
              'buyerName': athenticationController.getuser.userName,
              'imageUrl': athenticationController.getuser.photoUrl,
            }).then((value) {
              athenticationController.firebaseFirestore
                  .collection('users')
                  .doc(sellerId)
                  .collection('usersforchat')
                  .doc(athenticationController.auth.currentUser?.uid)
                  .collection('Allchat')
                  .add({
                'message': txtMessage,
                'senderId': athenticationController.auth.currentUser?.uid,
                'dateTime': DateTime.now()
              });
            });
          });
        });
      }
    });
  }

  // void sendMessage(
  //     String txtMessage, String sellerId, SellerShopModel sellerShopModel) {
  //   print('seller name is ${sellerShopModel.sellerName}');
  //   print('shop Image ${sellerShopModel.image}');
  //   print('${athenticationController.auth.currentUser?.uid}');
  //   athenticationController.firebaseFirestore
  //       .collection('Buyer')
  //       .doc(athenticationController.auth.currentUser?.uid)
  //       .collection('AllSeller')
  //       .doc(sellerId)
  //       .set({
  //     'sellerName': sellerShopModel.sellerName,
  //     'imageUrl': sellerShopModel.image,
  //   }).then((value) {
  //     athenticationController.firebaseFirestore
  //         .collection('Buyer')
  //         .doc(athenticationController.auth.currentUser?.uid)
  //         .collection('AllSeller')
  //         .doc(sellerId)
  //         .collection('Allchat')
  //         .add({
  //       'message': txtMessage,
  //       'senderId': athenticationController.auth.currentUser?.uid
  //     }).then((value) {
  //       athenticationController.firebaseFirestore
  //           .collection('Seller')
  //           .doc(sellerId)
  //           .collection('AllBuyer')
  //           .doc(athenticationController.auth.currentUser?.uid)
  //           .set({
  //         'buyerName': athenticationController.getuser.name,
  //         'imageUrl': athenticationController.getuser.image,
  //       }).then((value) {
  //         athenticationController.firebaseFirestore
  //             .collection('Seller')
  //             .doc(sellerId)
  //             .collection('AllBuyer')
  //             .doc(athenticationController.auth.currentUser?.uid)
  //             .collection('Allchat')
  //             .add({
  //           'message': txtMessage,
  //           'senderId': athenticationController.auth.currentUser?.uid,
  //         }).then((value) {
  //           print('message send');
  //         });
  //       });
  //     });
  //   });
  // }
}
