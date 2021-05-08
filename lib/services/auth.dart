import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_example/models/user.dart';
import 'package:firebase_example/services/database.dart';
import 'package:firebase_example/shared/helperFunctions.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  OurUser _userFromFirebaseUser(User user){
    return user!=null?OurUser(uid:user.uid,name: user.email):null;
  }
// Create user object on Firebase user
  OurUser _userFromFirebase(User user) {
    return user != null ? OurUser(uid: user.uid,name: user.email) : null;
  }

  Stream<OurUser> get user {
    return _auth.authStateChanges().map((User user) => _userFromFirebase(user));
  }
  // everytime a user signs in or signs out we get the event down the stream

  //sign in anon
  Future signInAnon() async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      User user = userCredential.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email,String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email and pass
  Future registerWithEmailAndPassword(String email,String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      await DatabaseService(uid: user.uid).addUserData('sample_note_title', 'sample_note_description', DateTime.now().toString(),100);
      return _userFromFirebaseUser(user);
    }
    catch(e){
        print(e.toString());
        return null;
    }
  }

  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      print(e.toString());
    }
  }


  //sign out
  Future signOut() async{
    try{
      HelperFunctions.clearSharedPreference();
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}