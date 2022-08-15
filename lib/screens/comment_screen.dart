import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/controller/circularController.dart';
import 'package:instaclone/controller/upload_query_controller.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/model/upload_artical.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/screens/chat_screen.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/utils.dart';
import 'package:instaclone/widget/comment_section.dart';
import 'package:instaclone/widget/full_screen_image.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  String imagepath;
  String description;
  UploadArticle uploadArticle;
  CommentScreen(
      {Key key,
      this.snap,
      this.imagepath,
      this.description,
      this.uploadArticle})
      : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentcontroller = new TextEditingController();
  UserController _userController = Get.put(UserController());
  UploadQuryController uploadQuryController = Get.put(UploadQuryController());
  CircularContrller controll = Get.put(CircularContrller());
  @override
  void initState() {
    super.initState();
    uploadQuryController.commentStream(widget.uploadArticle.postid);
    _userController.getUserDetail();
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
        title: Text('Comment'),
        centerTitle: false,
        actions: [
             FirebaseAuth.instance.currentUser !=null?
          Row(
            children: [
            widget.uploadArticle.uploaderID == FirebaseAuth.instance.currentUser.uid?
          widget.uploadArticle.isclose?
           SizedBox(
             height: 0,
           )
           :
              TextButton(
                onPressed: () async{
                  print('closed');
                  print(widget.uploadArticle.isclose);
                 await FireStoreMethods().closeComment('${widget.uploadArticle.isclose}',);
                //  getPost();
                }, 
                child: Text('Close',style: TextStyle(color: blueColor),))
                :
                SizedBox(
                  height: 0,
                )
                ,
              IconButton(
                  onPressed: () {
                    Get.to(() => ChatScreen(
                      sellerid: widget.uploadArticle.uploaderID,
                      postUploaderImage: widget.uploadArticle.uploaderPhotoUrl,
                      postUploaderName: widget.uploadArticle.username,
                        ));
                  },
                  icon: Icon(Icons.chat)),
            ],
          ):
          SizedBox(height: 0,)

        // FirebaseAuth.instance.currentUser !=null?  
        // IconButton(
        //       onPressed: () {
        //         Get.to(() => ChatScreen(
        //               sellerid: widget.uploadArticle.uploaderID,
        //               postUploaderImage: widget.uploadArticle.uploaderPhotoUrl,
        //               postUploaderName: widget.uploadArticle.username,
        //             ));
        //       },
        //       icon: Icon(Icons.chat)):
        //       SizedBox(height: 0,)
        ],
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          //
          children: [
            Container(
                child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.description,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )),
            widget.imagepath != null
                ? 
                GestureDetector(
                    onTap: () {
                      Get.to(ShowFullImage(
                        imgPath: widget.imagepath,
                      ));
                    },
                    child: Hero(
                      tag: widget.imagepath,
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                        height: SizeConfig.heightMultiplier * 20,
                        width: double.infinity,
                        child: Image.network(
                          widget.imagepath,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            GetX<UploadQuryController>(
                init: Get.put(UploadQuryController()),
                builder: (uploadQuryController) {
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: uploadQuryController.getcommentList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(8),
                          // height: 20 * SizeConfig.heightMultiplier,
                          width: 80 * SizeConfig.widthMultiplier,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(uploadQuryController
                                  .getcommentList[index].commentText),
                              uploadQuryController
                                      .getcommentList[index].postUrl.isNotEmpty
                                  ? GestureDetector(
                                    onTap: (){
                                      print('image');
                                          Get.to(
                                            ShowFullImage(imgPath: uploadQuryController
                                              .getcommentList[index].postUrl,)
                                          );
                                        },
                                    child: Container(
                                        // margin: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                        height: SizeConfig.heightMultiplier * 20,
                                        width: double.infinity,
                                        child: Image.network(
                                          uploadQuryController
                                              .getcommentList[index].postUrl,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                  )
                                  : SizedBox(),
                              SizedBox(
                                height: 2 * SizeConfig.heightMultiplier,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person),
                                      Text(
                                        uploadQuryController
                                          .getcommentList[index].username
                                          .toUpperCase()),
                                    ],
                                  ),
                                  Text(uploadQuryController
                                      .getcommentList[index].datepublished),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                })
          ],
        ),
      )

          // ListView.builder(
          //   itemCount: (commentsnapshot.data as dynamic).docs.length,
          //   itemBuilder: (context, index) {
          //     print('index is $index');
          //     // var a= FirebaseFirestore.instance.collection('posts').doc(widget.snap['postid']).collection('comments').snapshots();
          //     // print(a.data()['text']);
          //     return Padding(
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           index == 0 || index <= 0
          //               ? Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   children: [
          //                     Container(
          //                         child: Padding(
          //                       padding: const EdgeInsets.only(
          //                           top: 8.0, bottom: 8),
          //                       child: Text(
          //                         widget.description,
          //                         style: TextStyle(
          //                             color: primaryColor,
          //                             fontSize: 12,
          //                             fontWeight: FontWeight.w500),
          //                       ),
          //                     )),

          //                   ],
          //                 )
          //               : SizedBox(
          //                   height: 0,
          //                 ),
          //           // Padding(
          //           //   padding: const EdgeInsets.only(top: 8.0),
          //           //   child: CommentCardWidget(
          //           //     snap: commentsnapshot.data.docs[index],
          //           //   ),
          //           // ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
          ),
      // StreamBuilder(
      //     stream: FirebaseFirestore.instance
      //         .collection('posts')
      //         .doc(widget.uploadArticle.postid)
      //         .collection('comments')
      //         .orderBy('datePublished', descending: true)
      //         .snapshots(),
      //     // ignore: missing_return
      //     builder: (context, commentsnapshot) {
      //       if (commentsnapshot.connectionState == ConnectionState.waiting) {
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }

      //       return ;
      //     }),
      // CommentCardWidget(),
      bottomNavigationBar: 
      FirebaseAuth.instance.currentUser !=null?
      SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            Container(
              child: _userController.userModel.photoUrl != null
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(_userController.userModel.photoUrl),
                    )
                  : Container(
                      height: 15,
                      child: FittedBox(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: TextFormField(
                // readOnly: true,
                controller: _commentcontroller,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () async {
                          await _selectImage(context);
                        },
                        icon: Icon(Icons.link)),
                    hintText: 'Reply this query',
                    // 'Comment as ${_userController.userModel.userName}',
                    border: InputBorder.none),
              ),
            )),
            Obx(
              () => uploadQuryController.isCommentPost.value
                  ? CircularProgressIndicator()
                  : InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Container(
                          child: Text(
                            'Post',
                            style: TextStyle(color: blueColor),
                          ),
                        ),
                      ),
                      onTap: () async {
                        uploadQuryController.isCommentPost.value = true;
                        uploadQuryController
                            .commentonPost(
                          postId: widget.uploadArticle.postid,
                          commentText: _commentcontroller.text,
                          image: _file,
                          uploaderPhotoUrl: _userController.getuser.photoUrl,
                          userId: _userController.getuser.uid,
                          username: _userController.getuser.userName,
                        )
                            .then((value) {
                          _commentcontroller.clear();
                        });
                        // controll.isUploaded.value = true;
                        // res = await FireStoreMethods().postComment(
                        //     widget.uploadArticle.postid,
                        //     _commentcontroller.text,
                        //     _userController.userModel.uid,
                        //     _userController.userModel.userName,
                        //     _userController.userModel.photoUrl,
                        //     file: _file);
                        // print('Post a comment as ');
                        // _commentcontroller.text = "";
                        // controll.isUploaded.value = false;
                        // _file = null;
                        // showSnackbar(context, res);
                      },
                    ),
            )
            // Obx(() => !controll.isUploaded.value
            //     ? InkWell(
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 3.0),
            //           child: Container(
            //             child: Text(
            //               'Post',
            //               style: TextStyle(color: blueColor),
            //             ),
            //           ),
            //         ),
            //         onTap: () async {

            //           // controll.isUploaded.value = true;
            //           // res = await FireStoreMethods().postComment(
            //           //     widget.uploadArticle.postid,
            //           //     _commentcontroller.text,
            //           //     _userController.userModel.uid,
            //           //     _userController.userModel.userName,
            //           //     _userController.userModel.photoUrl,
            //           //     file: _file);
            //           // print('Post a comment as ');
            //           // _commentcontroller.text = "";
            //           // controll.isUploaded.value = false;
            //           // _file = null;
            //           // showSnackbar(context, res);
            //         },
            //       )
            //     : Padding(
            //         padding: const EdgeInsets.only(right: 5.0),
            //         child: Container(
            //           height: 15,
            //           width: 15,
            //           child: FittedBox(
            //             child: CircularProgressIndicator(
            //               color: blueColor,
            //             ),
            //           ),
            //         ),
            //       ))
          ],
        ),
      )):
      SizedBox(height: 0,)
      // showSnackbar(context, 'you must log in')
      ,
    );
  }
}
