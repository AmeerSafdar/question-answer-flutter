import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/model/article.dart';
import 'package:instaclone/model/comments_model.dart';
import 'package:instaclone/model/upload_artical.dart';
import 'package:instaclone/resources/storage_methods.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class UploadQuryController extends GetxController {
  @override
  void onInit() {
    postList.bindStream(getPostStram('All'));
    articelList.bindStream(getArticleStream());
    // TODO: implement onInit
    super.onInit();
  }

  Rx<List<UploadArticle>> postList = Rx<List<UploadArticle>>([]);
  List<UploadArticle> get getpostList => postList.value;

  Rx<List<CommentModel>> commentList = Rx<List<CommentModel>>([]);
  List<CommentModel> get getcommentList => commentList.value;

  Rx<List<Article>> articelList = Rx<List<Article>>([]);
  List<Article> get getarticelList => articelList.value;

  void commentStream(String postid) {
    commentList.bindStream(getCommentStream(postid));
  }

  Stream<List<Article>> getArticleStream() {
    return FirebaseFirestore.instance
        .collection('articles')
        .snapshots()
        .map((QuerySnapshot query) {
      List<Article> retVal = [];
      for (var element in query.docs) {
        retVal.add(Article.fromSnap(element));
      }
      print('article is ${retVal.length}');

      return retVal;
    });
  }

  Stream<List<CommentModel>> getCommentStream(String postid) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postid)
        .collection('comments')
        //.where("orderStatus", isNotEqualTo: 'completed')
        .snapshots()
        .map((QuerySnapshot query) {
      List<CommentModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(CommentModel.fromSnap(element));
      }
      print('Comment is ${retVal.length}');

      return retVal;
    });
  }

  UserController userController = Get.put(UserController());

  RxBool isCommentPost = false.obs;
  getPostByCategory(String category) {
    postList.bindStream(getPostStram(category));
  }

  Stream<List<UploadArticle>> getPostStram(String category) {
    if (category.trim() == 'All') {
      return FirebaseFirestore.instance
          .collection('posts')
          //.where("orderStatus", isNotEqualTo: 'completed')
          .snapshots()
          .map((QuerySnapshot query) {
        List<UploadArticle> retVal = [];
        for (var element in query.docs) {
          retVal.add(UploadArticle.fromSnap(element));
        }
        print('post legth is ${retVal.length}');

        return retVal;
      });
    } else {
      return FirebaseFirestore.instance
          .collection('posts')
          .where("category", isEqualTo: category)
          .snapshots()
          .map((QuerySnapshot query) {
        List<UploadArticle> retVal = [];
        for (var element in query.docs) {
          retVal.add(UploadArticle.fromSnap(element));
        }
        print('post else legth is ${retVal.length}');

        return retVal;
      });
    }
  }

  RxBool isPostUpload = false.obs;

  Future<void> uploadQuery(
    String description,
    String uploaderID,
    String username,
    Uint8List image,
    String uploaderPhotoUrl,
    String category,
  ) async {
    DateTime now = DateTime.now();
    String postId= Uuid().v1();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    if (image == null) {
      print('image null');
      Map<String, dynamic> queryData = {
        'username': username,
        'description': description,
        'uploaderPhotoUrl': uploaderPhotoUrl,
        'datepublished': formattedDate,
        'category': category,
        'uploaderID': uploaderID,
        'postUrl': postId,
        'isLike': false,
        'isclose':false
      };
      FirebaseFirestore.instance
          .collection('posts')
          .add(queryData)
          .then((value) {
        isPostUpload.value = false;
        Get.back();

        print('query uploaded');
      }).catchError((e) {
        isPostUpload.value = false;

        Get.snackbar('Error', e.toString());
      });
    } else {
      String photoUrl =
          await StorageMethods().uploadImagetoStorage('query', image, false);

      Map<String, dynamic> queryData = {
        'username': username,
        'description': description,
        'uploaderPhotoUrl': uploaderPhotoUrl,
        'datepublished': formattedDate,
        'postUrl': photoUrl,
        'category': category,
        'uploaderID': uploaderID,
        'isLike': false
      };

      FirebaseFirestore.instance
          .collection('posts')
          .add(queryData)
          .then((value) {
        Get.back();

        isPostUpload.value = false;

        print('query uploaded');
      }).catchError((e) {
        isPostUpload.value = false;

        Get.snackbar('Error', e.toString());
      });
    }
  }

  likepost(String postId, bool isLike, String uploaderId) {
    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'isLike': !isLike,
    }).then((value) {
      print('is like is $isLike');
      if (isLike) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(userController.getuser.uid)
            .delete()
            .then((value) {
          print('Delete');
        });
      } else {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(userController.getuser.uid)
            .set({
          'userName': userController.getuser.userName,
          'PhotoUlr': userController.getuser.photoUrl,
        }).then((value) {
          print('add');
        });
      }
    });
  }

  Future<void> commentonPost(
      {String commentText,
      String userId,
      String username,
      String uploaderPhotoUrl,
      Uint8List image,
      String postId}) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    if (image != null) {
      String photoUrl =
          await StorageMethods().uploadImagetoStorage('query', image, false);

      Map<String, dynamic> commnetMap = {
        'username': username,
        'commentText': commentText,
        'uploaderPhotoUrl': uploaderPhotoUrl,
        'postUrl': photoUrl,
        'userId': userId,
        'datepublished': formattedDate
      };
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(commnetMap)
          .then((value) {
        isCommentPost.value = false;
        print('comment Posted');
      }).catchError((e) {
        isCommentPost.value = false;
        Get.snackbar('Error', e.toString());
      });
    } else {
      Map<String, dynamic> commnetMap = {
        'username': username,
        'commentText': commentText,
        'uploaderPhotoUrl': uploaderPhotoUrl,
        'postUrl': '',
        'userId': userId,
        'datepublished': formattedDate
      };
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(commnetMap)
          .then((value) {
        isCommentPost.value = false;

        print('comment Posted');
      }).catchError((e) {
        isCommentPost.value = false;
        Get.snackbar('Error', e.toString());
      });
    }
  }

  Future<void> addArtical({
    String description,
  }) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    Map<String, dynamic> commnetMap = {
      'username': userController.getuser.userName,
      'description': description,
      'uid': userController.getuser.uid,
      'likes': [],
      'datepublished': formattedDate
    };

    FirebaseFirestore.instance
        .collection('articles')
        .add(commnetMap)
        .then((value) =>
            {Get.snackbar('Article added', 'Article addes successfully')})
        .catchError((e) {
      Get.snackbar('Error', e.toString());
    });
  }
}
