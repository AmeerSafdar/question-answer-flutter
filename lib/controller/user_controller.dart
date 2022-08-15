import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:instaclone/Responsive/mobile_screen.dart';
import 'package:instaclone/Responsive/responsive_layout.dart';
import 'package:instaclone/Responsive/web_screen.dart';
import 'package:instaclone/model/user_Model.dart';
import 'package:instaclone/model/users.dart' as userModerl;
import 'package:instaclone/resources/storage_methods.dart';
import 'package:instaclone/screens/root_widget.dart';

class UserController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;
// final UserModel _userModel;
  Rx<userModerl.User> _userModel = userModerl.User().obs;

  userModerl.User get userModel => _userModel.value;

  set user(userModerl.User value) => this._userModel.value = value;

  final fireUser = Rx<User>();
  RxBool isSignUpLoading = false.obs;

  User get fireBaseuser => fireUser.value;

  @override
  void onInit() {
    fireUser.bindStream(auth.authStateChanges());
    // print("User id is ${fireBaseuser.uid}");
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<userModerl.User> getUserDetail() async {
    try {
      User currentUser = auth.currentUser;
      print("currentusers $currentUser");

      DocumentSnapshot snap = await firebaseFirestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      // _circle.user = Map<String, dynamic> as;
      user = userModerl.User.fromSnap(snap);
    } catch (e) {
      print(" error is $e");
    }
    // return userModerl.User.fromSnap(snap);
  }

  Rx<UserModel> usermodel = UserModel().obs;

  UserModel get getuser => usermodel.value;
  set getuser(UserModel value) => usermodel.value = value;

  getUser() async {
    try {
      print('function call');
      print('my user is ${auth.currentUser?.uid}');
      DocumentSnapshot doc = await firebaseFirestore
          .collection("users")
          .doc(auth.currentUser?.uid)
          .get();
      print('doc is $doc');
      getuser = UserModel.fromSnamshot(doc);
    } catch (e) {}
  }

  // singUpControllerClear();

  Future<void> creatAccountWithEmail(String email, String password, String name,
      String bio, Uint8List image) async {
    String photoUrl = await StorageMethods()
        .uploadImagetoStorage('profilePictures', image, false);

    //    final ref = FirebaseStorage.instance
    //     .ref()
    //     .child('DeliveryMan-images')
    //     .child(auth.currentUser.uid);
    // await ref.putFile(image);
    // final url = await ref.getDownloadURL();

    Map<String, dynamic> userinfo = {
      "email": email,
      "photourl": photoUrl,
      "name": name,
      "bio": bio,
      "time": DateTime.now(),
    };
    auth
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .then((value) {
      firebaseFirestore
          .collection('users')
          .doc(value.user?.uid)
          .set(userinfo)
          .then((value) {
        isSignUpLoading.value = false;
        Get.snackbar('Account Created', 'Account Created Succeszfully');
        // Get.off(() => RootPage());
        Get.offAll(ResposiveLayout(
            mobileScreenLayout: MobileScreen(),
            webScreenLayout: WebScreenLayout()));

        // singUpControllerClear();
      }).catchError((e) {
        isSignUpLoading.value = false;
        Get.snackbar('Error', e.toString());
        //singUpControllerClear();
      });
    }).catchError((e) {
      isSignUpLoading.value = false;
      Get.snackbar('Error', e.toString());
      //singUpControllerClear();
    });
  }

//  void clear(){
//    _userModel.value = userModerl.User
//    (userName: '', uid: '', photoUrl: '', email: '', bio: '', followers: [], following: []);
//  }

  // void signOut() async{
  //   try {
  //   await  auth.signOut();
  //   // Get.delete<UserController>();
  //   Get.find<UserController>().clear();
  //   Get.offAll(RootWidget());
  //   // Get.to(LoginScreen());
  //   } catch (e) {
  //     // Get.snackbar(
  //     //   'Error Signing out', e.message,
  //     //   snackPosition: SnackPosition.BOTTOM
  //     //   );
  //   }

  // }

//  void alreadyLoggedIn(String name){
//    _userModel.value.name=name;
//  }

}
