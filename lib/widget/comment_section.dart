import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/screens/profile_screen.dart';
import 'package:instaclone/widget/full_screen_image.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CommentCardWidget extends StatefulWidget {
  var snap;
   CommentCardWidget({ Key key, this.snap}) : super(key: key);

  @override
  State<CommentCardWidget> createState() => _CommentCardWidgetState();
}

class _CommentCardWidgetState extends State<CommentCardWidget> {
  UserController _userController=Get.put(UserController());
  QuerySnapshot snapshot;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
    getData();
    
  }
  getData() async{
  var snapshot=await  FirebaseFirestore.instance.collection('posts').doc(widget.snap.data()['postid']).collection('comments').snapshots();
  //  .collection('comments').doc().snapshots();
  // for (var i = 0; i < (snapshot as dynamic).docs.length ; i++) {
  //   print(snapshot.data.docs[i]['text']);
  // }
  print('length of dicumenst comenrs is ${snapshot.length}');
  //  for (int i = 0; i < snapshot.docs.length; i++) {
  //   var a = snapshot.docs[i];
  //   print(a.data());
  // }
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      // padding: EdgeInsets.symmetric(
      //   vertical: 18,
      //   horizontal: 16,

      // ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onLongPress: (){
              Get.to(
                ShowFullImage(
                imgPath:widget.snap.data()['profilePic'] ,
              )
              );
            },
            onTap: (){
              Get.to(
                ProfileScreen(
                  uid:widget.snap.data()['uid'],
                ),
                transition: Transition.cupertinoDialog
              );
            },
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.snap.data()['profilePic']),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.snap.data()['name']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..
                          onTap=(){
                            Get.to(
                ProfileScreen(
                  uid:widget.snap.data()['uid'],
                ),
                transition: Transition.cupertinoDialog
              );
                          }
                        ),
                        TextSpan(
                          text: '   ${widget.snap.data()['text']}',
                        ),
                      ]
                    )),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                      DateFormat.yMMMd().format(
                          widget.snap.data()['datePublished'].toDate(),
                        ),
                      style: TextStyle(fontWeight: FontWeight.w100),),
                    ),
                    widget.snap.data()['commentImg'] !=null 
                    ? 
                    GestureDetector(
                      onTap: (){
                        Get.to(
                          ShowFullImage(
                         imgPath:  widget.snap.data()['commentImg'],
                          ),
                          transition: Transition.fade
                        );
                      },
                      child: Hero(
                        tag: widget.snap.data()['commentImg'] ,
                        child: Container(
                          width: double.infinity,
                          height: SizeConfig.heightMultiplier*20,
                          child: Image.network(
                            widget.snap.data()['commentImg'],
                            fit: BoxFit.cover,
                            ),
                        ),
                      ),
                    )
                    :
                    SizedBox(
                      height: 0,
                    )
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async{
              
              // print((snapshot.data as dynamic)['username']);
              getData();
              // print("${snapshot['username']}");
            await FireStoreMethods().commentsLike(
                commentId:  widget.snap.data()['commmentId'],
                uid:  widget.snap.data()['uid'],
                likes: widget.snap.data()['voteup'],
                postId:widget.snap['uid']

                );
            }, 
            icon: Icon(
              Icons.arrow_circle_up
              )
            )
        ],
      ),
      
    );
  }
}