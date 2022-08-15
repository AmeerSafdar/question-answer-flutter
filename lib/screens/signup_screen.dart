import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/Responsive/mobile_screen.dart';
import 'package:instaclone/Responsive/responsive_layout.dart';
import 'package:instaclone/Responsive/web_screen.dart';
import 'package:instaclone/controller/circularController.dart';
import 'package:instaclone/controller/user_controller.dart';
import 'package:instaclone/resources/auth_methods.dart';
import 'package:instaclone/screens/login_screen.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/utils.dart';
import 'package:instaclone/widget/textfield_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  CircularContrller _circularContrller = Get.put(CircularContrller());
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passWordController = new TextEditingController();

  TextEditingController bioController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  Uint8List image;
  bool isLoading = false;
  UserController userController = Get.put(UserController());

  @override
  void dispose() {
    emailcontroller.dispose();
    passWordController.dispose();
    bioController.dispose();

    userNameController.dispose();
    super.dispose();
  }

  selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      if (img.isNotEmpty) {
        image = img;
      }
    });
  }

  signpUser() async {
    _circularContrller.isLoading.value = true;
    String res = await AuthMethods().signupUser(
        email: emailcontroller.text,
        password: passWordController.text,
        userName: userNameController.text,
        bio: bioController.text,
        file: image,
        cntxt: context);
    _circularContrller.isLoading.value = false;
    print(res);
    if (res == 'Successfully sign up ') {
      showSnackbar(context, 'Account Created successfully');
      Get.offAll(ResposiveLayout(
          mobileScreenLayout: MobileScreen(),
          webScreenLayout: WebScreenLayout()));
    } else {
      showSnackbar(context, res.replaceAll('-', ' '));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 8,
                    ),
                    Image.asset(
                      'assets/images/1.png',
                      color: primaryColor,
                      height: SizeConfig.heightMultiplier * 10,
                      width: SizeConfig.widthMultiplier * 40,
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 5,
                    ),
                    Stack(
                      children: [
                        image != null
                            ? CircleAvatar(
                                radius: SizeConfig.heightMultiplier * 8,
                                backgroundImage: MemoryImage(image),
                              )
                            : CircleAvatar(
                                radius: SizeConfig.heightMultiplier * 8,
                                backgroundImage: NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8TeQ5iojLROQXom0AApSQbIamNDJRFDYgjw&usqp=CAU'),
                              ),
                        Positioned(
                          top: SizeConfig.heightMultiplier * 9,
                          right: -SizeConfig.heightMultiplier * 1,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: Icon(
                                Icons.add_a_photo,
                                color: Colors.black,
                                size: SizeConfig.heightMultiplier * 3,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 3,
                    ),
                    InputFieldsWidget(
                        hint: 'User Name',
                        controller: userNameController,
                        inputType: TextInputType.text),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                    InputFieldsWidget(
                        hint: 'Bio',
                        controller: bioController,
                        inputType: TextInputType.text),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                    InputFieldsWidget(
                        hint: 'Email',
                        controller: emailcontroller,
                        inputType: TextInputType.emailAddress),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 2,
                    ),
                    InputFieldsWidget(
                      hint: 'Password',
                      controller: passWordController,
                      inputType: TextInputType.text,
                      obscure: true,
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 3,
                    ),
                    InkWell(
                      onTap: () {
                        if (emailcontroller.text.isNotEmpty &&
                            passWordController.text.isNotEmpty &&
                            userNameController.text.isNotEmpty &&
                            bioController.text.isNotEmpty) {
                          if (image == null) {
                            Get.snackbar('Photo not Slected',
                                'Please Please Select the photo first');
                          } else {
                            userController.isSignUpLoading.value = true;
                            userController.creatAccountWithEmail(
                                emailcontroller.text,
                                passWordController.text,
                                userNameController.text,
                                bioController.text,
                                image);
                          }
                        } else {
                          Get.snackbar('Invalid Argument',
                              'Please fill all medatory filleds');
                        }
                      },
                      child: Container(
                        height: SizeConfig.heightMultiplier * 6,
                        color: blueColor,
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Obx(
                          () => userController.isSignUpLoading.value
                              ? FittedBox(
                                  child: CircularProgressIndicator(
                                  color: primaryColor,
                                ))
                              : Text('Sign up'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text('Already have an account? '),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offAll(LoginScreen(),
                                transition: Transition.leftToRightWithFade);
                          },
                          child: Container(
                            child: Text(
                              ' Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ))),
    );
  }
}
