import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/services/database.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage>{

  TextEditingController searchTextEditingController = TextEditingController();
  QuerySnapshot futureSearchResult;

  emptySearchTextFormField(){
    searchTextEditingController.clear();
    setState(() {
      futureSearchResult=null;
    });
  }
 
  controlSearching(String str){
    DatabaseService().getUserByUsername(searchTextEditingController.text.trim())
        .then((val){
      // print(val.toString());
      setState(() {
        futureSearchResult = val;
      });
    });
  }
  
  AppBar searchPageHeader(){
    return AppBar(
      backgroundColor: Colors.black,
      title: TextFormField(
        controller: searchTextEditingController,
        style: TextStyle(fontSize: 18,color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search Here ...',
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          filled: true,
          prefixIcon: Icon(Icons.person,color: Colors.white,size: 30,),
          suffixIcon: IconButton(icon: Icon(Icons.clear,color:Colors.white,),onPressed: emptySearchTextFormField,)
        ),
        onFieldSubmitted: controlSearching,
      ),
    );
  }


  displayNoSearchResultScreen(){
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.group,color: Colors.grey,size:200),
            Text(
             "Search Users",
             textAlign: TextAlign.center,
             style:TextStyle(color:Colors.white,fontWeight: FontWeight.w500,fontSize: 50),
            )
          ],
        ),
      ),
    );
  }

  displayUsersFoundScreen(){
    return ListView.builder(
      itemCount: futureSearchResult.docs.length,
      shrinkWrap: true,
      itemBuilder: (context,index){
               return  UserResult(userName: (futureSearchResult.docs[index].data() as dynamic)["name"],userEmail: (futureSearchResult.docs[index].data() as dynamic)["email"],);
      },
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void initState(){
    super.initState();
    futureSearchResult=null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    futureSearchResult=null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: searchPageHeader(),
      body: futureSearchResult==null?displayNoSearchResultScreen():displayUsersFoundScreen(),
    );
  }


}

class UserResult extends StatelessWidget {
  final String userName;
  final String userEmail;
  UserResult({this.userName,this.userEmail});

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(3),
        child: Container(
          color: Colors.white54,
          child: Column(
            children: [
              GestureDetector(
                onTap:(){
                  print("tapped");
                },
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.black,child: Icon(Icons.person),),
                  title: Text(userName,style: TextStyle(
                    color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold
                  ),

                  ),
                  subtitle: Text(userEmail,style: TextStyle(
                    color: Colors.black,fontSize: 13,
                  ),),
                ),
              )
            ],
          ),
        ),
      );
  }
}

