import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/screens/home/storyboard/storyboard.dart';
import 'package:firebase_example/screens/home/storyboard/widgets/ProgressWidget.dart';
import 'package:firebase_example/shared/constants.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  //final String timestamp;
  final dynamic likes;
  final String username;
  final String description;
  final String location;
  final String url;

  Post({
    this.postId,
  this.ownerId,
//    this.timestamp,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url
  });

  factory Post.fromDocument(DocumentSnapshot documentSnapshot){
    return Post(
      postId: documentSnapshot["postId"],
      ownerId: documentSnapshot["ownerId"],
      likes: documentSnapshot["likes"],
      username: documentSnapshot["username"],
      description: documentSnapshot["description"],
      location: documentSnapshot["location"],
      url: documentSnapshot["url"],
    );
  }

  int getTotalNumberOfLikes(likes){
    if(likes==null){
        return 0;
    }
    int counter = 0;
    likes.values.forEach((eachValue){
      if(eachValue == true){
        counter = counter+1;
      }
    });
    return counter;
  }

  @override
  _PostState createState() => _PostState(
      postId:this.postId,
      ownerId:this.ownerId,
//    this.timestamp,
      likes:this.likes,
      username:this.username,
      description:this.description,
      location:this.location,
      url:this.url,
    likeCount:getTotalNumberOfLikes(this.likes)
  );
}



class _PostState extends State<Post> {

  final String postId;
  final String ownerId;
  //final String timestamp;
  final dynamic likes;
  final String username;
  final String description;
  final String location;
  final String url;
  int likeCount;
  bool isLiked=false;
  bool showHeart = false;
  final String currentOnlineUserId = Constants.myId;

  _PostState({
    this.postId,
    this.ownerId,
//    this.timestamp,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
    this.likeCount
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          createPostHead(),
          createPostPicture(),
          createPostFooter()
        ],
      ),
    );
  }

  createPostHead(){
    return FutureBuilder(
      future: userReference.doc(Constants.myId).get(),
      builder:(context,dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }

   //     User user = User.fromDocument(dataSnapshot.data);
        bool isPostOwner = currentOnlineUserId == ownerId;

        return ListTile(
          leading:CircleAvatar(child: Icon(Icons.person),backgroundColor: Colors.grey,),
          title: GestureDetector(
            onTap: ()=>print("show profile"),
            child: Text(
              username,
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text(location,style: TextStyle(color: Colors.white),),
          trailing: isPostOwner?IconButton(
            icon: Icon(Icons.more_vert,color: Colors.white,),
            onPressed: ()=>print("deleted"),
          ):Text(""),
        );
      }
    );
  }

  createPostPicture(){
    return GestureDetector(
      onDoubleTap: ()=>print("post liked"),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(url,height: 300,),
        ],
      ),
    );
  }

  createPostFooter(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top:40, left:20,),),
            GestureDetector(
              onTap: ()=>print("Liked post"),
              child: Icon(
                isLiked?Icons.favorite:Icons.favorite_border,
                size: 20,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right:20,),),
            GestureDetector(
              onTap: ()=>print("show comments"),
              child: Icon(Icons.chat_bubble_outline,size: 20,color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "$likeCount likes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text("$username  ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            Expanded(
              child: Text(description,style: TextStyle(color: Colors.white),),
            )
          ],
        )
      ],
    );
  }
}
