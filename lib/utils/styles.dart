import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../utils/thems.dart';

class MYText{
  bool arabicLocal() {
    return Intl.getCurrentLocale() == 'ar';
  }
   TextStyle mytextStyle({FontWeight? fontWeight,double? fontSize,Color? color,double? letterSpacing,TextDecoration? decoration ,double? height}){
     if(arabicLocal()){
       return GoogleFonts.cairo(
         fontWeight : fontWeight,
         fontSize: fontSize,
           decoration:decoration,
           height:height,
         color: color
       );

     }else {
       return GoogleFonts.ibmPlexSans(
           fontWeight : fontWeight,
           fontSize: fontSize,
           letterSpacing:letterSpacing,
           height:height,
           decoration:decoration,
           color: color
       );
     }
  }
}