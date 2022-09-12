import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/screens/home/chat_app/conversationscreen.dart';
import 'package:firebase_example/services/database.dart';
import 'package:firebase_example/shared/constants.dart';
import 'package:firebase_example/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseService databaseMethods = new DatabaseService();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;
  bool isSearched = false;

  Widget searchList(){
    return searchSnapshot!=null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return SearchTile(
            userName: (searchSnapshot.docs[index].data() as dynamic)["name"],
            userEmail: (searchSnapshot.docs[index].data() as dynamic)["email"],
          );
        }):(isSearched?Center(child: SpinKitHourGlass(color: Colors.blue)):Container());
  }

  initiateSearch(){
    setState(() {
      isSearched=true;
      searchSnapshot=null;
    });
    databaseMethods.getUserByUsername(searchTextEditingController.text.trim())
        .then((val){
      // print(val.toString());
      setState(() {
        searchSnapshot = val;
      });
    });

  }

  ///create chatroom, send user to conversation screen,pushreplacement
  createChatRoomAndStartConversation({String userName}){
    if(userName != Constants.myName){

      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users=[userName,Constants.myName];
      Map<String,dynamic> chatRoomMap = {
        "users":users,
        "chatRoomId":chatRoomId,
      };

      DatabaseService().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context,MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You cannot send message to yourself'))
      );
    }
  }

  Widget SearchTile({String userName,String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,style: mediumTextStyle()),
              Text(userEmail,style: mediumTextStyle()),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              child: Text('Message',style: mediumTextStyle(),),
            ),
          )
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    isSearched=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
        body: Container(
          child: Column(
            children: [
              Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(
                            color: Colors.white
                        ),
                        onSubmitted: (value){
                          initiateSearch();
                        },
                        decoration: InputDecoration(
                          hintText: 'Search username...',
                          hintStyle: TextStyle(
                            color: Colors.white54
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                     onTap: (){
                       initiateSearch();
                     },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFFFFFF)
                              ]
                            ),
                            borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.search,size: 20,color: Colors.white,)),
                    ),
                  ],
                ),
              ),
              searchList(),
            ],
          ),
        )
    );
  }
}

getChatRoomId(String a,String b){
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }
  else{
    return "$a\_$b";
  }
}