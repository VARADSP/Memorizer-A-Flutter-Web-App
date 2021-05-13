import 'package:firebase_example/models/user.dart';
import 'package:firebase_example/screens/home/notes_edit_form.dart';
import 'package:firebase_example/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_example/models/note.dart';
import 'package:provider/provider.dart';

class NoteTile extends StatefulWidget {

  final Note note;
  NoteTile({this.note});

  @override
  _NoteTileState createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<OurUser>(context);
    print(user.email);

    void _showNotesEditPanel(bool isEdit,Note note){
      Navigator.push(context,MaterialPageRoute(
          builder: (context) => NotesEditForm(isEdit: isEdit,note: note)
      ));
      // showModalBottomSheet(context: context,
      //     builder: (context){
      //       return Container(
      //         padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
      //         child: NotesEditForm(isEdit: isEdit,note:note),
      //       );
      //     });
    }



    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          onTap: (){
            _showNotesEditPanel(false,widget.note);
          },
          trailing:Wrap(
            spacing: 12,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete,color: Colors.red,),
                onPressed: () async{
                  dynamic result = await DatabaseService(uid: user.uid).deleteUserData(widget.note.id);
                  setState(() {
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert,color: Colors.blue,),
                onPressed: (){
                  _showNotesEditPanel(true,widget.note);
                },
              ),
            ],

          ),

          leading: CircleAvatar(
            child: Icon(Icons.note),
            radius: 25,
            backgroundColor: Colors.red[widget.note.color],
          ),
         title: Text(widget.note.title),
         subtitle: Text(widget.note.timestamp),
        ),
    ),
    );

  }
}
