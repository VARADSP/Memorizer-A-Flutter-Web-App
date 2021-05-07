import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_example/screens/wrapper.dart';
import 'package:firebase_example/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intro_slider/intro_slider.dart';
import 'models/user.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<OurUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Memorizer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: IntroScreen(),
      ),
    );
  }
}

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}


class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];
  List<IconData> icons = [];
  Function goToTab;

  @override
  void initState() {
    super.initState();

    icons.add(Icons.note);
    slides.add(
      new Slide(
        title: "Notes",
        styleTitle: TextStyle(
          color: Color(0xff3da4ab),
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
        "Create your Notes, track your activities and many more !",
        styleDescription: TextStyle(
            color: Color(0xfffe9c8f),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
      ),
    );

    icons.add(Icons.chat);
    slides.add(
      new Slide(
        title: "Chat",
        styleTitle: TextStyle(
          color: Color(0xff3da4ab),
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
        "Use the chat app to message others",
        styleDescription: TextStyle(
            color: Color(0xfffe9c8f),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
      ),
    );

    icons.add(Icons.share);
    slides.add(
      new Slide(
        title: "StoryBoard",
        styleTitle: TextStyle(
            color: Color(0xff3da4ab),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
        "See what others are sharing, post your own memories !",
        styleDescription: TextStyle(
            color: Color(0xfffe9c8f),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
      ),
    );


    icons.add(Icons.calculate);
    slides.add(
      new Slide(
        title: "Calculator",
        styleTitle: TextStyle(
            color: Color(0xff3da4ab),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
        "Need to do advance calculations on the way ? Use this one !",
        styleDescription: TextStyle(
            color: Color(0xfffe9c8f),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
      ),
    );


  }

  void onDonePress() async{
    // Back to the first tab
    Map results = await Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return MyHomePage(title: 'Memorizer');
    })
    );
  }

  void onSkipPress() async{
    // Back to the first tab
    Map results = await Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return MyHomePage(title: 'Memorizer');
    })
    );
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderPrevBtn() {
    return Icon(
      Icons.navigate_before,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      IconData icon = icons[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                  child: Icon(icon,size: 200,)
              ),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0x33ffcc5c),
      highlightColorSkipBtn: Color(0xffffcc5c),
      renderPrevBtn: this.renderPrevBtn(),
      // Next button
      renderNextBtn: this.renderNextBtn(),
      showPrevBtn: true,

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
      colorDoneBtn: Color(0x33ffcc5c),
      highlightColorDoneBtn: Color(0xffffcc5c),

      // Dot indicator
      colorDot: Colors.pink,
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: this.renderListCustomTabs(),

      backgroundColorAllSlides: Colors.brown,

      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Behavior
      scrollPhysics: BouncingScrollPhysics(),

      // Show or hide status bar
      hideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //

    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return StreamProvider<OurUser>.value(
      value: AuthService().user,
      child: Scaffold(
        body: Wrapper(), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
