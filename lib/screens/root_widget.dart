import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/Responsive/mobile_screen.dart';
import 'package:instaclone/Responsive/responsive_layout.dart';
import 'package:instaclone/Responsive/web_screen.dart';
import 'package:instaclone/controller/refresh_user.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/screens/login_screen.dart';

enum AuthState{unknow,noLogedin,logedIn}

class RootWidget extends GetWidget<UserController> {
  const RootWidget({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX(
      initState: (_) async{
         Get.put<UserController>(UserController());

      },
      // ignore: missing_return
      builder: (_){
        if (Get.find<UserController>().userModel.uid !=null) {
          return ResposiveLayout(mobileScreenLayout: MobileScreen(), webScreenLayout: WebScreenLayout());
        }
        else{
         return LoginScreen();
        }

        // return (Get.find<AuthController>().user !=null ? HomeScreen() :  LoginScreen());
      },
    );
    
    
    
    // Obx((){
    //   return (Get.find<AuthController>().user !=null) ? HomeScreen() : LoginScreen();
    // });
  }
}