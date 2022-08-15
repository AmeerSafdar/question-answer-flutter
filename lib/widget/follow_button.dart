import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclone/Responsive/SizeConfig.dart';
import 'package:instaclone/controller/circularController.dart';
import 'package:instaclone/utils/colors.dart';

class FollowButton extends StatelessWidget {
  final VoidCallback prees;
  final String btnTxt;
  final Color bgColor;
  final Color textColor;
  final Color borderColors;
   FollowButton({ Key key,this.prees,this.btnTxt,this.bgColor,this.textColor,this.borderColors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CircularContrller con=Get.put(CircularContrller());
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: TextButton(
        onPressed:prees, 
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColors),
          borderRadius: BorderRadius.circular(5)

        ),
        height: SizeConfig.heightMultiplier*4,
        width:SizeConfig.widthMultiplier*70 ,
        child: 
        Obx(()=>con.isUploaded.value? FittedBox(child: CircularProgressIndicator(color: primaryColor,)) : Text(btnTxt,style: TextStyle(color: textColor,fontWeight: FontWeight.w600))
        // Text(btnTxt,style: TextStyle(color: textColor,fontWeight: FontWeight.w600),))
      )
    )));
    
    
  }
}