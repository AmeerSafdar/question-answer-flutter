import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputFieldsWidget extends StatelessWidget {
  String hint;
  TextEditingController controller;
  TextInputType inputType;
  String initialValue;
  bool obscure;
  InputFieldsWidget({ Key key , this.hint, this.controller, this.inputType, this.obscure=false,initialValue='' }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final iBorder= OutlineInputBorder(
         borderSide: Divider.createBorderSide(context)
       );

    return TextFormField(
      initialValue: initialValue,
     controller: controller,
     decoration: InputDecoration(
       hintText: hint,
       border:iBorder,
       focusedBorder: iBorder,
       enabledBorder: iBorder,
       contentPadding: EdgeInsets.all(8),
       filled: true,
     ),
     keyboardType: inputType,
     obscureText: obscure,
     
    );
  }
}