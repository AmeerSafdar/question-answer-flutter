import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/screens/login_screen.dart';
import 'package:instaclone/screens/root_widget.dart';


class InitialRoot extends StatelessWidget {
  const InitialRoot({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      initState: (_) {
        Get.put<UserController>(UserController());
      },
      builder: (_) {
        if (Get.find<UserController>().fireBaseuser != null) {
         // print(Get.find<UserController>().fireBaseuser);
          return LoginScreen() ;
        } else {
         // print(Get.find<UserController>().fireBaseuser);
          return RootWidget();
        }
      },
    );
  }
}