
import 'package:get/get.dart';
import 'package:instaclone/model/users.dart';
import 'package:instaclone/resources/auth_methods.dart';

class RefreshUser extends GetxController{

  User _user;
  final AuthMethods _authMethods = new AuthMethods();

  User get getUser => _user;

  Future<void> refreshUser() async{
    final userdetail = await _authMethods.getUserDetail();
    _user = userdetail;
    update();
  }

}