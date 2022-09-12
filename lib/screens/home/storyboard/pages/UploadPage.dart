import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/screens/home/storyboard/widgets/ProgressWidget.dart';
import 'package:firebase_example/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
// NetworkImage
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:image_whisperer/image_whisperer.dart';  //
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage> {

  final Reference storageReference = FirebaseStorage.instance.ref('posts_pictures');
  final postsReference = FirebaseFirestore.instance.collection('posts');
  final allPostsReference = FirebaseFirestore.instance.collection('allposts');

  html.File file;
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  BlobImage image;
  String fileName;
  String url;
  bool uploading=false;
  String postId = Uuid().v4();


  captureImageWithCamera() async{
    Navigator.pop(context);
    PickedFile imageFile = await ImagePicker.platform.pickImage(
        source: ImageSource.camera,
        maxHeight: 600,
      maxWidth: 970
    );
    setState(() {
      this.file = imageFile.path as html.File;
      this.image = new BlobImage(this.file,name: this.file.name);
    });
  }



  pickImageFromGallary() async{
    Navigator.pop(context);
    // PickedFile imageFile = await ImagePicker.platform.pickImage(
    //     source: ImageSource.gallery,
    //     maxHeight: 600,
    //     maxWidth: 970
    // );
    // setState(() {
    //   this.file = imageFile.path as File;
    //   this.image = new BlobImage(this.file,name: this.file.name);
    // });

    // final input = html.FileUploadInputElement()..accept = 'image/*';
    // input.onChange.listen((event) {
    //   if(input.files.isNotEmpty){
    //
    //     setState(() {
    //       fileName = input.files.first.name; // file name without path!
    //
    //       // synthetic file path can be used with Image.network()
    //       url = html.Url.createObjectUrl(input.files.first);
    //
    //     });
    //   }
    // });
    // input.click();


    html.File imageFile =
    await ImagePickerWeb.getImage(outputType: ImageType.file);

    if (imageFile != null) {
      setState(() {
        file = imageFile;
        image = new BlobImage(file, name: file.name);
      });
    }
  }

  takeImage(mcontext) {
    return showDialog(
      context: mcontext,
       builder: (context){
          return SimpleDialog(
            title: Row(
              children: [
                Icon(Icons.post_add,color: Colors.blue,),
                Text('New Post',style:TextStyle(color: Colors.purple,fontWeight: FontWeight.bold)),
              ],
            ),
            children: [
              // SimpleDialogOption(
              //   child: Text('Capture Image with Camera',style: TextStyle(color: Colors.blueAccent),),
              //   onPressed: captureImageWithCamera,
              // ),
              SimpleDialogOption(
                child: Text('Capture Image from Gallary',style: TextStyle(color: Colors.blueAccent),),
                onPressed: pickImageFromGallary,
              ),
              SimpleDialogOption(
                child: Text('Cancel',style: TextStyle(color: Colors.blueAccent),),
                onPressed: ()=>Navigator.pop(context),
              )
            ],
          );
       }
    );
  }

  // compressingPhoto() async {
  //   final tDirectory = await getTemporaryDirectory();
  //   final path = tDirectory.path;
  //   Uint8List mImage = Base64Codec().decode(image.url);
  //   ImD.Image mImageFile = ImD.decodeImage(mImage);
  //   final compressImageFile = html.File(mImage, '$path/img_$postId.jpg');
  // }

  Future<String> uploadPhoto(file) async{
      UploadTask storageUploadTask = storageReference.child('post_$postId.jpg').putBlob(image.blob);
      //
      // // Optional
      // storageUploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      //   print('Snapshot state: ${snapshot.state}'); // paused, running, complete
      //   print('Progress: ${snapshot.totalBytes / snapshot.bytesTransferred}');
      // }, onError: (Object e) {
      //   print(e); // FirebaseException
      // });

    String downloadUrl = await storageUploadTask
        .then((TaskSnapshot snapshot) {
      print('Upload complete!');
      return snapshot.ref.getDownloadURL();
    })
        .catchError((Object e) {
      print(e.toString()); // FirebaseException
    });
    return downloadUrl;
  }

  controlUploadAndSave() async{
    setState(() {
      uploading=true;
    });
   // await compressingPhoto();
    String downloadUrl = await uploadPhoto(file);

    print(downloadUrl+"file uploaded");
    savePostInfoToFireStore(url:downloadUrl,location:locationTextEditingController.text,description:descriptionTextEditingController.text);
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      file=null;
      uploading=false;
      postId = Uuid().v4();
    });

  }

  savePostInfoToFireStore({String url,String location,String description}){
    // Constants.myId="Fv2oR1PZBG8wbbBVUSRF";
    // Constants.myName="varad";
    postsReference.doc(Constants.myId).collection('usersPosts').doc(postId).set(
      {
        'postId':postId,
        'ownerId':Constants.myId,
        'timestamp':DateTime.now(),
        'likes':{},
        'username':Constants.myName,
        'description':description,
        'location':location,
        'url':url,
      }
    );
    allPostsReference.doc(postId).set(
        {
          'postId':postId,
          'ownerId':Constants.myId,
          'timestamp':DateTime.now(),
          'likes':{},
          'username':Constants.myName,
          'description':description,
          'location':location,
          'url':url,
        }
    );

  }

  displayUploadScreen(){
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Icon(Icons.add_photo_alternate,color: Colors.grey,size: 200,),
            Padding(
              padding:EdgeInsets.only(top:20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                child: Text('Upload Image',style: TextStyle(color: Colors.white,fontSize: 20),),
                color: Colors.green,
                onPressed: (){
                    takeImage(context);
                },
              ),
            )
        ],
      ),
    );
  }

  clearPostInfo()
  {
   locationTextEditingController.clear();
   descriptionTextEditingController.clear();
    setState(() {
      file=null;
    });
  }

  getUserCurrentLocation() async{
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
// this will get the coordinates from the lat-long using Geocoder Coordinates
      final coordinates = Coordinates(position.latitude, position.longitude);

// this fetches multiple address, but you need to get the first address by doing the following two codes
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          coordinates);
      var place = addresses.first;
      String completeAdderss = '${place.subThoroughfare} ${place
          .thoroughfare}, ${place.subLocality} ${place.locality}, ${place
          .subAdminArea} ${place.adminArea},${place.postalCode} ${place
          .countryName}'; // your country name will
      String specificAddress = "${place.locality},${place.countryName}";
      locationTextEditingController.text = specificAddress;
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get the location !'))
      );
    }
    }

  displayUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white),onPressed: clearPostInfo,),
        title:Text('New Post',style:TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold)),
        actions: [
          FlatButton(
            onPressed: uploading?null:()=>controlUploadAndSave(),
            child: Text("Share",style: TextStyle(color: Colors.lightGreenAccent,fontWeight: FontWeight.bold,fontSize: 16),),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading?linearProgress():Text(""),
          SingleChildScrollView(
            child: Container(
              height: 230,
              width: MediaQuery.of(context).size.width*0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(image.url),fit: BoxFit.fitHeight),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
          ),
          ListTile(
            leading:Icon(Icons.person,color: Colors.white,),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(
                    color: Colors.white,
                ),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Say something about image.",
                  hintStyle: TextStyle(
                      color:Colors.white,
                  ),
                  border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.person_pin_circle,color: Colors.white,size: 36.0,),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: locationTextEditingController,
                decoration: InputDecoration(
                    hintText: "Write the location here.",
                    hintStyle: TextStyle(
                      color:Colors.white,
                    ),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Container(
            width: 220,
            height: 110,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),

              ),
              color: Colors.green,
              icon: Icon(Icons.location_on,color:Colors.white),
              label:Text("Get my Current Location",style:TextStyle(color:Colors.white)),
              onPressed: (){
                try{
                  getUserCurrentLocation();
                }
                catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not get the location !'))
                  );
                }
              }
            ),
          )
        ],
      ),

    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
      return file==null?displayUploadScreen():displayUploadFormScreen();
  }
}

