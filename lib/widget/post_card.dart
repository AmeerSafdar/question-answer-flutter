import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/controller/upload_query_controller.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/model/upload_artical.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/screens/comment_screen.dart';
import 'package:instaclone/screens/edit_post.dart';
import 'package:instaclone/screens/profile_screen.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/utils.dart';
import 'package:instaclone/widget/full_screen_image.dart';
import 'package:instaclone/widget/like_animation.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final snap;
  UploadArticle uploadArticle;

  PostCard({Key key, this.snap, this.uploadArticle}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLenght = 0;
  UploadQuryController uploadQuryController = Get.put(UploadQuryController());
  @override
  void initState() {
    super.initState();
    getComments();
  }

  getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postid'])
          .collection('comments')
          .get();
      commentLenght = snap.docs.length;
    } catch (e) {
      showSnackbar(context, e.toString().replaceAll('-', ' '));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    final user = userController.userModel;
    bool isLikeAnimating = false;
    return Container(
      color: mobileBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
            // vertical: 5,
            horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 5,
                // horizontal: 16
              ).copyWith(right: 0),
              child: GestureDetector(
                onTap: () {
                  // Get.to(ProfileScreen(
                  //   uid: widget.snap['uid'],
                  // ));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundImage:
                          NetworkImage(widget.uploadArticle.uploaderPhotoUrl),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Text(
                              widget.uploadArticle.username,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                 FirebaseAuth.instance.currentUser!=null?   PopupMenuButton(
                      child: Icon(Icons.more_vert_rounded),
                      itemBuilder: (context) {
                        return List.generate(1, (index) {
                          return PopupMenuItem(
                            // padding: EdgeInsets.all(0),
                            child: FirebaseAuth.instance.currentUser.uid==widget.uploadArticle.uploaderID? 
                            InkWell(
                              onTap: ()async{
                                 Navigator.pop(context);
                              await FireStoreMethods().deletePost(
                                  widget.snap['postid'], context);

                              print('Deleted');
                              },
                              child: Text('Delete')):InkWell(
                                onTap: (){
                                  Get.to(
                                    EditPost(
                                      description:widget.uploadArticle.description ,
                                      postId: widget.uploadArticle.postid,
                                      posturl: widget.uploadArticle.postUrl,
                                      
                                    )
                                  );
                                },
                                child: Text("Edit")),
                          );
                        });
                      },
                    ):
                    SizedBox(
                      height: 0,
                    )
                    // IconButton(onPressed: (){
                    //   showDialog(context: context, builder: (context)=>Dialog(
                    //     child: ListView(
                    //       children: [
                    //         'Delete'
                    //       ].map((e)=>InkWell(
                    //           onTap: (){},
                    //           child: Container(

                    //             padding: EdgeInsets.symmetric(vertical:12,horizontal: 14),
                    //             child: Text(e),
                    //           ))
                    //       ).toList(),
                    //     ),
                    //   )
                    //   );
                    // }, icon: Icon(Icons.more_vert_outlined))
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 7, bottom: 8),
              width: double.infinity,
              child: RichText(
                text:
                    TextSpan(style: TextStyle(color: primaryColor), children: [
                  //  TextSpan(
                  //    text: '${widget.snap['username']}',
                  //    style: TextStyle(fontWeight: FontWeight.bold)

                  //  ),
                  TextSpan(
                    text: '  ${widget.uploadArticle.description}',
                  )
                ]),
              ),
            ),
            SizedBox(
              height: 9,
            ),
            widget.uploadArticle.postUrl.isEmpty
                ? SizedBox(
                    height: 0,
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(
                              ShowFullImage(
                                  imgPath: widget.uploadArticle.postUrl),
                              transition: Transition.fadeIn);
                        },
                        onDoubleTap: () async {
                          await FireStoreMethods().likePost(
                              widget.snap['postid'],
                              user.uid,
                              widget.snap['likes']);
                          setState(() {
                            isLikeAnimating = true;
                            print(isLikeAnimating);
                          });
                        },
                        child: SizedBox(
                          height: SizeConfig.heightMultiplier * 28,
                          width: double.infinity,
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.uploadArticle.postUrl),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 80,
                            color: Colors.red,
                          ),
                          isAnimating: isLikeAnimating,
                          duration: Duration(
                            milliseconds: 4000,
                          ),
                          onEnd: () async {
                            print('On End');
                            setState(() {
                              isLikeAnimating = true;
                              print(isLikeAnimating);
                            });
                          },
                        ),
                      )
                    ],
                  ),
            SizedBox(
              height: 2 * SizeConfig.heightMultiplier,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                    FirebaseAuth.instance.currentUser !=null?  uploadQuryController.likepost(
                          widget.uploadArticle.postid,
                          widget.uploadArticle.isLike,
                          widget.uploadArticle.uploaderID)
                          :
                          showSnackbar(context, "you must log in")
                          ;
                    },
                    icon: Icon(
                      Icons.sports_handball_outlined,
                      color: widget.uploadArticle.isLike
                          ? Colors.blue
                          : Colors.white,
                    )),
                IconButton(
                    onPressed: () {
                      Get.to(CommentScreen(
                          uploadArticle: widget.uploadArticle,
                          snap: widget.snap,
                          imagepath: widget.uploadArticle.postUrl.isNotEmpty
                              ? widget.uploadArticle.postUrl
                              : null,
                          description: widget.uploadArticle.description));
                      print('comment');
                    },
                    icon: Icon(Icons.comment_sharp))
              ],
            )
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     LikeAnimation(
            //       isAnimating: widget.snap['likes'].contains(user.uid),
            //       child: IconButton(
            //           onPressed: () async {
            //             await FireStoreMethods().likePost(widget.snap['postid'],
            //                 user.uid, widget.snap['likes']);
            //             print('likes');
            //             setState(() {
            //               isLikeAnimating = true;
            //               print(isLikeAnimating);
            //             });
            //             print('Likes');
            //           },
            //           icon: widget.snap['likes'].contains(user.uid)
            //               ? Icon(Icons.arrow_circle_up_outlined,
            //                   color: Colors.green)
            //               : Icon(Icons.arrow_circle_up_outlined)),
            //     ),

            //     IconButton(
            //         onPressed: () async {
            //           Get.to(CommentScreen(
            //               snap: widget.snap,
            //               imagepath: widget.snap['posturl'] != null
            //                   ? widget.snap['posturl']
            //                   : null,
            //               description: widget.snap['description']));
            //           print('comment');
            //           setState(() {});
            //         },
            //         icon:
            //             Icon(CupertinoIcons.chat_bubble, color: primaryColor)),
            //     //  IconButton(
            //     //   onPressed: (){
            //     //   print('share');
            //     // },
            //     // icon: Icon(CupertinoIcons.location_fill,color:primaryColor)),
            //     // Expanded(
            //     //   child: IconButton(
            //     //     alignment: Alignment.bottomRight,
            //     //     onPressed: () async{
            //     //       print('book mark');
            //     //     },
            //     //     icon: Icon(Icons.bookmark_border,)
            //     // ))
            //   ],
            // ),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            //   child: Column(
            //     // mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       DefaultTextStyle(
            //           style: Theme.of(context)
            //               .textTheme
            //               .subtitle1
            //               .copyWith(fontWeight: FontWeight.bold),
            //           child: Text(
            //             '${widget.snap['likes'].length} votes',
            //             style: Theme.of(context).textTheme.bodyText2,
            //           )),
            //       //  Container(
            //       //    padding: EdgeInsets.only(top: 10),
            //       //    width: double.infinity,
            //       //    child: RichText(
            //       //      text: TextSpan(
            //       //        style: TextStyle(color: primaryColor),
            //       //        children: [
            //       //          TextSpan(
            //       //            text: '${widget.snap['username']}',
            //       //            style: TextStyle(fontWeight: FontWeight.bold)

            //       //          ),
            //       //          TextSpan(

            //       //            text: '  ${widget.snap['description']}',

            //       //          )
            //       //        ]
            //       //      ),
            //       //      ),
            //       //  ),
            //       InkWell(
            //         onTap: () {
            //           print('all comments');
            //           Get.to(CommentScreen(
            //               snap: widget.snap,
            //               imagepath: widget.snap['posturl'] != null
            //                   ? widget.snap['posturl']
            //                   : null,
            //               description: widget.snap['description']));
            //           print('comment');
            //           setState(() {});
            //         },
            //         child: Container(
            //           padding: EdgeInsets.symmetric(vertical: 4),
            //           child: Text(
            //             'View all $commentLenght comments',
            //             style: TextStyle(color: secondaryColor),
            //           ),
            //         ),
            //       ),
            //       Container(
            //         padding: EdgeInsets.symmetric(vertical: 4),
            //         child: Text(
            //           // '22/12/2022',
            //           DateFormat.yMMMd().format(widget.snap['date'].toDate()),
            //           style: TextStyle(color: secondaryColor),
            //         ),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
