import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/controller/circularController.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({ Key key }) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  UserController _userController =Get.put(UserController());
  CircularContrller _circularContrller=Get.put(CircularContrller());
  TextEditingController _descriptionController =new TextEditingController();
  TextEditingController _categController=new TextEditingController();
  Uint8List _file;


  var categories = [
    "Technology",
    "Education",
    "Programming",
    "Shopping",
    "Medical",
    "Freelancing",
    "Other"
  ];

 var _selectedLocation ="Select Category";

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

  void uploadPostImage({
    String uid,
    String username,
    String profimage
  }) async{
      try{
        _circularContrller.isUploaded.value=true;
        String res= await FireStoreMethods().uploadPost(
        _descriptionController.text, 
        uid, 
        username, 
        profimage,
        file: _file, 
        );
        if (res=='success') {
           _circularContrller.isUploaded.value=false;
          showSnackbar(context, 'Post Uploaded');
          clear();
          
        } else {
          showSnackbar(context, res);
        }
        }
        catch(e){
          showSnackbar(context, e.toString().replaceAll('-', ' '),);
          print(e.toString());
        }
  }

  void clear(){
    setState(() {
      _file=null;
      _descriptionController.text='';
    });
  }
  
  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  void initState() {
    _userController.getUserDetail();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   
    return _file ==null ?
     Center(
   child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
       Text('Click to upload'),
       IconButton(
         onPressed:()=>_selectImage (context), icon: Icon(Icons.upload)),
     ],
   ),
     )
     :
     SafeArea(
      child: Scaffold(
        appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: (){
                  clear();
                  Get.back();
                },
                 icon:Icon(Icons.arrow_back_ios_new_outlined)),
                 title: Text('Post to'),
                 actions: [
                   TextButton(
                     onPressed:()=> uploadPostImage(
                     profimage: _userController.userModel.photoUrl,
                     uid: _userController.userModel.uid,
                     username: _userController.userModel.userName,
                   ), 
                   child: Text('Post'))
                 ]
        ),
        
        body: 
        Padding(
          padding: const EdgeInsets.symmetric(
           horizontal: 18.0
            ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: GetX<UserController>(
                          init: UserController(),
                          builder: (con) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(con.userModel.userName),
                  _circularContrller.isUploaded.value ? 
                  LinearProgressIndicator(): SizedBox(height: 0,),
                  SizedBox(
                    height: 12,
                  ),
                  // Container(),
                  
                    //  CircleAvatar(
                    //    radius: 30,
                    //           backgroundImage:_userController.userModel.photoUrl==null?
                    //           NetworkImage('https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425__340.png')
                    //           : 
                    //           NetworkImage(
                    //             con.userModel.photoUrl
                    //           )),
                        //  SizedBox(
                        //   width: SizeConfig.widthMultiplier*02,),
                        SizedBox(
                          height: 145,
                          width: 245,
                          child: AspectRatio(
                            aspectRatio: 487/551,
                            child: Container(
                                decoration:_file!= null?  BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  alignment: FractionalOffset.topCenter,
                                  image: MemoryImage(_file))
                            ):
                            BoxDecoration(
                             image: DecorationImage(
                                  
                                  fit: BoxFit.cover,
                                  alignment: FractionalOffset.topCenter,
                                  image: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425__340.png'
                                    ))
                            ),
                              child: _file!=null ? 
                              SizedBox(
                                height: 0,
                              ):
                              // MemoryImage(_file)
                              // :
                              GestureDetector(
                                onTap: (){
            
                                },
                                child: FittedBox(
                                  child: Text(
                                    'Click to upload your Query/Image',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                      
                                    ),
                                    ),
                                ),
                              )
                            //  decoration:_file!= null?  BoxDecoration(
                            //     image: DecorationImage(
                            //       fit: BoxFit.fill,
                            //       alignment: FractionalOffset.topCenter,
                            //       image: MemoryImage(_file))
                            // ):
                            // BoxDecoration(
                            //  image: DecorationImage(
                            //       fit: BoxFit.fill,
                            //       alignment: FractionalOffset.topCenter,
                            //       image: NetworkImage('https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425__340.png'))
                            // )
                            ,
                          ),
                        )),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            // borderRadius: BorderRadius.circular(12),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 50
                            ),
                            hintMaxLines: 8,
                            hintText: 'Write a caption...',
                            border: InputBorder.none
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                       Container(
                         padding: EdgeInsets.symmetric(
                           horizontal: 10,
                           vertical: 8
                         ),
                         decoration: BoxDecoration(
                          //  color: primaryColor
                          border: Border.all(
                            color: primaryColor
                          ),
                          borderRadius: BorderRadius.circular(12)
                         ),
                         child: DropdownButton<String>(
                           underline: SizedBox(),
                           isExpanded: true,
                            hint: _selectedLocation == null
            ? 
            Text('Select Category')
            : Text(
                _selectedLocation,
                style: TextStyle(color: Colors.blue),
              ),
                          items:categories.map((String value) {
                                   return DropdownMenuItem<String>(
                                    value: value,
                                   child: Text(value),
                                      );
                                      }).toList(),
                                     onChanged: (_) {
                                     setState(() {
                                            _selectedLocation=_;
                                                    });
                                                     },
                                                    ),
                       ),
                         SizedBox(
                          height: 25,
                        ),
                      
                             Container(
                               height: 50,
                               child: MaterialButton(
                                color: blueColor,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(12)
                               ),
                                minWidth: double.infinity,
                                 onPressed:(){ 
                                    // _circularContrller.isUploaded.value=true;
                                uploadPostImage(
                               profimage: _userController.userModel.photoUrl,
                               uid: _userController.userModel.uid,
                               username: _userController.userModel.userName,
                                               );
                                               },
                                child:Obx(()=> _circularContrller.isUploaded.value?FittedBox(child: CircularProgressIndicator(color: primaryColor,)): Text('Login')),
                                ),
                             ),
                          
                        
                        // SizedBox(
                        //   height: 45,
                        //   width: 45,
                        //   child: AspectRatio(
                        //     aspectRatio: 487/551,
                        //     child: Container(
                        //      decoration:_file!= null?  BoxDecoration(
                        //         image: DecorationImage(
                        //           fit: BoxFit.fill,
                        //           alignment: FractionalOffset.topCenter,
                        //           image: MemoryImage(_file))
                        //     ):
                        //     BoxDecoration(
                        //      image: DecorationImage(
                        //           fit: BoxFit.fill,
                        //           alignment: FractionalOffset.topCenter,
                        //           image: NetworkImage('https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425__340.png'))
                        //     )
                        //     ,
                        //   ),
                        // ))
                  // Padding(
                  //   padding:  EdgeInsets.symmetric(horizontal:SizeConfig.widthMultiplier*5,vertical: SizeConfig.heightMultiplier*2),
                  //   child: 
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       CircleAvatar(
                  //             backgroundImage:_userController.userModel.photoUrl==null?
                  //             NetworkImage('https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425__340.png')
                  //             : NetworkImage(
                  //               con.userModel.photoUrl
                  //             )),
                  //        SizedBox(
                  //         width: SizeConfig.widthMultiplier*02,),
                  //       Expanded(
                  //         child: TextFormField(
                  //           controller: _descriptionController,
                  //           decoration: InputDecoration(
                  //             hintMaxLines: 8,
                  //             hintText: 'Write a caption...',
                  //             border: InputBorder.none
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 45,
                  //         width: 45,
                  //         child: AspectRatio(
                  //           aspectRatio: 487/551,
                  //           child: Container(
                  //            decoration:_file!= null?  BoxDecoration(
                  //               image: DecorationImage(
                  //                 fit: BoxFit.fill,
                  //                 alignment: FractionalOffset.topCenter,
                  //                 image: MemoryImage(_file))
                  //           ):
                  //           BoxDecoration(
                  //            image: DecorationImage(
                  //                 fit: BoxFit.fill,
                  //                 alignment: FractionalOffset.topCenter,
                  //                 image: NetworkImage('https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425__340.png'))
                  //           )
                  //           ,
                  //         ),
                  //       ))
                  //     ],
                  //   ),
                  // )
                ],
              );}),
            ),
          ),
        )
      ),
    );
  }
}