import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/models/note.dart';
import 'package:firebase_example/screens/home/notes_add_form.dart';
import 'package:firebase_example/screens/home/notes_edit_form.dart';
import 'package:firebase_example/screens/home/settings_form.dart';
import 'package:firebase_example/screens/home/stories_list.dart';
import 'package:firebase_example/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_example/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);



  static List<Widget> _widgetOptions = <Widget>[
    NoteList(),
    Text(
      'Index 1: Chat',
      style: optionStyle,
    ),
    Text(
      'Index 2: Locate',
      style: optionStyle,
    ),
    Text(
      'Index 3: Calculator',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {



    void _showSettingsPanel(){
      showModalBottomSheet(context: context,
          builder: (context){
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
              child: SettingsForm(),
            );
          });
    }

    void _showNotesAddPanel(){
      showModalBottomSheet(context: context,
          builder: (context){
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
              child: NotesAddForm(),
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: Text('Memorizer',style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon:Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async{
              await _auth.signOut();
            },
          ),
          FlatButton.icon(
            icon: Icon(Icons.settings),
            label:Text('settings'),
            onPressed: ()=>_showSettingsPanel(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        tooltip: 'Add a note',
        child: Icon(Icons.add),
        onPressed: (){
          _showNotesAddPanel();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Notes',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'StoryBoard',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
