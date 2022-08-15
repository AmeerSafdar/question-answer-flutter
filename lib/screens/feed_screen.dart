import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/controller/circularController.dart';
import 'package:instaclone/controller/upload_query_controller.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/resources/auth_methods.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/screens/login_screen.dart';
import 'package:instaclone/screens/upload_query_page.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/utils.dart';
import 'package:instaclone/widget/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with TickerProviderStateMixin {
  TextEditingController _textFieldController = new TextEditingController();
  CircularContrller _circularContrller = Get.put(CircularContrller());
  UserController _userController = Get.put(UserController());
  UploadQuryController uploadQuryController = Get.put(UploadQuryController());
// TabController _tabController ;
  // ignore: avoid_init_to_null
  Uint8List _file = null;
  Uint8List ffile = null;
  var getUserdata = {};
  var categories = [
    '    All    ',
    "Technology",
    "Education",
    "Programming",
    "Shopping",
    "Medical",
    "Freelancing",
    "Other"
  ];

  var _selectedLocation = "Select Category";
  bool search = false;
  getData() async {
    try {
      var usernap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      getUserdata = usernap.data();
      //get post data
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  int selectedindex = 0;

  @override
  initState() {
    super.initState();
    // getData();
    _userController.getUserDetail();
    // _tabController= TabController(length: categories.length, vsync: this);
  }

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
  // List<Tab> _tabs =[
  //      Tab( child: const Text('Tab One')),
  //      Tab( text: 'Technology'),
  //      Tab( text: 'Education'),
  //      Tab( text: 'Tab Four'),
  //      Tab( text: 'Tab Five'),
  //      Tab( text: 'Tab Six'),

  //       "Technology",
  //   "Education",
  //   "Programming",
  //   "Shopping",
  //   "Medical",
  //   "Freelancing",
  //   "Other"
  // ];
  Future<void> addQuery(BuildContext context, String profimage, String uid,
      String username) async {
    print('uid uis $uid');
    setState(() {
      ffile = _file;
    });
    return showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text("hello"),
              AlertDialog(
                title: Center(child: Text('Upload Your Query')),
                content: Column(
                  children: [
                    // Text('data'),
                    ffile != null
                        ? CircleAvatar(
                            child: GestureDetector(
                              onTap: () async {
                                await _selectImage(context);
                              },
                            ),
                            backgroundColor: primaryColor,
                            radius: 30,
                            backgroundImage: MemoryImage(ffile),
                          )
                        : CircleAvatar(
                            child: GestureDetector(
                              onTap: () async {
                                await _selectImage(context);
                              },
                            ),
                            radius: 30,
                            // backgroundColor: primaryColor,
                            backgroundImage:
                                AssetImage("assets/images/question.jpg"),
                          ),
                    // CircleAvatar(
                    //     radius: 30,
                    //     backgroundColor: Colors.blueAccent,
                    //     child: _file==null?
                    //      GestureDetector(
                    //        onTap: ()=>_selectImage (context),
                    //     )
                    //     :
                    //     GestureDetector(
                    //       onTap: ()=>_selectImage (context),
                    //       child: Image.memory(
                    //         _file,
                    //         fit:BoxFit.fitWidth,
                    //         ),
                    //     )
                    //     ,
                    // ),
                    TextField(
                      onSubmitted: (v) {
                        print('onsubmitted $v');
                        print('onsubmitted method called on textfield');
                      },
                      onChanged: (value) {
                        String txt = value;
                        print('onchanegd called :- $txt');
                      },
                      onTap: () {
                        print('textfield tapped');
                      },
                      controller: _textFieldController,
                      decoration:
                          InputDecoration(hintText: "Enter query here "),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                          //  color: primaryColor
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(12)),
                      child: DropdownButton<String>(
                        underline: SizedBox(),
                        isExpanded: true,
                        hint: _selectedLocation == null
                            ? Text('Select Category')
                            : Text(
                                _selectedLocation,
                                style: TextStyle(color: Colors.blue),
                              ),
                        items: categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {
                          setState(() {
                            _selectedLocation = _;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: blueColor,
                      onPressed: () {
                        //  uploadp
                        uploadPostImage(
                            profimage: profimage, username: username, uid: uid);
                        Navigator.pop(context);
                      },
                      child: Text('Submit'),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  void uploadPostImage({String uid, String username, String profimage}) async {
    try {
      _circularContrller.isUploaded.value = true;
      String res = await FireStoreMethods().uploadPost(
        _textFieldController.text,
        uid,
        username,
        profimage,
        file: _file,
      );
      if (res == 'success') {
        _circularContrller.isUploaded.value = false;
        showSnackbar(context, 'Post Uploaded');
        clear();
      } else {
        showSnackbar(context, res);
      }
    } catch (e) {
      showSnackbar(
        context,
        e.toString().replaceAll('-', ' '),
      );
      print(e.toString());
    }
  }

  void clear() {
    setState(() {
      _file = null;
      _textFieldController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    CircularContrller _circontroller = Get.put(CircularContrller());
    var getUserPost = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .snapshots();
    getpost() async {
      super.initState();
      _circontroller.refreshed();
      getUserPost = FirebaseFirestore.instance.collection('posts').orderBy('date',descending: true).snapshots();
      _circontroller.refreshed();
    }

    int selectedindex = 0;

    @override
    // ignore: unused_element
    void initState() async {
      getpost();
      _userController.getUserDetail();
      super.initState();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('add a question by floating button');

          // addQuery(
          //   context,
          //   _userController.userModel.photoUrl,
          //   _userController.userModel.uid,
          //   _userController.userModel.userName,
          //    );
 FirebaseAuth.instance.currentUser !=null?
          Get.to(() => UploadQuryPage())
          :
          showSnackbar(context, 'you must log in ')
          ;
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
         FirebaseAuth.instance.currentUser !=null? IconButton(
              onPressed: () {
                // AuthMethods().signOut(context);
                FirebaseAuth.instance.signOut().then((value) {
                    Get.offAll(LoginScreen());
                  }
                  );
                // setState(() {
                //   search=true;
                // });
              },
              // icon: !search?
              icon: Icon(Icons.exit_to_app
              // :
              // Container(
              //   width: 300,
              //   child: TextFormField(

              //     decoration: new InputDecoration(
              //       suffixIcon: IconButton(
              //         onPressed: (){
              //         setState(() {
              //           search=false;
              //         });
              //       }, icon: Icon(
              //         Icons.cancel
              //       )),
              //         labelText: "Search",
              //         fillColor: Colors.white,
              //         border: new OutlineInputBorder(
              //           // borderRadius: new BorderRadius.circular(25.0),
              //           borderSide: new BorderSide(),
              //         ),
              //         //fillColor: Colors.green
              //       ),
              //   ),
              // )

              ),
          // IconButton(
          //     onPressed: () {
          //       print('added a question ');
          //       print(FirebaseAuth.instance.currentUser.email);
          //       // print( FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).firestore.);
          //       print('users detail ${_userController.userModel.photoUrl}');
          //       print('username ${_userController.userModel.userName}');
          //       print('uid ${_userController.userModel.uid}');
          //       print('photourl ${_userController.userModel.photoUrl}');
          //       print('add a question homapp button');
          //       addQuery(
          //         context,
          //         _userController.userModel.photoUrl,
          //         _userController.userModel.uid,
          //         _userController.userModel.userName,
          //       );
          //     },
          //     icon: Icon(CupertinoIcons.add))
       ):
       SizedBox(height: 0,)
        ],
        backgroundColor: mobileBackgroundColor,
        title: Text('Learning Hub'),
        // Image.asset('assets/images/1.png',color: primaryColor,height: SizeConfig.heightMultiplier*3.5,),
        centerTitle: false,
      ),
      body: Column(
        children: <Widget>[
          Container(
            //color: primaryColor,

            height: 4 * SizeConfig.heightMultiplier,
            child: ListView.builder(
                //shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return categoryHead(index, categories[index]);
                }),
          ),
          Container(
            height: 78 * SizeConfig.heightMultiplier,
            child: GetX<UploadQuryController>(
                init: Get.put(UploadQuryController()),
                builder: (uploadQuryController) {
                  return ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      // shrinkWrap: true,
                      itemCount: uploadQuryController.getpostList.length,
                      itemBuilder: (context, index) {
                        return PostCard(
                          
                          uploadArticle:
                              uploadQuryController.getpostList[index],
                          // snap: snapshot.data.docs[index].data(),
                        );
                      });
                }),
          ),
        ],
      ),
      // StreamBuilder(
      //     stream: FirebaseFirestore.instance
      //         .collection('posts')
      //         .orderBy('date', descending: true)
      //         .snapshots(),
      //     // ignore: missing_return
      //     builder: (context,
      //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      //       // return 0;
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       return
      //     })
      //
    );
  }

  Widget categoryHead(int index, String categoryName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          print('category is $categories');
          uploadQuryController.getPostByCategory(categoryName);
          selectedindex = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin:
            EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
        height: 4 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          color: selectedindex == index ? Colors.amber : Colors.grey.shade300,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            categoryName,
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  color: index == selectedindex ? Colors.white : Colors.amber,
                ),
          ),
        ),
      ),
    );
  }
}
