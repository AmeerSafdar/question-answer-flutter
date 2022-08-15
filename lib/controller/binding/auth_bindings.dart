import 'package:get/get.dart';
import 'package:instaclone/controller/refresh_user.dart';
import 'package:instaclone/controller/user_controller.dart';

class AuthBindings extends Bindings{
  @override
  void dependencies() {
      Get.put<UserController>(Get.put(UserController()));
    // TODO: implement dependencies
    // Get.lazyPut(() => AuthController());
    // Get.put<AuthController(AuthController(),permanen)
   // Get.put<UserController>(UserController(),permanent: true);
  }
}