import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  suffixIcon: Icon(Icons.input),
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