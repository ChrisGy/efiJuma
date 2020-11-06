import 'package:efijuma_app/ProviderHome.dart';
import 'package:flutter/material.dart';

import 'CustomLists.dart';
import 'ManageMembers.dart';

//final dBRef = FirebaseDatabase.instance.reference();
//final FirebaseDatabase dBRoot = FirebaseDatabase.instance;

class AgentLoginScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(textTheme: TextTheme(headline6: TextStyle())),
          //fontFamily: 'Georgia',
          primarySwatch: Colors.green,
          backgroundColor: Colors.transparent),
      home: AgentScreenLogin(title: 'Agent Login'),
    );
  }
}

class AgentScreenLogin extends StatefulWidget {
  AgentScreenLogin({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AgentScreenLoginState createState() => _AgentScreenLoginState();
}

class _AgentScreenLoginState extends State<AgentScreenLogin> {
  TextStyle style = TextStyle(fontFamily: 'Georgia', fontSize: 20.0);
  final passwordFieldController = TextEditingController();
  final usernameFieldController = TextEditingController();

  Widget loadWidget = Container();

  void dispose() {
    passwordFieldController.dispose();
    usernameFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    //    // The Flutter framework has been optimized to make rerunning build methods
    //    // fast, so that you can just rebuild anything that needs updating rather
    //    // than having to individually change instances of widgets.
    final emailField = TextField(
      controller: usernameFieldController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Agent ID",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      obscureText: true,
      controller: passwordFieldController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = Material(
        clipBehavior: Clip.hardEdge,
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.lightGreen,
        child: Builder(
          builder: (context) => MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
              final String pWordInput = passwordFieldController.text;
              final String usernameInput = usernameFieldController.text;
              try {
                //read data from key "agentCreds" and save to Set<String>
                //crud.writeData("id", "asdf", "agentCreds");
              } catch (e) {
                print(e);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Unable to communicate with Database\nKindly try again\nError Code: ${e.toString()}"),
                ));
              }

              if (pWordInput != "p" && usernameInput != "a") {
                //todo: Rewrite logic for login screen
                //EssenKiosk Agent Password
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Invalid Credentials!!!  Non-agents are not authorized into the console."),
                ));
              } else {
                setState(() {
                  loadWidget = CircularProgressIndicator();
                });
                await Future.delayed(const Duration(seconds: 1));
                //proper onTap() implementation of Navigation push, or back button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProviderHome()),
                );
              }
            },
            child: Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // color: Colors.yellow,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                    height: 10,
                  ),
                  Text(
                    "efiJuma Service Provider",
                    style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 35.0),
                  emailField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(
                    height: 25.0,
                  ),
                  loginButton,
                  Divider(
                    color: Colors.transparent,
                    thickness: 10,
                  ),
                  loadWidget,
                  //RaisedButton(onPressed: () async {testImgWidget = Image.file();}, child: Text("Display Image"),), testImgWidget
                ],
              ),
            ),
          ),
        ),
      ),
      //    backgroundColor: Colors.yellow
    );
  }
}

class AgentScreenHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //theme: ThemeData(fontFamily: 'Georgia'),
        home: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('efiJuma Service Provider Console'),
          leading: IconButton(
            tooltip: "Back",
            highlightColor: Colors.grey,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.maybePop(context);
            },
          )),
      body: new ListView(
        padding: const EdgeInsets.all(8.0),
        itemExtent: 106.0,
        children: <CustomListItem>[
          CustomListItem(
            onTapCallback: () => openUserForm(context),
            description: 'Add, Edit or Remove EssenKiosk users',
            thumbnail: Container(
                decoration: new BoxDecoration(
              image: new DecorationImage(
                image:
                    ExactAssetImage('assets/images/agent_manage_userData.png'),
                fit: BoxFit.fitHeight,
              ),
            )),
            title: 'Manage User Data',
          ),
          CustomListItem(
            onTapCallback: () => openHarvestForm(context),
            description: 'Upload, View or Remove EssenKiosk harvests',
            thumbnail: Container(

                /*width: 100.00,
                      height: 100.00,*/ //Manual dimensioning
                decoration: new BoxDecoration(
              image: new DecorationImage(
                image:
                    ExactAssetImage('assets/images/agent_manage_farmData.png'),
                fit: BoxFit.contain,
              ),
            )),
            title: 'Manage Farm Data',
          ),
        ],
      ),
    ));
  }

  openHarvestForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManageMembers()),
    );
  }
}

openUserForm(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text(
                "Dear alpha tester,\nThis functionality is deprecated, but removing this beautiful icon just hurts.\n\nEaster egg?"),
            title: Text("Oops!"),
          ));
}

// ignore: must_be_immutable

// ignore: missing_return
