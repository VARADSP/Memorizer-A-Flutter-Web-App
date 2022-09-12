import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/screens/home/storyboard/pages/EditProfilePage.dart';
import 'package:firebase_example/screens/home/storyboard/storyboard.dart';
import 'package:firebase_example/screens/home/storyboard/widgets/HeaderWidget.dart';
import 'package:firebase_example/screens/home/storyboard/widgets/PostTileWidget.dart';
import 'package:firebase_example/screens/home/storyboard/widgets/PostWidget.dart';
import 'package:firebase_example/screens/home/storyboard/widgets/ProgressWidget.dart';
import 'package:firebase_example/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;
  ProfilePage(this.userProfileId);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = false;
  final postsReference = FirebaseFirestore.instance.collection('posts');
  int countPost = 0;
  List<Post> postList=[];
  String postOrientation="list";

  void initState(){
    getAllProfilePosts();
  }

  createProfileTopView(){
    return FutureBuilder(
      future:userReference.doc(Constants.myId).get(),
      builder: (context,dataSnapshot){
          if(!dataSnapshot.hasData){
                return circularProgress();
          }
          else{
 //           User user = User.fromDocument(dataSnapshot.data);
            return Padding(
              padding: EdgeInsets.all(17),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person),
                      ),
                      Expanded(
                        flex:1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                createColumns("posts",0),
                                createColumns("followers",0),
                                createColumns("following",0),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                createButton()
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top:13),
                    child: Text(
                      Constants.myName,
                      style: TextStyle(fontSize: 14,color: Colors.white),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top:5),
                    child: Text(
                      Constants.myEmail,
                      style: TextStyle(fontSize: 18,color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          }
      },
    );
  }

  createButton(){
      return createButtonTitleAndFunction(title:"Edit Profile",performFunction:editUserProfile);
  }

  editUserProfile(){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>EditProfilePage(widget.userProfileId)));
  }

  createButtonTitleAndFunction({String title,Function performFunction}){
    return Container(
      padding: EdgeInsets.only(top: 3),
      child: FlatButton(
        onPressed: performFunction,
        child: Container(
          width: 245,
          height: 26,
          child: Text(
              title,
            style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            border:Border.all(color:Colors.grey),
            borderRadius: BorderRadius.circular(6),
          ),

        ),
      ),
    );
  }



  Column createColumns(String title,int count){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.w300),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: header(context,strTitle: "Profile"),
        body: ListView(
          children: [
            createProfileTopView(),
            Divider(),
            createListAndGridPostOrientation(),
            Divider(height: 0.0,),
            displayProfilePost()
          ],
        ),
      );
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
              child: Text("No Posts",style: TextStyle(color:Colors.redAccent,fontSize: 40,fontWeight: FontWeight.bold),),
            )
          ],
        )
      );
    }
    else if(postOrientation=="grid"){
      List<GridTile> gridTileList = [];
      postList.forEach((eachPost){
        gridTileList.add(GridTile(child: PostTile(eachPost),));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTileList,
      );
    }
    else if(postOrientation=="list"){
      return Column(
        children: postList,
      );
    }

  }

  getAllProfilePosts() async{
    setState(() {
      loading = true;
    });
    print(widget.userProfileId);
    QuerySnapshot querySnapshot = await postsReference.doc(widget.userProfileId).collection("usersPosts").orderBy("timestamp",descending: true).get();
    print(querySnapshot.size);
    setState(() {
      loading = false;
      countPost = querySnapshot.docs.length;
      postList = querySnapshot.docs.map((documentSnapshot)=>Post.fromDocument(documentSnapshot)).toList();
    });
  }

  createListAndGridPostOrientation(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: ()=>setOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation=="grid"?Colors.blue:Colors.grey,
        ),
        IconButton(
          onPressed: ()=>setOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation=="list"?Colors.blue:Colors.grey,
        ),
      ],
    );
  }
  setOrientation(String orientation){
    setState(() {
      this.postOrientation = orientation;
    });
  }

}
