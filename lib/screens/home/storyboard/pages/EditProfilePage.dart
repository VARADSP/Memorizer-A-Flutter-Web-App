import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/screens/home/storyboard/models/user.dart';
import 'package:firebase_example/screens/home/storyboard/pages/HomePage.dart';
import 'package:firebase_example/screens/home/storyboard/storyboard.dart';
import 'package:firebase_example/screens/home/storyboard/widgets/ProgressWidget.dart';
import "package:flutter/material.dart";

class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;

  EditProfilePage(
      this.currentOnlineUserId
      );

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  TextEditingController profileNameTextEditingController = TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading=false;
  User user;
  bool _bioValid=true;
  bool _profileNameValid=true;


  void initState(){
    super.initState();
    getAndDisplayUserInformation();
  }

  getAndDisplayUserInformation() async{
    setState(() {
      loading=true;
    });

    DocumentSnapshot documentSnapshot = await userReference.doc(widget.currentOnlineUserId).get();
    user = User.fromDocument(documentSnapshot);
    profileNameTextEditingController.text = user.username;
    bioTextEditingController.text="Bio";

    setState(() {
      loading=false;
    });
  }

  updateUserData(){
    setState(() {

      profileNameTextEditingController.text.trim().length<3||profileNameTextEditingController.text.isEmpty?_profileNameValid=false:_profileNameValid=true;
      bioTextEditingController.text.trim().length>110?_bioValid=false:_bioValid=true;

    });

    if(_bioValid && _profileNameValid){
      // userReference.doc(widget.currentOnlineUserId).update(
      //   {
      //     'name':profileNameTextEditingController.text,
      //     'bio':bioTextEditingController.text
      //   }
      // );
    }

    final snackBar = SnackBar(content: Text('Profile has been updated successfully'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Edit Profile',style: TextStyle(color:Colors.white),),
          actions: [
            IconButton(icon: Icon(Icons.done,color:Colors.white,size: 30,),onPressed: ()=>Navigator.pop(context)),

          ],
        ),
        body: loading?circularProgress():ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16,bottom: 7),
                    child: CircleAvatar(
                      radius: 52,
                      child: Icon(Icons.person),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        createProfileNameTextFormField(),
                        createBioTextFormField()
                    ],),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 29,left: 50,right: 50),
                    child: ElevatedButton(
                      onPressed: updateUserData,
                      child: Text(
                        "        Update        ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 29,left: 50,right: 50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        elevation: 5,
                        padding: const EdgeInsets.all(12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: logoutUser,
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }

  logoutUser() async{
    await gSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
  }

  Column createProfileNameTextFormField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13),
          child: Text(
            'Profile Name',
            style: TextStyle(color:Colors.grey),
          ),

        ),
        TextField(
          style: TextStyle(color: Colors.white),
          controller: profileNameTextEditingController,
          decoration: InputDecoration(
            hintText: 'Write profile name here... ',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            hintStyle: TextStyle(color: Colors.grey),
            errorText: _profileNameValid?null:"Profile name is very short"
          ),
        )
      ],
    );
  }

  Column createBioTextFormField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13),
          child: Text(
            'Bio',
            style: TextStyle(color:Colors.grey),
          ),

        ),
        TextField(
          style: TextStyle(color: Colors.white),
          controller: bioTextEditingController,
          decoration: InputDecoration(
              hintText: 'Write bio here... ',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              hintStyle: TextStyle(color: Colors.grey),
              errorText: _bioValid?null:"Bio is very long"
          ),
        )
      ],
    );
  }
}
