import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/models/note.dart';
import 'package:firebase_example/models/user.dart';

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
        title: doc.data()['title']??'',
        description: doc.data()['description']??'',
        timestamp: doc.data()['timestamp']??'',
        color: doc.data()['color']??'',
      );
    }).toList();
  }

  // //get stories stream
  // Stream get notes{
  //   CollectionReference notesCollection = FirebaseFirestore.instance.collection(uid);
  //   print('in get notes');
  //   return notesCollection.snapshots();
  // }

}