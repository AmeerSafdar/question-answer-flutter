import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/controller/circularController.dart';
import 'package:instaclone/controller/upload_query_controller.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/resources/auth_methods.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/widget/textfield_widget.dart';

class AddArticles extends StatefulWidget {
  const AddArticles({Key key}) : super(key: key);

  @override
  State<AddArticles> createState() => _AddArticlesState();
}

class _AddArticlesState extends State<AddArticles> {
  UserController _userController = Get.put(UserController());
  UploadQuryController uploadQuryController = Get.put(UploadQuryController());
  TextEditingController desc = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userController.getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add article'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: desc,
                    keyboardType: TextInputType.multiline,
                    maxLines: 20,
                    decoration: InputDecoration(
                      hintText: 'Write Article',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // InputFieldsWidget(),
                  // SizedBox(
                  //   height: 10,
                  // ),

                  // InputFieldsWidget(),
                  // SizedBox(
                  //   height: 10,
                  // ),

                  MaterialButton(
                    color: blueColor,
                    minWidth: double.infinity,
                    onPressed: () async {
                      uploadQuryController
                          .addArtical(description: desc.text)
                          .then((value) {
                        desc.clear();
                        Get.back();
                        //    Get.back();
                      });
                      // await FireStoreMethods().addArticles(
                      //     desc.text,
                      //     _userController.userModel.uid,
                      //     _userController.userModel.userName
                      //     );
                      //     desc.text='';
                      //     Get.back();
                    },
                    child: Text('Upload Article'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
