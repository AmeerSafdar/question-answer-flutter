import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instaclone/model/users.dart';


class CircularContrller extends GetxController{
  RxBool isRefreshed=false.obs;
  RxBool isLoading= false.obs;
  RxBool isUploaded=false.obs;
  RxBool issentPassword=false.obs;
  RxInt pageIndex=0.obs;
  RxBool isLoggedin=false.obs;
  RxString username=''.obs;
  Rx<User> user = Rx<User>();
  // loadingWidget(){
  //  isLoading.toggle();
  //  update();
  // }
  
  passwordResetLoad(){
    issentPassword=issentPassword.toggle();
    update();
  }

  logging(){
    isLoading=isLoggedin.toggle();
    update();
  }
  void refreshed(){
    var getUserPost=FirebaseFirestore.instance.collection('posts').orderBy('date',descending: true).snapshots();
    isRefreshed=isRefreshed.toggle();
    update();
  }
  void toggleIsUpload(){
    isUploaded =isUploaded.toggle();
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  
}