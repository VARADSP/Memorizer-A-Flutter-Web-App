import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/screens/home/storyboard/pages/NotificationsPage.dart';
import 'package:firebase_example/screens/home/storyboard/pages/ProfilePage.dart';
import 'package:firebase_example/screens/home/storyboard/pages/SearchPage.dart';
import 'package:firebase_example/screens/home/storyboard/pages/TimeLinePage.dart';
import 'package:firebase_example/screens/home/storyboard/pages/UploadPage.dart';
import 'package:firebase_example/shared/constants.dart';
import 'package:firebase_example/shared/helperFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn gSignIn= GoogleSignIn();
final userReference = FirebaseFirestore.instance.collection('users');

class StoryBoard extends StatefulWidget {
  @override
  _StoryBoardState createState() => _StoryBoardState();
}

class _StoryBoardState extends State<StoryBoard> {

  bool isSignIn = false;
  PageController pageController;
  int getPageIndex=0;

  void initState(){
    super.initState();
    pageController = PageController();
    getUserInfo();
    //
    // gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
    //     controlSignIn(gSignInAccount);
    // },onError: (gError){
    //   print("Error Message :" + gError);
    // });
    //
    // gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount){
    //   controlSignIn(gSignInAccount);
    // }).catchError((gError){
    //   print("Error Message : "+ gError);
    // });
  }


  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameInSharedPreference();
  }


  controlSignIn(GoogleSignInAccount signInAccount) async{
    if(signInAccount != null){
      setState(() {
        isSignIn = true;
      });

    }
    else{
      setState(() {
        isSignIn = false;
      });
    }
  }

  loginUser(){
    gSignIn.signIn();
  }

  logoutUser(){
    gSignIn.signOut();

  }

  whenPageChanges(int pageIndex){
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex){
      pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
  }


  void dispose(){
    super.dispose();
    pageController.dispose();
  }

  Widget buildHomeScreen(){
    return Scaffold(
      body: PageView(
        children: <Widget>[
          TimeLinePage(),
          SearchPage(),
          UploadPage(),
          NotificationsPage(),
          ProfilePage(Constants.myId)
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap:onTapChangePage,
        backgroundColor: Colors.black,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),),
          BottomNavigationBarItem(icon: Icon(Icons.search),),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size:37),),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),),
          BottomNavigationBarItem(icon: Icon(Icons.person),)
        ],
      ),
    );
  }

  Scaffold buildSignInScreen(){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.black,Colors.grey]
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('StoryBoard'
              ,style: GoogleFonts.lato(
                  color: Colors.white,
                  letterSpacing: 5,
                    fontSize: 50
                )
              ),
            ),
            SizedBox(height: 8,),
            Center(
              child: SignInButton(
                Buttons.Email,
                padding: EdgeInsets.all(16),
                onPressed: () {
                  loginUser();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return buildHomeScreen();
    // if(isSignIn){
      //     return buildHomeScreen();
      // }
      // else{
      //   return buildSignInScreen();
      // }
  }

}
