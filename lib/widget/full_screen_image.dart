import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowFullImage extends StatelessWidget {
  String imgPath;
  ShowFullImage({ Key key, this.imgPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Hero(
            tag: ''+imgPath,
            child:PhotoView(
              imageProvider:  NetworkImage(imgPath)
            )
            ),
        )
      ),
    );
  }
}