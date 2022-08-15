import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/controller/circularController.dart';
import 'package:instaclone/controller/refresh_user.dart';
import 'package:instaclone/controller/upload_query_controller.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/model/upload_artical.dart';
import 'package:instaclone/model/users.dart' as userModel;
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/global_variables.dart';

// import 'getx';
class MobileScreen extends StatefulWidget {
  const MobileScreen({Key key}) : super(key: key);

  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  CircularContrller _circularContrller = Get.put(CircularContrller());
  UserController userController = Get.put(UserController());
  UploadQuryController uploadQuryController = Get.put(UploadQuryController());
  userModel.User _getUser = Get.put(RefreshUser()).getUser;
  PageController pageController;

  // int _pageIndex=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = new PageController(initialPage: 0);
    userController.getUser();
    getUser();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  // ignore: non_constant_identifier_names
  void on_pageChanged(int page) {
    _circularContrller.pageIndex.value = page;
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    //  _pageIndex=page;
  }

  getUser() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    _circularContrller.username.value =
        (snap.data() as Map<String, dynamic>)['username'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: on_pageChanged,
        controller: pageController,
        children: HomeScreeItems,
      )),
     
      bottomNavigationBar: GetX<CircularContrller>(
          init: CircularContrller(),
          builder: (CircularContrller) {
            return CupertinoTabBar(
              backgroundColor: mobileBackgroundColor,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: _circularContrller.pageIndex.value == 0
                          ? primaryColor
                          : secondaryColor,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.article,
                      color: _circularContrller.pageIndex.value == 1
                          ? primaryColor
                          : secondaryColor,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle,
                        color: _circularContrller.pageIndex.value == 2
                            ? primaryColor
                            : secondaryColor),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.mode_comment_outlined,
                        color: _circularContrller.pageIndex.value == 3
                            ? primaryColor
                            : secondaryColor),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.person_alt_circle,
                      color: _circularContrller.pageIndex == 4
                          ? primaryColor
                          : secondaryColor,
                    ),
                    label: '')
              ],
              onTap: navigationTapped,
            );
          }),
    );
  }
}
