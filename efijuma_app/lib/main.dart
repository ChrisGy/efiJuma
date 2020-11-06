import 'package:efijuma_app/AgentScreens.dart';
import 'package:efijuma_app/BuyerScreens.dart';
import 'package:efijuma_app/BuyerSearch.dart';

// import 'package:efijuma_app/TransportScreens.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as LaunchUrl;

final dBRoot = FirebaseDatabase.instance.reference();
//Firebase config
void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.green,
      home: new HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    //Force no auto-rotate. Depends on flutter:services import.
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  int curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Select Service',
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text('Select Service'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.call,
              color: Colors.white,
            ),
            onPressed: () {
              LaunchUrl.launch("tel://080010000");
            },
            backgroundColor: Colors.green,
          ),
          body:
              //_mainScreenPages[curIndex],
              Center(
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      child: Card(
                        margin: new EdgeInsets.symmetric(horizontal: 25),
                        clipBehavior: Clip.hardEdge,
                        elevation: 2,
                        color: Colors.green.shade50,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                  builder: (context) => BuyerScreenHome()),
                            );
                          },
                          child: Container(
                              margin: new EdgeInsets.fromLTRB(
                                  76.0, 16.0, 16.0, 16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Find efiJuma",
                                        style: TextStyle(fontSize: 30)),
                                    Container(
                                        margin: new EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        height: 4.0,
                                        width: 30.0,
                                        color: Colors.green),
                                    Text(
                                        "Find efiJuma service providers in your neighbourhood")
                                  ])),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      margin: new EdgeInsets.symmetric(vertical: 16.0),
                      padding: EdgeInsets.all(5),
                      //alignment: FractionalOffset.centerLeft,
                      child: new Image(
                        image: new AssetImage("assets/images/buyer_avatar.png"),
                        height: 82.0,
                        width: 82.0,
                      ),
                    )
                  ],
                ),
                Divider(
                  thickness: 20,
                  color: Colors.transparent,
                ),
                Divider(
                  thickness: 20,
                  color: Colors.transparent,
                ),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      child: Card(
                        margin: new EdgeInsets.symmetric(horizontal: 25),
                        clipBehavior: Clip.hardEdge,
                        elevation: 2,
                        color: Colors.green.shade50,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                  builder: (context) => AgentScreenLogin()),
                            );
                          },
                          child: Container(
                              margin: new EdgeInsets.fromLTRB(
                                  76.0, 16.0, 16.0, 16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Provide efiJuma",
                                        style: TextStyle(fontSize: 30)),
                                    Container(
                                        margin: new EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        height: 4.0,
                                        width: 30.0,
                                        color: Colors.green),
                                    Text("Enter Service Provider Console")
                                  ])),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      margin: new EdgeInsets.symmetric(vertical: 16.0),
                      padding: EdgeInsets.all(14),
                      //alignment: FractionalOffset.centerLeft,
                      child: new Image(
                        fit: BoxFit.fill,
                        image: new AssetImage("assets/images/call_agent.png"),
                        height: 61.0,
                        width: 64.0,
                      ),
                    ),
                  ],
                ),
                Divider(),
                RaisedButton(
                  child: Text("jump to search page for tests"),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuyerMainSearch())),
                ),
                Padding(
                  padding: EdgeInsets.all(100),
                )
              ]),
            ),
          )),
    );
  }
}
