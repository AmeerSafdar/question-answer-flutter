import 'package:get/get.dart';
import 'package:instaclone/controller/user_controller.dart';

class UserBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<UserController>(() =>UserController() );
  }
}