import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/controller/circularController.dart';
import 'package:instaclone/model/article.dart';
import 'package:instaclone/model/post.dart';
import 'package:instaclone/resources/storage_methods.dart';
import 'package:instaclone/screens/add_articles.dart';
import 'package:instaclone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // User currentUser= _auth.currentUser;

  Future<String> updateProfilepic(Uint8List file, String child) async {
    print('method called');
    String res = '';
    String photoUrl =
        await StorageMethods().uploadImagetoStorage('pic', file, false);
    print('uploaded');
    print('url  $photoUrl');
    return res;
  }

  Future<String> uploadPost(
      String description, String uid, String username, String profimage,
      // ignore: avoid_init_to_null
      {Uint8List file}) async {
    String res = 'Some error occurs';
    try {
      String photurl = '';
      file != null
          ? photurl =
              await StorageMethods().uploadImagetoStorage('posts', file, true)
          : null;

      String postId = const Uuid().v1();

      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          posturl: file != null ? photurl : null,
          postid: postId,
          profimage: profimage,
          datepublished: DateTime.now(),
          likes: []);
      await _firebaseFirestore
          .collection('posts')
          .doc(postId)
          .set(
            post.toJson(),
          )
          .then((value) => res = 'success');
      //  return photurl;
    } catch (err) {
      res = err.toString();
    }
    return res.toString().replaceAll('-', ' ');
  }

  Future<String> closeComment(String postid) async{
 
  try {
     
     await _firebaseFirestore.collection('posts').doc(postid).update({
       "close":true
      }); 
      // res="Commented on post";   
    
  } catch (e) {
    print(e.toString());
    
  }
  return '';
  // showSnackbar(cntxt, content)

}

  Future<String> addArticles(
    String description,
    String uid,
    String username,
  ) async {
    String res = 'Some error occurs';
    try {
      String photurl = '';
      // file!=null?  photurl = await StorageMethods().uploadImagetoStorage('posts', file, true):null;

      String postId = const Uuid().v1();

      Article article = Article(
          description: description,
          uid: uid,
          username: username,
          postid: postId,
          datepublished: '',
          likes: []);
      await _firebaseFirestore
          .collection('articles')
          .doc(postId)
          .set(
            article.toJson(),
          )
          .then((value) => res = 'success');
      //  return photurl;
    } catch (err) {
      res = err.toString();
    }
    return res.toString().replaceAll('-', ' ');
  }

  Future<String> updatePost(
    String description,
    String postId,
    // ignore: avoid_init_to_null
    {
    Uint8List file,
    String photo,
  }) async {
    String res = 'Some error occurs';
    try {
      String photurl = '';
      photurl = file != null
          ? await StorageMethods().uploadImagetoStorage('posts', file, true)
          : photo;

      await _firebaseFirestore.collection('posts').doc(postId).update({
        "posturl": photurl,
        "description": description,
        "date": DateTime.now(),
      }).then((value) => res = 'success');
      //  return photurl;
    } catch (err) {
      res = err.toString();
    }
    return res.toString().replaceAll('-', ' ');
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    print(res);
    return res;
  }

  Future<String> commentsLike(
      {postId, String uid, List likes, String commentId}) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'voteup': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'voteup': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    print(res);
    return res;
  }


  Future<String> postComment(
      String postid, String text, String uid, String name, String profilepic,
      {Uint8List file}) async {
    String res = "";
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        String comentImg = '';
        file != null
            ? comentImg = await StorageMethods().uploadErrorImage(file)
            : null;
        await _firebaseFirestore
            .collection('posts')
            .doc(postid)
            .collection('comments')
            .doc(commentId)
            .set({
          "profilePic": profilepic,
          "name": name,
          "uid": uid,
          "text": text,
          "commentId": commentId,
          "datePublished": DateTime.now(),
          "commentImg": file != null ? comentImg : null,
          "voteup": []
        });
        res = "Commented on post";
      } else {
        print("not comment");
        res = "Can't post an empty text/comment";
      }
    } catch (e) {
      print(e.toString());
      res = e.toString();
    }
    return res.toString().replaceAll('-', ' ');
    // showSnackbar(cntxt, content)
  }

  Future<void> deletePost(String postid, BuildContext context) async {
    try {
      await _firebaseFirestore.collection('posts').doc(postid).delete();
      showSnackbar(context, 'Post Deleted');
    } catch (e) {
      print(e);
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firebaseFirestore.collection('users').doc(uid).get();
      List following = (snap.data() as dynamic)['following'];

      if (following.contains(followId)) {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

}
