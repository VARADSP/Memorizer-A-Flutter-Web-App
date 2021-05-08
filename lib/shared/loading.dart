import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[100],
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.brown,
          size: 50.0,
        ),
      ),
    );
  }
}

class LoadingForInputForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitHourGlass(
        color: Colors.blue,
        size: 50.0,
      ),
    );
  }
}

class LoadingForInnerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff1F1F1F),
      child: Center(
        child: SpinKitFadingCircle(
          color: Colors.pink,
          size: 50.0,
        ),
      ),
    );
  }
}
