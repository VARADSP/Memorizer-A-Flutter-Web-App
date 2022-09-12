import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_example/shared/widgets.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> colors = ['India','USA','Japan','France','Europe','UK','Russia'];

  String _currentStory;
  int _currentColorStrength;
  String _currentLocation;

  @override
  Widget build(BuildContext context) {

          return Form(
            key: _formKey,
            child: CupertinoScrollbar(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Update your settings.',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Change your name'),
                      validator: (val) => val.isEmpty ? 'Please write your name':null,
                      onChanged: (val) => setState(()=>_currentStory=val),
                    ),
                    SizedBox(height: 20,),
                    //dropdown
                    DropdownButtonFormField(
                      decoration: textInputDecoration,
                      value: _currentLocation??'India',
                      items: colors.map((color)
                      {
                        return DropdownMenuItem(
                          value: color,
                          child: Text('$color'),

                        );
                      }).toList(),
                      onChanged: (val)=>setState(()=>_currentLocation=val),
                    ),
                    //slider
                    SizedBox(height: 20,),
                    Slider(
                      value: (_currentColorStrength??100).toDouble(),
                      activeColor: Colors.brown[_currentColorStrength??100],
                      inactiveColor: Colors.brown[_currentColorStrength??100],
                      min: 100.0,
                      max: 700.0,
                      divisions: 7,
                      onChanged: (val) => setState(()=>_currentColorStrength = val.round()),
                    ),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async{
                        print(_currentStory);
                        print(_currentLocation);
                        print(_currentColorStrength);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }
}
