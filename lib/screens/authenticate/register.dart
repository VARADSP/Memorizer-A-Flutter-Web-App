import 'package:firebase_example/services/auth.dart';
import 'package:firebase_example/services/database.dart';
import 'package:firebase_example/shared/helperFunctions.dart';
import 'package:firebase_example/shared/widgets.dart';
import 'package:firebase_example/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  DatabaseService databaseMethods = new DatabaseService();
  bool loading = false;
  //text field state
  String email = "";
  String username = "";
  String password = "";
  String error="";

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
          ElevatedButton.icon(
            icon: Icon(Icons.person,color: Colors.white54,),
            label: Text("Sign In",style: TextStyle(color: Colors.white54)),
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
                      controller: userNameTextEditingController,
                      decoration: usernameTextInputDecoration.copyWith(hintText: 'Username'),
                      validator: (val) => val.length<2?'Enter a valid username':null,
                      onChanged: (value){
                        setState(() {
                          username = value;
                        });
                      },
                    ),
                    SizedBox(height: 20,),
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
                      validator: (val) => val.length<6?'Enter a password 6+ chars long':null,
                      obscureText: true,
                      onChanged: (value){
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent[400],
                        padding: EdgeInsets.symmetric(horizontal: 70,vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
                      ),
                      child: Text(
                        'Register'
                        ,style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async{
                          if(_formKey.currentState.validate()){
                            HelperFunctions.saveUserEmailInSharedPreference(emailTextEditingController.text);
                            HelperFunctions.saveUserNameInSharedPreference(userNameTextEditingController.text);

                            setState(() {
                              loading = true;
                            });

                              dynamic result = await _auth.registerWithEmailAndPassword(email.trim(), password.trim());

                              if(result!=null){
                                Map<String,String> userInfoMap = {
                                  'name':userNameTextEditingController.text,
                                  'email':emailTextEditingController.text
                                };
                                databaseMethods.uploadUserInfo(userInfoMap);
                                HelperFunctions.saveUserLoggedInSharedPreference(true);
                              }

                              if(result == null){
                                setState(() {
                                  loading = false;
                                  error = 'This Email is already in use !';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('User already exists !'))
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
                        Text("Already have account? ",style: mediumTextStyle(),),
                        GestureDetector(
                          onTap: (){
                            widget.toggleView();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("SignIn now",style: TextStyle(
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
