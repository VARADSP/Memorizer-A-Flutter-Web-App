import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar header(context,{bool isAppTitle=false,String strTitle,disappearedBackButton=false}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    automaticallyImplyLeading: disappearedBackButton?false:true,
    title: Text(
      isAppTitle?"StoryBoard":strTitle,
      style: isAppTitle?GoogleFonts.signika(
          color: Colors.white,
          letterSpacing: 5,
          fontSize: 45
      ):GoogleFonts.lato(
          color: Colors.white,
          letterSpacing: 5,
          fontSize: 22
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Colors.black,
  );
}
