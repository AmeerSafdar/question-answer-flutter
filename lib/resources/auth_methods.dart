import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instaclone/controller/circularController.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/model/users.dart' as userModel;
import 'package:instaclone/resources/storage_methods.dart';
import 'package:instaclone/screens/login_screen.dart';
import 'package:instaclone/screens/root_widget.dart';
import 'package:instaclone/utils/utils.dart';

class AuthMethods{
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  UserCredential userCred;
  final CircularContrller _circle=Get.put(CircularContrller());
  final UserController _userController= Get.put(UserController());

  Future<userModel.User> getUserDetail() async{

    User currentUser= _auth.currentUser;
    DocumentSnapshot snap = await _firebaseFirestore.collection('users').doc(currentUser.uid).get();
    // _circle.user = Map<String, dynamic> as;
    return userModel.User.fromSnap(snap);
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signInwithGoogle(BuildContext c) async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
     final UserCredential authResult= await _auth.signInWithCredential(credential);
    //  signupUser(
    //    cntxt: c,
    //    email: authResult.user.email,
    //    userName: authResult.user.displayName,
    //    fburl: authResult.user.photoURL,
    //  );
      Map<String , dynamic> userData={
        "email": authResult.user.email,
        "username":authResult.user.displayName,
        "photourl":authResult.user.photoURL,
        'uid': authResult.user.uid,
        'followers': [],
        'following': [],
        'bio': '',
    };

      if(authResult.additionalUserInfo.isNewUser)
{
  FirebaseFirestore.instance.collection('users').doc().set(userData).then((value)  {
    
    print('data add');
    Get.to(()=> RootWidget());

  });
}
else{
    Get.to(()=> RootWidget());

}
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  fbLogin (BuildContext context) async {
     try{
       await FacebookAuth.instance.login(
                        // permissions: ["public_profile", "email","name","bio"]
                        ).then((value1) => {
                          
                          print("fb login $value1"),
                          FacebookAuth.instance.getUserData().then((value2) => {
                            print('user data $value2'),
                            // print('${value2['bio']}')
                            // print('')
                          signupUser(
                              email: value2['email'],
                              userName: value2["name"],
                              cntxt: context,
                              fburl: value2['picture']['data']['url'] ,
                              bio: value2["bio"]).printError("some error occurs")            
                          })
                        });}
                        catch(error){
                          print(error.toString());
                        }
                      //   .then((value) {
                      // FacebookAuth.instance.getUserData().then((userData) {
                      // print(userData);
                      // _circle.logging();
                      // // _circle.isLoggedin.value? 
                      // // Get.offAll(ResposiveLayout(mobileScreenLayout: MobileScreen(), 
                      // // webScreenLayout: WebScreenLayout())):
                      // // Get.offAll(LoginScreen());
                      // }
                      // )
                      // ;
                      // }
                      // )
                      // ;
              
                // Get.offAll(ResposiveLayout(mobileScreenLayout: MobileScreen(), webScreenLayout: WebScreenLayout()));
  }

  Future<void> resetPassword(String email, BuildContext c) async {
    String res='error occured';
    _circle.passwordResetLoad();
   try{ 
     await _auth.sendPasswordResetEmail(email: email).then((value) {
      res='Password reset link sent to $email';
      _circle.passwordResetLoad();
    });}
    catch(r){
print(r);
    }
    print(res);
    _circle.issentPassword.value ? _circle.issentPassword.value=false : null;
    showSnackbar(c, res);
}

   signupUser({
     String email,
     String password,
     String userName,
     String bio,
     Uint8List file,
     BuildContext cntxt,
     String fburl
  }) async{
      String res='Some error occurs';
      try {
        if (email.isNotEmpty || password.isNotEmpty || userName.isNotEmpty || bio.isNotEmpty || file !=null) {
           // ignore: missing_return
           userCred=await _auth.createUserWithEmailAndPassword(email: email, password: password
           );
          //  .then((value) {
          //   //  User user=FirebaseAuth.instance.currentUser;
          //   //  user.sendEmailVerification();
          //  });

           print(userCred.user.uid);

           String photoUrl=  file!=null ? await StorageMethods().uploadImagetoStorage('profilePictures', file, false):fburl;
          
          print(photoUrl);

          userModel.User user=userModel.User(
             userName:userName,
             uid:userCred.user.uid,
             email:email,
             bio:bio,
             followers:[],
             following:[],
             photoUrl:photoUrl,
          );
          await _firebaseFirestore.collection('users').doc(userCred.user.uid).set(
            user.toJson(),
           );
           return res='Successfully sign up ';
        }
        else{
          res='Please enter all fields';
        }
      } on FirebaseException catch(err){
        res=err.code.toString();
      }
      catch (err) {
        res=err.toString();
        print(res);
      }
//           User user=FirebaseAuth.instance.currentUser;
//           if (user!= null && !user.emailVerified)  {
//                user.sendEmailVerification();
//                res='Email not verify';
// }
      return res;
  }

 updateProfile({
     String email,
     String userName,
     String bio,
     Uint8List file,
     BuildContext cntxt,
     uid
  }) async{
      String res='Some error occurs';
      try {
        _circle.toggleIsUpload();
        print('jeloo profile');
           // ignore: missing_return
          //  userCred=await _auth.createUserWithEmailAndPassword(email: email, password: password
          //  );
          //  .then((value) {
          //   //  User user=FirebaseAuth.instance.currentUser;
          //   //  user.sendEmailVerification();
          //  });

           print("uid $uid");

           String photoUrl= file != null ? await StorageMethods().uploadImagetoStorage('profilePictures', file, false):_userController.userModel.photoUrl ;
          
          print("photourl $photoUrl");
          print("uid is $uid email $email username $userName bio $bio ");
          
          await _firebaseFirestore.collection('users').doc(uid).update(
            {
              "email":email,
              "username":userName,
              "photourl":photoUrl,
              "bio":bio
            }
            );
           _circle.toggleIsUpload();
           return res='Successfully update profile';
           
        
       
      } on FirebaseException catch(err){
        res=err.code.toString();
      }
      catch (err) {
        res=err.toString();
        print(res);
      }
      return res;
  }

  Future<void> signOut(BuildContext cntxt) async{
   await _auth.signOut().then((value) {
       Get.offAll(()=>LoginScreen());
   });
  //
   showSnackbar(cntxt,"User signed out ");
  }


  // login user 

 Future<String> loginuser({ String email ,  String password}) async{
   String res = 'Some error occurs';

   try {
     if (email.isNotEmpty || password.isNotEmpty) {
       //_circle.isLoading.value=true;
       await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) => {

       });
       res='Log in Successfull';
     }
     else{
       res='Please enter all fields';
     }
   } on FirebaseAuthException catch(err){
     res=err.code.toString();
   }
   catch (err) {
     res=err.toString();
   }
   
   return res;
  }
}