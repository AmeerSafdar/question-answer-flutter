import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/controller/circularController.dart';
import 'package:instaclone/resources/auth_methods.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/utils.dart';
import 'package:instaclone/widget/textfield_widget.dart';
class ForgotPassword extends StatelessWidget {
const ForgotPassword({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CircularContrller _circularContrller = Get.put(CircularContrller());
    final TextEditingController forgotpasswordcontroller = new TextEditingController();
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flexible(flex:2,),

                  SizedBox(
                    height: SizeConfig.heightMultiplier*15,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/1.png',
                       color: primaryColor,
                       height: SizeConfig.heightMultiplier*20,
                       width: SizeConfig.widthMultiplier*50,
                      ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier*7,
                  ),
                    SizedBox(
                    height: SizeConfig.heightMultiplier*5,
                    child: Text(
                      'Reset your password',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22
                      ),
                      ),
                  ),
                  InputFieldsWidget(
                    controller: forgotpasswordcontroller,
                    hint: 'Email', obscure: false,
                    inputType:TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier*3,
                  ),
                  InkWell(
                    onTap: (){
                   forgotpasswordcontroller.text.isEmpty?showSnackbar(context, 'Please enter your email'):   AuthMethods().resetPassword(forgotpasswordcontroller.text, context);
                      print('send link');
                    },
                    child: Container(
                      height: SizeConfig.heightMultiplier*6,
                      color: blueColor,
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.all(SizeConfig.heightMultiplier*2),
                      child: Obx( () {
                          return _circularContrller.issentPassword.value?FittedBox(child: CircularProgressIndicator(color: primaryColor,),): Text('Reset Password');
                        }
                      )),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier*25,
                  ),
                 
                     Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     GestureDetector(
                       onTap: (){
                       Get.back();
                       },
                       child: Text(
                         'Back to login',
                         style: TextStyle(
                           decoration: TextDecoration.underline,
                           fontSize: 16
                         ),
                         ),
                     ),
                   ],
                     ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}