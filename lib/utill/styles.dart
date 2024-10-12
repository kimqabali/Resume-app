import 'package:flutter/material.dart';
import 'package:flutter_application_1/utill/color_resources.dart';


TextStyle style48Bold({Color? color}) {
  return TextStyle(
    fontFamily:  'SF-Pro-Bold',
    color:  color ?? ColorResources.grey33,
    fontSize: 48
  );
}
TextStyle style24Bold({Color? color}) => style48Bold().copyWith(fontSize: 24,color:  color ?? ColorResources.grey33,);
TextStyle style22Bold({Color? color}) => style48Bold().copyWith(fontSize: 22,color:  color ?? ColorResources.grey33,);
TextStyle style20Bold({Color? color}) => style48Bold().copyWith(fontSize: 20,color:  color ?? ColorResources.grey33,);
TextStyle style18Bold({Color? color}) => style48Bold().copyWith(fontSize: 18,color:  color ?? ColorResources.grey33,);
TextStyle style16Bold({Color? color}) => style48Bold().copyWith(fontSize: 16,color:  color ?? ColorResources.grey33,);
TextStyle style14Bold({Color? color}) => style48Bold().copyWith(fontSize: 14,color:  color ?? ColorResources.grey33,);
TextStyle style12Bold({Color? color}) => style48Bold().copyWith(fontSize: 12,color:  color ?? ColorResources.grey33,);



TextStyle style18Regular({Color? color}) {
  return  TextStyle(
    fontFamily: 'SF-Pro-Regular',
    color: color ??ColorResources.grey33,
    fontSize: 18
  );
}
TextStyle style16Regular({Color? color}) => style18Regular().copyWith(fontSize: 16,color: color ??ColorResources.grey33);
TextStyle style14Regular({Color? color}) => style18Regular().copyWith(fontSize: 14,color: color ??ColorResources.grey33);
TextStyle style12Regular({Color? color}) => style18Regular().copyWith(fontSize: 12,color: color ??ColorResources.grey33);
TextStyle style10Regular({Color? color}) => style18Regular().copyWith(fontSize: 10,color: color ??ColorResources.grey33);


