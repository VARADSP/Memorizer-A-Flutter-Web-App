import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/models/note.dart';

class DatabaseService{
  final String uid;
  DatabaseService({this.uid});
  //collection reference

  Future addUserData(String title,String description,String timestamp,int color) async{
    CollectionReference notesCollection = FirebaseFirestore.instance.collection(uid);
    return await notesCollection.add(
        { "title": title,
          "description": description,
          "timestamp": timestamp,
          'color':color
        }
    );
  }


  Future updateUserData(String title,String description,String timestamp,int color,String id) async{
    CollectionReference notesCollection = FirebaseFirestore.instance.collection(uid);
    return await notesCollection.doc(id).set(
        { "title": title,
          "description": description,
          "timestamp": timestamp,
          'color':color
        }
    );
  }


  Future deleteUserData(String id) async{
    CollectionReference notesCollection = FirebaseFirestore.instance.collection(uid);
    return await notesCollection.doc(id).delete();
  }

  // //userData from snapshots
  // UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
  //   return UserData(
  //     uid: uid,
  //     title: snapshot.data()['title'],
  //     description: snapshot.data()['description'],
  //     timestamp: snapshot.data()['timestamp'],
  //     color: snapshot.data()['color'],
  //   );
  // }

  //stories list from snapshot
  List<Note> _noteListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return Note(
        title:  (doc.data() as dynamic)['title']??'',
        description: (doc.data() as dynamic)['description']??'',
        timestamp: (doc.data() as dynamic)['timestamp']??'',
        color: (doc.data() as dynamic)['color']??'',
      );
    }).toList();
  }

  // //get stories stream
  // Stream get notes{
  //   CollectionReference notesCollection = FirebaseFirestore.instance.collection(uid);
  //   print('in get notes');
  //   return notesCollection.snapshots();
  // }



  getUserByUsername(String userName) async{
    return await FirebaseFirestore.instance.collection('users')
        .orderBy("name")
        .startAt([userName.toLowerCase()])
        .endAt([userName.toLowerCase() + "\uf8ff"])
        .get();
  }

  getUserByEmail(String userEmail) async{
    return await FirebaseFirestore.instance.collection('users')
        .where("email",isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection('users')
        .add(userMap).catchError((e){
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId,chatRoomMap){
    FirebaseFirestore.instance.collection('ChatRoom')
        .doc(chatRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId,messageMap){
    FirebaseFirestore.instance.collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async{
    return FirebaseFirestore.instance.collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }

  getChatRooms(String userName) async{
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .where("users",arrayContains: userName)
        .snapshots();
  }

}