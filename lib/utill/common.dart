import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



  Widget customTextWidget({required String name,TextStyle? style,}){
    return  Text(
          name,
          style: style
        );
}

  Widget space(double height,{double width = 0}){
    return SizedBox(
    height: height,
    width: width,
    );
  }


