import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/resources/auth_methods.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/screens/feed_screen.dart';
import 'package:instaclone/screens/profile_screen.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/utils.dart';
import 'package:instaclone/widget/follow_button.dart';
import 'package:instaclone/widget/textfield_widget.dart';
class UserProfileWidget extends StatefulWidget {
 String username;
 String email;
 String bio;
 String photoUrl;
 String uid;
   UserProfileWidget({ Key key , this.username,this.email,this.bio,this.photoUrl,this.uid}) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {

String name , email, bio;
    @override
  void initState() {
    super.initState();
    _userController.getUserDetail();
    name= widget.username;
    email= widget.email;
    bio=widget.bio;

}


  UserController _userController = Get.put(UserController());
  // TextEditingController _namecontroller=new TextEditingController(text:name);
  // TextEditingController _emailcontroller=new TextEditingController();
  // // TextEditingController _username=new TextEditingController();
  // TextEditingController _bioController=new TextEditingController();

 Uint8List _file=null;
  String res='';
 Future<void> _selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: Text('Create a post'),
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: SimpleDialogOption(
              child: Text('Take a photo'),
              onPressed: () async{
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file=file;
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
              onPressed: () async{
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file=file;
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
              onPressed: () async{
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
    TextEditingController _namecontroller=new TextEditingController(text:this.name);
  TextEditingController _emailcontroller=new TextEditingController(text: this.email);
  // TextEditingController _username=new TextEditingController();
  TextEditingController _bioController=new TextEditingController(text:this.bio);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
        
              Container(
                
                  // onTap: () async{
                  //         print('objectsabc');
                  //         await _selectImage(context).then((value) async {
                  //           String res= await FireStoreMethods().updateProfilepic(_file, 'profilePictures');
                  //           print(res);
                  //         });
                  //         // StorageMethods().uploadImagetoStorage('profilePictures',_file,false);
                  //         print('1');
                  //         Get.back();
                  //       },
                   child:   _file !=null?
                      // CircleAvatar(
                      //   radius: SizeConfig.heightMultiplier*8,
                      //   backgroundImage: MemoryImage(_file),
                      // )
                       CircleAvatar(
                          radius: 58,
                        backgroundImage: MemoryImage(_file),
                        child: Stack(
                               children: [
                                         Align(
                                            alignment: Alignment.bottomRight,
                                            child: CircleAvatar(
                                            radius: 18,
                                             backgroundColor: Colors.white70,
                                           child: IconButton(
                                             onPressed: ()async{
                                                print('objectsabc');
                                                await _selectImage(context);
                                             }, 
                                             icon: Icon(
                                             CupertinoIcons.camera),)
                                            // Get.back();
                                           
                                            ),
                                           ),
                                          ]
                                        ),
                                  )
                             :
                      CircleAvatar(
                          radius: 58,
                        backgroundImage: NetworkImage('${widget.photoUrl}'),
                        child: Stack(
                               children: [
                                         Align(
                                            alignment: Alignment.bottomRight,
                                            child: CircleAvatar(
                                            radius: 18,
                                             backgroundColor: Colors.white70,
                                           child: IconButton(
                                             onPressed: () async{
                                                print('objectsabc');
                                                await _selectImage(context);
                          // StorageMethods().uploadImagetoStorage('profilePictures',_file,false);
                                            print('1');
                                            // Get.back();
                                             },
                                             icon:Icon(CupertinoIcons.camera)),
                                            ),
       ),
    ]
  ),
)
                      // CircleAvatar(
                      //   radius: SizeConfig.heightMultiplier*8,
                      //   backgroundImage: NetworkImage('${widget.photoUrl}'),
                      //   backgroundColor: blueColor,
                      // )
                  //  CircleAvatar(
                  //   radius: 50.0,
                  //   backgroundImage:
                  //       NetworkImage('${widget.photoUrl}'),
                  //   backgroundColor: Colors.transparent,
                  // ),
              ),
        
                SizedBox(
                  height: 20,
                ),
        
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: InputFieldsWidget(
                  hint: 'Name',
                  controller: _namecontroller,
                  initialValue:_userController.userModel.userName
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: InputFieldsWidget(
                  hint: 'Email',
                  initialValue:_userController.userModel.email,
                  controller: _emailcontroller,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top:8.0),
              //   child: InputFieldsWidget(
              //     hint: 'User name',
              //     controller: _username,
              //     initialValue:_userController.userModel.userName
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: InputFieldsWidget(
                  hint: 'Bio',
                  controller: _bioController,
                  initialValue:_userController.userModel.bio
                ),
              ),
               Container(
                 width: double.infinity,
                 child: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: FollowButton(
                    borderColors: blueColor,
                    textColor: Colors.white,
                    bgColor: blueColor, 
                    btnTxt: 'Update Profile',
                    prees: () async { 
                      String res='';
                      print('update button call');
                      res= await AuthMethods().updateProfile(
                      bio: _bioController.text,
                      cntxt: context,
                      email: _emailcontroller.text,
                      userName: _namecontroller.text,
                      uid:widget.uid,
                      file: _file
                    );
                    // ScaffoldMessenger(child: )
                    showSnackbar(context, '$res ');
                    // Get.to(ProfileScreen(uid: widget.uid,));
                    Get.back();
                    },
                    )
        
              ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}