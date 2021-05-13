import 'package:firebase_example/screens/home/storyboard/widgets/CImageWidget.dart';
import 'package:firebase_example/screens/home/storyboard/widgets/PostWidget.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.network(post.url),
    );
  }
}
