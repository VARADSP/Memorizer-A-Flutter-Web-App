import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/models/user.dart';
import 'package:firebase_example/services/database.dart';
import 'package:firebase_example/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_example/shared/constants.dart';
import 'package:provider/provider.dart';

class NotesAddForm extends StatefulWidget {
  @override
  _NotesAddFormState createState() => _NotesAddFormState();
}

class _NotesAddFormState extends State<NotesAddForm> {

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
                      'Add your note.',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Add your note title'),
                      validator: (val) => val.isEmpty ? 'Please write your note title':null,
                      onChanged: (val) => setState(()=>_currentNoteTitle=val),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      maxLines: 10,
                      decoration: textInputDecoration.copyWith(hintText: 'Add your note description'),
                      validator: (val) => val.isEmpty ? 'Please write your note description':null,
                      onChanged: (val) => setState(()=>_currentNoteDescription=val),
                    ),
                    SizedBox(height: 20,),
                    //slider
                    Slider(
                      label: 'Choose Importance',
                      value: (_currentNoteColor??100).toDouble(),
                      activeColor: Colors.red[_currentNoteColor??100],
                      inactiveColor: Colors.red[_currentNoteColor??100],
                      min: 100.0,
                      max: 700.0,
                      divisions: 7,
                      onChanged: (val) => setState(()=>_currentNoteColor = val.round()),
                    ),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async{
                        if(_formKey.currentState.validate()) {
                          dynamic result = await DatabaseService(uid: user.uid).addUserData(_currentNoteTitle, _currentNoteDescription, DateTime.now().toString(),_currentNoteColor);
                            if(result == null){
                              setState(() {
                                error = 'Could not add your note, Please try again!';
                              });
                            }
                          }
                        setState(() {
                          Navigator.pop(context);
                        });
                        },
                    ),
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
