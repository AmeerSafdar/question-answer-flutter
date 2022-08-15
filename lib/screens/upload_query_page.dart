import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/controller/upload_query_controller.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/utils.dart';

class UploadQuryPage extends StatefulWidget {
  const UploadQuryPage({Key key}) : super(key: key);

  @override
  State<UploadQuryPage> createState() => _UploadQuryPageState();
}

class _UploadQuryPageState extends State<UploadQuryPage> {
  TextEditingController _textFieldController = new TextEditingController();
  UploadQuryController uploadQuryController = Get.put(UploadQuryController());
  UserController userController = Get.put(UserController());

  Uint8List _file = null;
  Uint8List ffile = null;
  var categories = [
    "Technology",
    "Education",
    "Programming",
    "Shopping",
    "Medical",
    "Freelancing",
    "Other"
  ];

  var _selectedLocation = "Select Category";

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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Upload query'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    // Text('data'),
                    _file != null
                        ? CircleAvatar(
                            child: GestureDetector(
                              onTap: () async {
                                await _selectImage(context);
                              },
                            ),
                            backgroundColor: primaryColor,
                            radius: 100,
                            backgroundImage: MemoryImage(_file),
                          )
                        : 
                        CircleAvatar(
                            child: GestureDetector(
                              onTap: () async {
                                await _selectImage(context);
                              },
                            ),
                            radius: 100,
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
                    SizedBox(
                      height: 10 * SizeConfig.heightMultiplier,
                    ),
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
                      decoration: InputDecoration(hintText: "Enter query here "),
                    ),
                    SizedBox(height: 5 * SizeConfig.heightMultiplier),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                          //  color: primaryColor
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(12)),
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
                    Obx(
                      () => uploadQuryController.isPostUpload.value
                          ? CircularProgressIndicator()
                          : MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              color: blueColor,
                              onPressed: () {
                                if (_textFieldController.text.isEmpty) {
                                  Get.snackbar('Query not entered',
                                      'Please enter query first');
                                } else if (_selectedLocation ==
                                    'Select Category') {
                                  Get.snackbar('Category not selected',
                                      'Please select category first');
                                } else {
                                  uploadQuryController.isPostUpload.value = true;

                                  uploadQuryController
                                      .uploadQuery(
                                          _textFieldController.text,
                                          userController.auth.currentUser.uid,
                                          userController.getuser.userName,
                                          _file,
                                          userController.getuser.photoUrl,
                                          _selectedLocation)
                                      .then((value) {
                                        showSnackbar(context, "Success");
                                    _textFieldController.clear();
                                  });
                                }
                                //  uploadp
                                //   uploadPostImage(
                                //   profimage: profimage,
                                //   username:username,
                                //   uid:  uid
                                //  );
                                //Navigator.pop(context);
                              },
                              child: Text('Submit'),
                            ),
                    )
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    ));
  }
}
