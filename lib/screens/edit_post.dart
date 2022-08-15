import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/screens/root_widget.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/utils.dart';
import 'package:instaclone/widget/follow_button.dart';
import 'package:instaclone/widget/textfield_widget.dart';
class EditPost extends StatefulWidget {
  String description;
  String posturl;
  String postId;
  EditPost({ Key key,this.description,this.posturl,this.postId }) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {

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
    TextEditingController cont=new TextEditingController(text: widget.description);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
             horizontal: 20.0
              ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  SizedBox(height: SizeConfig.heightMultiplier*6,),
                widget.posturl !=null || _file !=null?  
                Column(
                  children: [
                    
                  _file !=null ?
                    Container(
                      width: double.infinity,
                      height: SizeConfig.heightMultiplier * 47,
                        child:Image(image: MemoryImage(_file))
                      )
                      :
                    Container(
                      
                      height: SizeConfig.heightMultiplier * 47,
                        child: Image(image: NetworkImage(widget.posturl)),
                      )
                      ,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async{
                              await _selectImage(context);
                            }, 
                            child: Text('Change photo'))
                        ],
                      )
                  ],
                )
                  :
                  SizedBox(
                    height: 5,
                    child: FollowButton(
                      btnTxt: 'Add a photo of Error',
                      bgColor: blueColor,
                      borderColors: blueColor,
                      textColor: primaryColor,
                      prees: () => print('edited'),
                    ),
                  )
                  ,
                  SizedBox(height: SizeConfig.heightMultiplier*4,),
                  InputFieldsWidget(
                    hint: 'Post description',
                    initialValue: widget.description,
                    controller: cont,
                    inputType: TextInputType.text,
                    obscure: false,

                  ),
                  SizedBox(height: 5,),


                 
                  FollowButton(
                    prees: () async{
                      print('hello');
                    
                     res=await FireStoreMethods().updatePost(
                        cont.text, 
                        widget.postId, 
                        file: _file,
                        photo: widget.posturl
                        );
                        print('res');
                        showSnackbar(context,res);
                        Get.offAll(RootWidget());
                    },
                    btnTxt: 'Update post',
                    bgColor: blueColor,
                    borderColors: blueColor,
                    textColor: primaryColor,
                  ),
                  SizedBox(height:5)
              ],
            ),
          ),
        ),
      ), 
    );
  }
}