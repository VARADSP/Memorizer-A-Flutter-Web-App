import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){

  return AppBar(
    title: Row(
      children: [
        Icon(Icons.memory,color: Colors.pink,size: 30,),
        Text('Memorizer',style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold),),
      ],
    ),
  );
}

const emailTextInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  suffixIcon: Icon(Icons.email),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.grey,
        width: 2.0
    ),
  ),
  focusedBorder:OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.pink,
        width: 2.0
    ),
  ),
);

const passwordTextInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  suffixIcon: Icon(Icons.enhanced_encryption),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.grey,
        width: 2.0
    ),
  ),
  focusedBorder:OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.pink,
        width: 2.0
    ),
  ),
);

const usernameTextInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  suffixIcon: Icon(Icons.person),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.grey,
        width: 2.0
    ),
  ),
  focusedBorder:OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.pink,
        width: 2.0
    ),
  ),
);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  suffixIcon: Icon(Icons.text_fields),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.grey,
        width: 2.0
    ),
  ),
  focusedBorder:OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.pink,
        width: 2.0
    ),
  ),
);

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
      )
  );
}

TextStyle simpleTextFieldStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 16
  );
}

TextStyle mediumTextStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 17
  );
}