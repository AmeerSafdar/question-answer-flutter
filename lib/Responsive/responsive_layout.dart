import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/rendering.dart';
import 'package:instaclone/utils/global_variables.dart';

class ResposiveLayout extends StatefulWidget {
  Widget mobileScreenLayout;
  Widget webScreenLayout;
   ResposiveLayout({ Key key, this.mobileScreenLayout, this.webScreenLayout }) : super(key: key);

  @override
  _ResposiveLayoutState createState() => _ResposiveLayoutState();
}

class _ResposiveLayoutState extends State<ResposiveLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
     if (constraints.maxWidth>webSize) {
       return widget.webScreenLayout;
     }
     return widget.mobileScreenLayout; 
    });
  }
}