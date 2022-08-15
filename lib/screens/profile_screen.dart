import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/resources/auth_methods.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/resources/storage_methods.dart';
import 'package:instaclone/screens/edit_post.dart';
import 'package:instaclone/screens/login_screen.dart';
import 'package:instaclone/screens/signup_screen.dart';
import 'package:instaclone/screens/user_profile.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/utils.dart';
import 'package:instaclone/widget/follow_button.dart';
import 'package:instaclone/widget/full_screen_image.dart';

class ProfileScreen extends StatefulWidget {
  String uid;
  ProfileScreen({Key key, this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserController _userController = Get.put(UserController());
  var getUserdata = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false, isLoading = false;

  //  picupdate() async{
//  String res= await FireStoreMethods().updateProfilepic(_file, 'profilePictures');
//  print(res);
//  }
  UserController userController = Get.put(UserController());
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var usernap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      getUserdata = usernap.data();

      //get post data
      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLength = postsnap.docs.length;

      followers = usernap.data()['followers'].length;
      following = usernap.data()['following'].length;

      isFollowing = usernap.data()['followers'].contains(widget.uid);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // FirebaseAuth.instance.currentUser.uid==widget.uid;
    //_userController.getUserDetail();
    userController.getUser();
    // print('current id is ${FirebaseAuth.instance.currentUser.uid}');
    // print('user id is ${_userController.userModel.uid}');

    super.initState();

    getData();
  }

  Uint8List _file = null;
  String res = '';
  Future<void> _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create a post'),
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SimpleDialogOption(
                  child: Text('Take a photo'),
                  onPressed: () async {
                    Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                      print(_file);
                    });
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SimpleDialogOption(
                  child: Text('Choose from Gallery'),
                  onPressed: () async {
                    Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                      print(_file);
                    });
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SimpleDialogOption(
                  child: Text('Cancel'),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text('Profile'),
          centerTitle: false,
        ),
        body: Obx(
          () => Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
              userController.getuser.photoUrl!=null?  
              CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      NetworkImage(userController.getuser.photoUrl),
                )
                :
                 CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  // backgroundImage
                )
                ,
                SizedBox(
                  height: 9,
                ),
                
                Text(userController.getuser.userName),
                SizedBox(
                  height: 9,
                ),
                Text(userController.getuser.bio),
                SizedBox(
                  height: 9,
                ),
                Text(userController.getuser.email),
                SizedBox(
                  height: 9,
                ),
                  RaisedButton(
                  child: Text('Profiles'),
                  onPressed: () {
                  Get.to(
                    UserProfileWidget(
username:userController.getuser.userName ,
email:userController.getuser.email ,
bio: userController.getuser.bio,
photoUrl: userController.getuser.photoUrl,
uid:  userController.getuser.uid,

                    )
                  );
                }),
                RaisedButton(
                  child: Text('Signout'),
                  onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Get.offAll(LoginScreen());
                  }
                  );
                })
              ],
            ),
          ),
        )
//          Obx(
//           () => ListView(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundColor: Colors.grey,
//                           backgroundImage:
//                               NetworkImage(userController.getuser.photoUrl),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   // folowers(postLength, 'Posts'),
//                                   // folowers(followers, 'Followers'),
//                                   // folowers(following, 'Following'),
//                                 ],
//                               ),
//                               // FirebaseAuth.instance.currentUser.uid ==
//                               //         widget.uid
//                               //     ? Column(
//                               //         children: [
//                               //           FollowButton(
//                               //             btnTxt: 'Sign Out',
//                               //             textColor: Colors.white,
//                               //             bgColor: mobileBackgroundColor,
//                               //             prees: () async {
//                               //               await AuthMethods()
//                               //                   .signOut(context);
//                               //             },
//                               //             borderColors: Colors.grey,
//                               //           ),
//                               //           FollowButton(
//                               //             btnTxt: 'Profile',
//                               //             textColor: Colors.white,
//                               //             bgColor: mobileBackgroundColor,
//                               //             prees: () {
//                               //               Get.to(UserProfileWidget(
//                               //                 username:
//                               //                     getUserdata['username'],
//                               //                 bio: getUserdata['bio'],
//                               //                 email: getUserdata['email'],
//                               //                 photoUrl:
//                               //                     getUserdata['photourl'],
//                               //                 uid: getUserdata['uid'],
//                               //               ));
//                               //             },
//                               //             borderColors: Colors.grey,
//                               //           ),
//                               //         ],
//                               //       )
//                               //     : isFollowing
//                               //         ? FollowButton(
//                               //             btnTxt: 'unfollow',
//                               //             textColor: Colors.black,
//                               //             bgColor: Colors.white,
//                               //             prees: () async {
//                               //               await FireStoreMethods()
//                               //                   .followUser(
//                               //                       FirebaseAuth.instance
//                               //                           .currentUser.uid,
//                               //                       getUserdata['uid']);
//                               //               setState(() {
//                               //                 isFollowing = false;
//                               //                 followers--;
//                               //               });
//                               //             },
//                               //             borderColors: Colors.grey,
//                               //           )
//                               //         : FollowButton(
//                               //             btnTxt: 'Follow',
//                               //             textColor: Colors.white,
//                               //             bgColor: Colors.blue,
//                               //             prees: () async {
//                               //               await FireStoreMethods()
//                               //                   .followUser(
//                               //                       FirebaseAuth.instance
//                               //                           .currentUser.uid,
//                               //                       getUserdata['uid']);
//                               //               setState(() {
//                               //                 isFollowing = true;
//                               //                 followers++;
//                               //               });
//                               //             },
//                               //             borderColors: Colors.blue,
//                               //           ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       padding: EdgeInsets.only(top: 15),
//                       child: Text(
//                         // _userController.userModel.userName,
//                         userController.getuser.userName,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       padding: EdgeInsets.only(top: 1.6),
//                       child: Text(userController.getuser.userName),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(),
// // Container(
// //                     height: 90,
// //                     width: 60,
// //                     child: Image(
// //                             image: NetworkImage('https://images.unsplash.com/photo-1638913660695-b490171d17c9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=872&q=80'),
// //                             fit: BoxFit.cover,
// //                           ),
// //                   ),
//               FutureBuilder(
//                   future: FirebaseFirestore.instance
//                       .collection('posts')
//                       .where('uid', isEqualTo: widget.uid)
//                       .get(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }

//                     return ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: (snapshot.data as dynamic).docs.length,
//                         shrinkWrap: true,
//                         itemBuilder: (BuildContext context, int index) {
//                           DocumentSnapshot snap =
//                               (snapshot.data as dynamic).docs[index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 15),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8.0, vertical: 2),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Container(
//                                         width: 80 * SizeConfig.widthMultiplier,
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 8.0),
//                                           child: Text(
//                                             snap['description'],
//                                             overflow: TextOverflow.clip,
//                                             softWrap: true,
//                                           ),
//                                         ),
//                                       ),
//                                       PopupMenuButton(
//                                         child: Icon(Icons.more_vert_rounded),
//                                         itemBuilder: (context) {
//                                           return List.generate(1, (index) {
//                                             return PopupMenuItem(
//                                               // padding: EdgeInsets.all(0),
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   SizedBox(
//                                                     height: 6,
//                                                   ),
//                                                   InkWell(
//                                                     child: Text('Delete'),
//                                                     onTap: () async {
//                                                       Navigator.pop(context);
//                                                       await FireStoreMethods()
//                                                           .deletePost(
//                                                               snap['postid'],
//                                                               context);

//                                                       print('Deleted');
//                                                     },
//                                                   ),
//                                                   Divider(),
//                                                   SizedBox(
//                                                     height: 6,
//                                                   ),
//                                                   GestureDetector(
//                                                       onTap: () {
//                                                         print('ontap edit');
//                                                         Navigator.pop(context);
//                                                         Get.to(EditPost(
//                                                           description: snap[
//                                                               'description'],
//                                                           posturl:
//                                                               snap['posturl'],
//                                                           postId:
//                                                               snap['postid'],
//                                                         ));
//                                                       },
//                                                       child: Text('Edit')),
//                                                   SizedBox(
//                                                     height: 6,
//                                                   ),
//                                                 ],
//                                               ),
//                                             );
//                                           });
//                                         },
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 snap['posturl'] != null
//                                     ? GestureDetector(
//                                         onTap: () {
//                                           Get.to(ShowFullImage(
//                                             imgPath: snap['posturl'],
//                                           ));
//                                         },
//                                         child: Container(
//                                             height:
//                                                 SizeConfig.heightMultiplier *
//                                                     35,
//                                             width: double.infinity,
//                                             child: Image(
//                                               fit: BoxFit.cover,
//                                               image: NetworkImage(
//                                                 snap['posturl'],
//                                               ),
//                                             )),
//                                       )
//                                     : SizedBox(
//                                         height: 0,
//                                       ),
//                                 SizedBox(
//                                   height: 3,
//                                 ),
//                                 Divider(),
//                                 SizedBox(
//                                   height: 3,
//                                 ),
//                               ],
//                             ),
//                           );
//                         });
//                     // return GridView.count(
//                     //   crossAxisCount: 3,
//                     //   crossAxisSpacing: 5,
//                     //   mainAxisSpacing: 5,
//                     //   shrinkWrap: true,
//                     //   children: List.generate((snapshot.data as dynamic).docs.length, (index)  {
//                     //     DocumentSnapshot snap = (snapshot.data as dynamic).docs[index];
//                     //     return Padding(
//                     //       padding: EdgeInsets.all(3),
//                     //      child: GestureDetector(
//                     //        onTap: (){
//                     //          Get.to(
//                     //            ShowFullImage(
//                     //              imgPath: snap['posturl'],
//                     //          ));
//                     //        },
//                     //        child: Container(
//                     //                          height: 40,
//                     //                          width: 60,
//                     //                          child: Image(
//                     //                          image: NetworkImage(snap['posturl']),
//                     //                          fit: BoxFit.cover,
//                     //             ),
//                     //                        ),
//                     //      )

//                     //       );
//                     //   }
//                     //   )

//                     //   );

//                     //  return ListView.builder(

//                     //    itemCount:  (snapshot.data as dynamic).docs.length,shrinkWrap: true,
//                     //    itemBuilder: (context,index){
//                     //      return Column(
//                     //        children: [
//                     //          Row(
//                     //            children: [

//                     //            ],
//                     //          )
//                     //        ],
//                     //      );
//                     //  });

//                     //  return GridView.builder(
//                     //   itemCount:  (snapshot.data as dynamic).docs.length,
//                     //   shrinkWrap: true,
//                     //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     //     crossAxisCount: 1,
//                     //     crossAxisSpacing: 5,
//                     //     mainAxisSpacing: 1.4,
//                     //     childAspectRatio: 1 ,

//                     //     ),
//                     // itemBuilder: (context,index){
//                     //   DocumentSnapshot snap = (snapshot.data as dynamic).docs[index];
//                     //   return Container(
//                     //     height: 40,
//                     //     width: 60,
//                     //     child: Image(
//                     //             image: NetworkImage(snap['posturl']),
//                     //             fit: BoxFit.cover,
//                     //           ),
//                     //   );
//                     // }
//                     // );
//                   })
//             ],
//           ),
//         )

        //   _userController.userModel.uid ==null?
        //   Container(
        //   alignment: AlignmentDirectional.center,
        //   padding: EdgeInsets.symmetric(horizontal: 30),
        //   // height: config.App(context).appHeight(70),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       Stack(
        //         children: <Widget>[

        //           Stack(
        //             children: [
        //              Container(
        //                height: 230,
        //                width:230,
        //               //  color: Theme.of(context).primaryColor,
        //               //  depth: -120,
        //               //  curveType: CurveType.concave,
        //                child: Padding(
        //                  padding: EdgeInsets.all(12),
        //                  child: Container(
        //                   //  color: Theme.of(context).scaffoldBackgroundColor,
        //                    width: 150,
        //                    height: 150,
        //                   //  borderRadius: 150,
        //                   //  spread: 1,
        //                    child:Padding(
        //                      padding: const EdgeInsets.all(20.0),
        //                      child: Container(
        //                       //  spread: 0,
        //                       //  color: Theme.of(context).primaryColor,
        //                      width: 80,
        //                      height: 80,
        //                     //  borderRadius: 110,
        //                      child: Container(
        //                       //  depth: -120,
        //                        width: 50,
        //                        height:50,
        //                        color: Theme.of(context).scaffoldBackgroundColor,
        //                        child: Center(
        //                          child: Container(
        //                            padding: EdgeInsets.all(8),
        //                            decoration: BoxDecoration(
        //                              shape: BoxShape.circle,
        //                              border: Border.all(
        //                                color: Theme.of(context).hintColor,width: 1)
        //                            ),
        //                            child: Icon(
        //                       Icons.https,
        //                       size: 80,

        //                            ),
        //                          ),
        //                        ),
        //                      ),
        //                      ),
        //                    ) ,
        //                  ),
        //                  ),
        //              )
        //             ],
        //           ),
        //           // Container(
        //           //   width: 150,
        //           //   height: 150,
        //           //   decoration: BoxDecoration(
        //           //       shape: BoxShape.circle,
        //           //       gradient: LinearGradient(
        //           //           begin: Alignment.bottomLeft,
        //           //           end: Alignment.topRight,
        //           //           colors: [
        //           //             Theme.of(context).focusColor.withOpacity(0.7),
        //           //             Theme.of(context).focusColor.withOpacity(0.05),
        //           //           ])),
        //           //   child: Icon(
        //           //     Icons.https,
        //           //     color: Theme.of(context).scaffoldBackgroundColor,
        //           //     size: 70,
        //           //   ),
        //           // ),
        //           // PermissionWidgetBack(),
        //           Positioned(
        //             right: -30,
        //             bottom: -50,
        //             child: Container(
        //               width: 100,
        //               height: 100,
        //               decoration: BoxDecoration(
        //                 color: Theme.of(context)
        //                     .scaffoldBackgroundColor
        //                     .withOpacity(0.15),
        //                 borderRadius: BorderRadius.circular(150),
        //               ),
        //             ),
        //           ),
        //           Positioned(
        //             left: -20,
        //             top: -50,
        //             child: Container(
        //               width: 120,
        //               height: 120,
        //               decoration: BoxDecoration(
        //                 color: Theme.of(context)
        //                     .scaffoldBackgroundColor
        //                     .withOpacity(0.15),
        //                 borderRadius: BorderRadius.circular(150),
        //               ),
        //             ),
        //           )
        //         ],
        //       ),
        //       SizedBox(height: 15),
        //       Opacity(
        //         opacity: 0.4,
        //         child: Text(
        //           "You must sign-in to access this section",
        //           textAlign: TextAlign.center,
        //           style: Theme.of(context)
        //               .textTheme
        //               .headline3
        //               .merge(TextStyle(fontWeight: FontWeight.w300)),
        //         ),
        //       ),
        //       SizedBox(height: 50),
        //       Container(

        //         child: MaterialButton(
        //           onPressed: () {
        //            Get.to(LoginScreen());
        //           },
        //           padding: EdgeInsets.symmetric(vertical: 12, horizontal: 70),
        //           // color: Theme.of(context).accentColor.withOpacity(1),
        //           shape: StadiumBorder(),
        //           child: Text(
        //             'Login',
        //             style: Theme.of(context).textTheme.headline6.merge(
        //                 TextStyle(color: Theme.of(context).focusColor)),
        //           ),
        //         ),
        //       ),
        //       SizedBox(height: 20),
        //       MaterialButton(
        //   elevation: 0,
        //   focusElevation: 0,
        //   highlightElevation: 0,
        //         onPressed: () {
        //           Get.to(SignupScreen());
        //         },
        //         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        //         shape: StadiumBorder(),
        //         child: Text(
        //           'Don\'t have an account',
        //           style: TextStyle(color: Theme.of(context).focusColor),
        //         ),
        //       ),
        //     ],
        //   ),
        // )
        //   :
        );
  }

  Column folowers(int number, String label) {
    return Column(
      children: [
        Text(
          number.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
