import 'package:firebase_example/models/note.dart';
import 'package:firebase_example/models/user.dart';
import 'package:firebase_example/services/database.dart';
import 'package:firebase_example/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_example/shared/widgets.dart';
import 'package:provider/provider.dart';

class NotesEditForm extends StatefulWidget {
  bool isEdit;
  Note note;
  NotesEditForm({this.isEdit,this.note});

  @override
  _NotesEditFormState createState() => _NotesEditFormState();
}

class _NotesEditFormState extends State<NotesEditForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> colors = ['India','USA','Japan','France','Europe','UK','Russia'];
  String _currentNoteTitle='';
  String _currentNoteDescription='';
  String _currentNoteTimestamp='';
  int _currentNoteColor=100;
  String error='';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<OurUser>(context);

        return Form(
            key: _formKey,
            child: CupertinoScrollbar(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Text(
                      (widget.isEdit?'Update your note.':'View your note'),
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                        initialValue: (widget.isEdit?'':widget.note.title),
                      decoration: textInputDecoration.copyWith(hintText: 'Update your note title'),
                      validator: (val) => val.isEmpty ? 'Please write your note title':null,
                      onChanged: (val) => setState(()=>_currentNoteTitle=val),
                      enabled: widget.isEdit,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      initialValue: (widget.isEdit?'':widget.note.description),
                      decoration: textInputDecoration.copyWith(hintText: 'Update your note description'),
                      validator: (val) => val.isEmpty ? 'Please write your note description':null,
                      onChanged: (val) => setState(()=>_currentNoteDescription=val),
                      enabled: widget.isEdit,
                      maxLines: 10,
                    ),
                    //slider
                    SizedBox(height: 20,),
                    widget.isEdit?Slider(
                      value: (widget.note.color??100).toDouble(),
                      activeColor: Colors.red[widget.note.color??100],
                      inactiveColor: Colors.red[widget.note.color??100],
                      min: 100.0,
                      max: 700.0,
                      divisions: 7,
                      onChanged: (val) => setState((){
                        _currentNoteColor = val.round();
                        widget.note.color = val.round();
                      }),
                    ):Text((widget.note.color >= 600)?' Highly Important':(widget.note.color>=300)?'Important':''),
                    widget.isEdit?RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async{
                        if(_formKey.currentState.validate()) {
                          dynamic result = await DatabaseService(uid: user.uid).updateUserData(_currentNoteTitle, _currentNoteDescription, DateTime.now().toString(),_currentNoteColor,widget.note.id);

                            if(result == null){
                              setState(() {
                                error = 'Could not update your note, Please try again!';
                              });
                            }
                          }
                        setState(() {
                          Navigator.pop(context);

                        });
                      },
                    ):Text(''),
                    SizedBox(height:12),
                    Text(
                      error,
                      style: TextStyle(color:Colors.red,fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
}
