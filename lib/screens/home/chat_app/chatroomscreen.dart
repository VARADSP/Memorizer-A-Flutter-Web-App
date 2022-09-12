import 'package:firebase_example/screens/home/chat_app/conversationscreen.dart';
import 'package:firebase_example/screens/home/chat_app/search.dart';
import 'package:firebase_example/services/auth.dart';
import 'package:firebase_example/services/database.dart';
import 'package:firebase_example/shared/constants.dart';
import 'package:firebase_example/shared/helperFunctions.dart';
import 'package:firebase_example/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

 AuthService authMethods = new AuthService();
 DatabaseService databaseMethods = new DatabaseService();

 Stream chatRoomStream;

 Widget chatRoomList(){
   return StreamBuilder(
     stream: chatRoomStream,
     builder: (context,snapshot){
       return snapshot.hasData?ListView.builder(
         itemCount: snapshot.data.docs.length,
         itemBuilder: (context,index){
              return ChatRoomsTile(
                snapshot.data.docs[index].data()["chatRoomId"]
                      .toString().replaceAll("_", "")
                      .replaceAll(Constants.myName, ""),
                  snapshot.data.docs[index].data()["chatRoomId"]
              );
         }):Center(child: SpinKitSquareCircle(color: Colors.pink));
     },
   );
 }


 @override
  void initState(){
    // TODO: implement initState
    getUserInfo();
    super.initState();
 }

 getUserInfo() async{
  Constants.myName = await HelperFunctions.getUserNameInSharedPreference();
  databaseMethods.getChatRooms(Constants.myName).then((val){
    setState(() {
      chatRoomStream = val;
    });
  });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: "Search Btn",
          child: Icon(Icons.search),
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(
                builder: (context) => SearchScreen()
            ));
          },
        ),
        body: Stack(children: [
          Center(child: Text('Chat Rooms',style: TextStyle(color: Colors.white38))),
          chatRoomList()
        ])
    );
  }
}
class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(
          builder: (context)=>ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text(userName.substring(0,1).toUpperCase(),style: mediumTextStyle()),
            ),
            SizedBox(width: 8),
            Text(userName,style: mediumTextStyle())
          ],
        ),
      ),
    );
  }
}
