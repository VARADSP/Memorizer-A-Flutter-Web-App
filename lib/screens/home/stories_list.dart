import 'package:firebase_example/models/note.dart';
import 'package:firebase_example/models/user.dart';
import 'package:firebase_example/screens/home/story_tile.dart';
import 'package:firebase_example/services/database.dart';
import 'package:firebase_example/shared/constants.dart';
import 'package:firebase_example/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<OurUser>(context);
    // final List<Note> notes = Provider.of<List<Note>>(context);
    // if(notes!=null){
    //   print(notes);
    //  }
    //final notes = null;
    Constants.myId = user.uid;
    Constants.myEmail = user.email;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(user.uid).orderBy('color',descending: true).snapshots(),
      builder: (context,snapshots){
          if(!snapshots.hasData){
            return LoadingForInnerScreen();
          }
          else{
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                      image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/fir-example-6ce04.appspot.com/o/loginlogo.png?alt=media&token=e4b28200-4e6d-4e4f-a250-e24f7262e6b0')
                  )
              ),
              child: ListView.builder(
                itemCount: snapshots.data.docs.length,
                itemBuilder: (context,index){
                  Note note = new Note(id:snapshots.data.docs[index].id,color: snapshots.data.docs[index].data()['color'],
                      description: snapshots.data.docs[index].data()['description'],timestamp: snapshots.data.docs[index].data()['timestamp'],
                      title: snapshots.data.docs[index].data()['title']);
                  return
                    NoteTile(note:note);
                },
              ),
            );
          }
      },
    );
  }
}
