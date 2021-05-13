import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/screens/home/storyboard/widgets/HeaderWidget.dart';
import 'package:firebase_example/screens/home/storyboard/widgets/PostWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {

  bool loading = false;
  final allPostsReference = FirebaseFirestore.instance.collection('allposts');
  int countPost = 0;
  List<Post> postList=[];


  void initState(){
    super.initState();
 //  getAllProfilePosts();
  }

  @override
  Widget build(context) {

    return Scaffold(
      appBar: header(context,isAppTitle: true,),
      body: StreamBuilder<QuerySnapshot>(
       stream: allPostsReference.orderBy("timestamp",descending: true).snapshots(),
       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong',style: TextStyle(color: Colors.red),));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SpinKitHourGlass(color: Colors.blueAccent));
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new Post(
            postId: document.data()['postId'],
            ownerId: document.data()['ownerId'],
            url: document.data()['url'],
            location: document.data()['location'],
            description: document.data()['description'],
            username: document.data()['username'],
            likes: document.data()['likes'],
            );
          }).toList(),
        );
      },
    )
    );
  }


  getAllProfilePosts() async{
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await allPostsReference.orderBy("timestamp",descending: true).get();
    print(querySnapshot.size);
    setState(() {
      loading = false;
      countPost = querySnapshot.docs.length;
      postList = querySnapshot.docs.map((documentSnapshot)=>Post.fromDocument(documentSnapshot)).toList();
    });
  }

  displayProfilePost(){
    if(loading){
      return Center(child: SpinKitHourGlass(color: Colors.blue));
    }
    if(postList.isEmpty){
      return Container(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: Icon(
                  Icons.photo_library,
                  color: Colors.grey,
                  size: 200,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:20),
                child: Text("No Posts From Any User",style: TextStyle(color:Colors.redAccent,fontSize: 40,fontWeight: FontWeight.bold),),
              )
            ],
          )
      );
    }
    else{
      return Column(
        children: postList,
      );
    }
  }
}
