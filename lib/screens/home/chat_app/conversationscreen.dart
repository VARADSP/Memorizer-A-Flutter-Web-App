import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/services/database.dart';
import 'package:firebase_example/shared/constants.dart';
import 'package:firebase_example/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseService databaseMethods = new DatabaseService();
  TextEditingController messageController = new TextEditingController();
  ScrollController _controller = new ScrollController();
  Stream chatMessageStream;

  Widget ChatMessageList(){
      return StreamBuilder(
        stream: chatMessageStream,
        builder: (context,snapshot){
          return !snapshot.hasData?Center(child: SpinKitSquareCircle(color: Colors.red)):ListView.builder(
            itemCount: snapshot.data.docs.length,
            controller: _controller,
            itemBuilder: (context,index){
              return MessageTile(snapshot.data.docs[index].data()["message"],
                  snapshot.data.docs[index].data()["sendBy"] == Constants.myName);
            },
          );
        },
      );
  }


  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap = {
        'message':messageController.text,
        'sendBy':Constants.myName,
        'time':FieldValue.serverTimestamp()
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text="";
      setState(() {
        _controller.animateTo(_controller.position.maxScrollExtent+100, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      });
    }
  }

  void scrollDown() async{
    Timer(Duration(milliseconds: 500), (){
      setState(() {
        if(_controller.hasClients){
          _controller.animateTo(_controller.position.maxScrollExtent+100, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val){
      setState(() {
        chatMessageStream = val;
      });
    });
    scrollDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: Container(
          child: Stack(
            children: [
              Container(
                  child: ChatMessageList(),
                  height: MediaQuery.of(context).size.height-130,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Color(0x54FFFFFF),
                  padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(
                              color: Colors.white
                          ),
                          onSubmitted: (value){
                            sendMessage();
                          },
                          decoration: InputDecoration(
                            hintText: 'Message ...',
                            hintStyle: TextStyle(
                                color: Colors.white54
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                        sendMessage();
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
                            child: Icon(Icons.send,size: 20,color: Colors.white,)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message,this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top:8,bottom:8,left: isSendByMe?0:24,right: isSendByMe?24:0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        margin: isSendByMe?EdgeInsets.only(left: 30):EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17,bottom: 17,left: 20,right: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe?[
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ]:[
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF)
            ]
          ),
          borderRadius: isSendByMe?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
              ):
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style:TextStyle(
          color: Colors.white,
          fontSize: 17
        )),
      ),
    );
  }
}
