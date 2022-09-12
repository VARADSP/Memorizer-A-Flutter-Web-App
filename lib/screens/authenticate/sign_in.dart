import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/services/auth.dart';
import 'package:firebase_example/services/database.dart';
import 'package:firebase_example/shared/helperFunctions.dart';
import 'package:firebase_example/shared/widgets.dart';
import 'package:firebase_example/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  final AuthService _auth = AuthService();
  DatabaseService databaseMethods = new DatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state
  String email = "";
  String password = "";
  String error = "";
  QuerySnapshot snapshotUserInfo;


  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.memory,color: Colors.pink,size: 30,),
            Text('Memorizer',style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold),),
          ],
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person,color: Colors.white54,),
            label: Text("Register",style: TextStyle(color: Colors.white54),),
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
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Icon(Icons.shop,size: 100,color: Colors.blueAccent,),
                  SizedBox(height: 50,),
                  TextFormField(
                    controller: emailTextEditingController,
                    decoration: emailTextInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val){
                      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val);
                      return emailValid?null:'Please provide a valid emailId';
                    },
                      onChanged: (value){
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: passwordTextEditingController,
                    decoration: passwordTextInputDecoration.copyWith(hintText: 'Password'),
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
                    hoverColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
                    color: Colors.blueAccent[400],
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


                        HelperFunctions.saveUserEmailInSharedPreference(emailTextEditingController.text);

                        databaseMethods.getUserByEmail(emailTextEditingController.text)
                            .then((val){
                          snapshotUserInfo = val;
                          HelperFunctions.saveUserNameInSharedPreference((snapshotUserInfo.docs[0].data() as dynamic)["name"]);
                        });

                        dynamic result = await _auth.signInWithEmailAndPassword(email.trim(), password.trim());

                       if(result!=null){
                         HelperFunctions.saveUserLoggedInSharedPreference(true);
                         setState(() {
                           loading=false;
                         });
                       }
                        if(result == null){
                          setState(() {
                            loading = false;
                            error = 'Could not sign in with those credentials';
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('User does not exists'))
                            );
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account? ",style: mediumTextStyle(),),
                      GestureDetector(
                        onTap: (){
                          widget.toggleView();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Register now",style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline
                          ),),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height:12),
                  Text(
                    error,
                    style: TextStyle(color:Colors.red,fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
