import 'package:firebase_example/models/user.dart';
import 'package:firebase_example/screens/home/home.dart';
import 'package:firebase_example/services/auth.dart';
import 'package:firebase_example/shared/constants.dart';
import 'package:firebase_example/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Memorizer',style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold),),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Register"),
            onPressed: (){
                widget.toggleView();
            },
          )
        ],
      ),
      body: Center(
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/fir-example-6ce04.appspot.com/o/loginlogo.png?alt=media&token=e4b28200-4e6d-4e4f-a250-e24f7262e6b0')
                )
            ),
          width: 500,
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Icon(Icons.shop,size: 100,color: Colors.blueAccent,),
                SizedBox(height: 50,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val)=> val.isEmpty ? 'Enter an email':null,
                  onChanged: (value){
                    setState(() {
                      email = value;
                    });
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val)=>val.length<6?'Enter a password 6+ chars long':null,
                  obscureText: true,
                  onChanged: (value){
                    setState(() {
                      password = value;
                    });
                  },
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
                  color: Colors.pink[400],
                  padding: EdgeInsets.symmetric(horizontal: 70,vertical: 20),
                  child: Text(
                      'Sign In'
                      ,style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async{
                    if(_formKey.currentState.validate()){
                      setState(() {
                        loading = true;
                      });
                     dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                     if(result!=null){
                       setState(() {
                         loading=false;
                       });
                     }
                      if(result == null){
                        setState(() {
                          loading = false;
                          error = 'Could not sign in with those credentials';
                        });
                      }
                    }
                  },
                ),
                SizedBox(height:12),
                Text(
                  error,
                  style: TextStyle(color:Colors.red,fontSize: 14),
                ),

              ],
            ),
          )
        ),
      ),
    );
  }
}
