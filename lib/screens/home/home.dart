import 'package:firebase_example/screens/home/bubbles/bubbles.dart';
import 'package:firebase_example/screens/home/calculator/calculator.dart';
import 'package:firebase_example/screens/home/chat_app/chatroomscreen.dart';
import 'package:firebase_example/screens/home/notes_add_form.dart';
import 'package:firebase_example/screens/home/settings_form.dart';
import 'package:firebase_example/screens/home/stories_list.dart';
import 'package:firebase_example/screens/home/storyboard/storyboard.dart';
import 'package:firebase_example/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  bool showFloatingActionButton = true;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);



  static List<Widget> _widgetOptions = <Widget>[
    Bubbles(),
    NoteList(),
    ChatRoom(),
    StoryBoard(),
    Calculator(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if(index==1){
        showFloatingActionButton = true;
      }
      else{
        showFloatingActionButton=false;
      }
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
      Navigator.push(context,MaterialPageRoute(
          builder: (context) => NotesAddForm()
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.memory,color: Colors.pink,size: 30,),
            Text('Memorizer',style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold),),
          ],
        ),
        actions: <Widget>[
          ElevatedButton.icon(
            icon:Icon(Icons.person,color: Colors.red,),
            label: Text('Logout',style: TextStyle(color: Colors.redAccent),),
            onPressed: () async{
              await _auth.signOut();
            },
          ),
          // FlatButton.icon(
          //   icon: Icon(Icons.settings),
          //   label:Text('settings'),
          //   onPressed: ()=>_showSettingsPanel(),
          // )
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            label: 'Bubbles',
            backgroundColor: Colors.blue,
          ),
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
