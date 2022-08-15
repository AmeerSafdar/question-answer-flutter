import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/controller/upload_query_controller.dart';
import 'package:instaclone/screens/add_post.dart';
import 'package:instaclone/screens/all_users_for_chat.dart';
import 'package:instaclone/screens/articles.dart';
import 'package:instaclone/screens/feed_screen.dart';
import 'package:instaclone/screens/profile_screen.dart';
import 'package:instaclone/screens/search_screen.dart';
import 'package:instaclone/screens/upload_query_page.dart';

const webSize = 600;

List<Widget> HomeScreeItems = [
  FeedScreen(),
  ArticlesPage(),
  // AddPostScreen(),
  UploadQuryPage(),
  AllUserforChat(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser.uid,
  ),
];
