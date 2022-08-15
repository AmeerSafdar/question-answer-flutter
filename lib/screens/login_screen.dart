import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/Responsive/mobile_screen.dart';
import 'package:instaclone/Responsive/responsive_layout.dart';
import 'package:instaclone/Responsive/web_screen.dart';
import 'package:instaclone/controller/circularController.dart';
import 'package:instaclone/resources/auth_methods.dart';
import 'package:instaclone/screens/feed_screen.dart';
import 'package:instaclone/screens/forgot_password.dart';
import 'package:instaclone/screens/signup_screen.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/utils.dart';
import 'package:instaclone/widget/textfield_widget.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  CircularContrller _circularContrller = Get.put(CircularContrller());
  TextEditingController emailcontroller=new TextEditingController();
  TextEditingController passWordController=new TextEditingController();
  
  bool isLoading=false;
  @override
  void dispose() {
    emailcontroller.dispose();
    passWordController.dispose();
  //  FirebaseAuth.instance.signOut();
    super.dispose();
  }

 void loginUser() async{
    _circularContrller.isLoading.value = true;

   String res=await
               AuthMethods().loginuser(
                 email: emailcontroller.text, 
                 password: passWordController.text).
                 then((value) {
                 _circularContrller.isLoading.value = false;
                  return value;

               });
   if (res=='Log in Successfull') {
    Get.offAll(
      ResposiveLayout(mobileScreenLayout: MobileScreen(), webScreenLayout: WebScreenLayout())
    );
   } 
   if (res=='unknown') {
      showSnackbar(context, "Please enter correct information")  ;   
   }
   else {
     showSnackbar(context, res.toString().replaceAll('-', ' '));
   }
  }
  
  @override
  Widget build(BuildContext context) {
   // print('User')
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        actions: [
          TextButton(
            onPressed: (){
              Get.to(FeedScreen());
            }, 
            child: Text('Skip'))
        ],
      ),
      body:SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child:SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier*9,
                ),
                // SvgPicture.asset(
                // 'assets/images/ic_instagram.svg',
                // color: primaryColor,
                // height: SizeConfig.heightMultiplier*10,
                // width: SizeConfig.widthMultiplier*5,
                // ),
               Image.asset(
                 'assets/images/1.png',
                 color: primaryColor,
                height: SizeConfig.heightMultiplier*20,
                width: SizeConfig.widthMultiplier*50,
                 ),
                SizedBox(
                  height: SizeConfig.heightMultiplier*4,
                ),
                InputFieldsWidget(
                hint: 'Email', 
                controller: emailcontroller, 
                inputType: TextInputType.emailAddress),
                SizedBox(
                  height: SizeConfig.heightMultiplier*2,
                ),
                InputFieldsWidget(
                  hint: 'Password', 
                  controller: passWordController, 
                  inputType: TextInputType.text,
                  obscure: true,
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier*3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.to(
                            ForgotPassword(),
                            transition:Transition.fadeIn 
                          );
                        },
                        child: Text(
                          'forgot password?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16
                          ),
                          ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier*2.5,
                  ),
                  InkWell(
                    onTap: loginUser,
                    child: Container(
                     height: SizeConfig.heightMultiplier*6,
                      color: blueColor,
                      alignment: Alignment.center,
                      width: double.infinity,
                      child:Obx(()=> _circularContrller.isLoading.value? FittedBox(child:CircularProgressIndicator(color: primaryColor,)): Text('Login'),),
                     
                    ),
                  ),
                  
                  SizedBox(
                    height: SizeConfig.heightMultiplier*3,
                  ),
                  Text('or'),
                 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: primaryColor,)),
                        Text('  Social Login  '),
                        Expanded(child: Divider(color: primaryColor,)),
                      ],
                    ),
                  ),
                   SizedBox(
                    height: SizeConfig.heightMultiplier*2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SignInButton(
                                Buttons.Facebook,
                                mini: true,
                                // shape: BorderRadius.circular(radius),
                                onPressed: ()  {
                                      //  await AuthMethods().fbLogin(context);
                                                    },
                                                ),
                      // InkWell(
                      //   onTap: () async{
                      //    await AuthMethods().fbLogin(context);
                         
                      // },
                      //   child: Container(
                      //     // height: 100,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //         // color: blueColor,
                      //     ),
                      //     child:Icon(Icons.facebook,size: 40,)
                        
                      //   ),
                      // ),
                      SizedBox(
                        width: 20,
                      ),
                      // SignInButton(
                      //             Buttons.GoogleDark,
                      //             mini: true,
                      //             onPressed: ()  async{
                      //                 await AuthMethods().signInwithGoogle(context);
                      //                       },
                      //                   )
                         InkWell(
                        onTap: () {
                        // await AuthMethods().signInwithGoogle(context);
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration:BoxDecoration(
                            
                          // color: blueColor,
                          ),
                          padding: EdgeInsets.all(10),
                          child: Image.asset('assets/images/google.jpg')
                        ),

                        ),
                    ],
                  ),
                  
                  //  InkWell(
                  //   onTap: loginUser,
                  //   child: Container(
                  //     width: double.infinity,
                  //     padding: EdgeInsets.all(SizeConfig.heightMultiplier*2),
                  //     alignment: Alignment.center,
                  //     child:Obx(()=> _circularContrller.isLoading.value? Center(child: CircularProgressIndicator(color: primaryColor,),): Text('Facebook Login'),),
                  //     color: blueColor,
                  //   ),
                  // ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier*5,
                  ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Container(
                         child: Text('Don\'t have an account? '),
                       ),
                       GestureDetector(
                         onTap: (){
                           Get.offAll(
                             SignupScreen(),
                             transition: Transition.rightToLeftWithFade
                             );
                         },
                         child: Container(
                           child: Text(
                             ' Sign Up',
                             style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 14
                             ),
                             ),
                         ),
                       )
                  
                     ],
                   )
                  
              ],
            ),
          )
        )
      ),
    );
  }
}