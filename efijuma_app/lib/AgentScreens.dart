import 'dart:io';

import 'GeoLocationClass.dart';
import 'Uploader.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'CustomLists.dart';
import 'firebaseCRUD.dart' as crud;

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
            onPressed: () {
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

              if (pWordInput != "agent1" && usernameInput != "pass") {
                //todo: Rewrite logic for login screen
                //EssenKiosk Agent Password
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Invalid Credentials!!!  Non-agents are not authorized into the console."),
                ));
              } else {
                //proper onTap() implementation of Navigation push, or back button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageFarmData()),
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
          title: Text('EssenKiosk Agent Console'),
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
      MaterialPageRoute(builder: (context) => ManageFarmData()),
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
class ManageFarmData extends StatefulWidget {
  File harvestImage;

  @override
  _ManageFarmDataState createState() => _ManageFarmDataState();
}

class _ManageFarmDataState extends State<ManageFarmData> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Widget _camWidget = Text("No Image Selected");
  final farmerIDController = TextEditingController();

  final foodClassController = TextEditingController();

  final priceController = TextEditingController();

  final qualityController = TextEditingController();

  final farmerNameController = TextEditingController();

  final farmLocationController = TextEditingController();

  String _captureHarvestTxt = "Capture Harvest";

  final imgController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    imgController.dispose();
    qualityController.dispose();
    farmerNameController.dispose();
    farmLocationController.dispose();
    priceController.dispose();
    foodClassController.dispose();
    farmerIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Set<String> objectInput;
    Map<dynamic, dynamic> objectInput;

//try{createHarvImg();}catch(e)  {harvestImage?.existsSync() ? harvestImage.deleteSync(): createHarvImg();}

    crud.FarmHarvest dataToSend;
    void imageFunctions() {
      if (super.widget.harvestImage != null) {
        setState(() {
          _camWidget = Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Image.file(
              super.widget.harvestImage,
              fit: BoxFit.cover,
            ),
          );
          _captureHarvestTxt = "Re-capture Harvest";
        });
      } else {
        _camWidget = Text("Image capture failed\nError: harvestImage is null");
      }
    }

    return MaterialApp(
      home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              "Harvest Upload Form",
              style: TextStyle(fontSize: 25),
            ),
            backgroundColor: Colors.green,
            leading: IconButton(
              tooltip: "Back",
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                Center(
                    heightFactor: 1.4,
                    child: Text(
                      "The fields marked * are required.\nTap the Submit button at the bottom of\n the screen to complete the upload.",
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    )),
                Divider(
                  color: Colors.white,
                ),
                TextFormField(
                  controller: farmerNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    hintText: "(surname), (other names)",
                    labelText: "Farmer's name",
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                TextFormField(
                  controller: farmerIDController,
                  keyboardType: TextInputType.phone,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    prefix: Text("+233 "),
                    border: UnderlineInputBorder(),

                    filled: true,
                    icon: Icon(Icons.local_phone),
                    //hintText: "",
                    labelText: 'FarmerID/Phone *',
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                TextFormField(
                  controller: foodClassController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.library_books),
                    hintText: "Eg; Cassava, Tomato, Rice etc...",
                    labelText: 'Class of Food *',
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.monetization_on),
                    prefixText: "GHC",
                    suffixText: "per kg",
                    labelText: 'Pricing per kg *',
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                TextFormField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.grade),
                    hintText: "1 (Poor) - 5 (Excellent)",
                    labelText: 'Quality Grade ',
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                TextFormField(
                  controller: farmLocationController,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.location_on),
                    hintText: "Manually enter or tap button to use GPS",
                    labelText: 'Harvest Location',
                    enabled: false,
                    suffix: Builder(
                      builder: (context) => FlatButton(
                        child: Text("Get Location",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          String a;
                          a = await getCurrentLocation();
                          setState(() {
                            farmLocationController.text = a.toString();
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        _captureHarvestTxt,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      Center(
                          child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.photo_album),
                            iconSize: 40,
                            // Get Harvest Image button
                            onPressed: () async {
                              super.widget.harvestImage =
                                  await getImage(isCam: false);

                              imageFunctions();
                            },
                            color: Colors.green,
                          ),

                          // Capture Harvest Image button
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            iconSize: 40,
                            // Get Harvest Image button
                            onPressed: () async {
                              super.widget.harvestImage = await getImage();

                              imageFunctions();
                            },
                            color: Colors.green,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      )),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 0),
                ),
                _camWidget,
                //TODO: remake RaisedButton into Builder
                RaisedButton(
                  //Submit button
                  onPressed: () async {
                    String dLoadUrl =
                        "https://firebasestorage.googleapis.com/v0/b/essenkiosk1.appspot.com/o/harvests%2Fimages%2FdefaultHarvestImage.png?alt=media&token=a13ed895-10ac-4f11-97d1-a6d24f07ca9b"; //TODO: replace with actual link two lines below
                    print(
                        "onPressed harvestimage is ${super.widget.harvestImage}");
                    //"'https://firebasestorage.googleapis.com/v0/b/essenkiosk1.appspot.com/o/harvests%2Fimages%2FdefaultHarvestImage.png?alt=media&token=a13ed895-10ac-4f11-97d1-a6d24f07ca9b'";
                    objectInput = {
                      "price": this.priceController.text,
                      "foodClass": this.foodClassController.text,
                      "farmLocation": this.farmLocationController.text,
                      "farmerID": this.farmerIDController.text,
                      "quality": this.qualityController.text,
                      "img": dLoadUrl,
                      "farmerName": this.farmerNameController.text,
                      "timeStamp": DateTime.now()
                          .millisecondsSinceEpoch
                          .toString() //TODO: Replace with server time
                    };
                    print(
                        "objectinput $objectInput length is ${objectInput.length}");

                    if (this.widget.harvestImage != null) {
                      dataToSend = new crud.FarmHarvest.fromJson(objectInput);
                      String pushKey =
                          await crud.pushData("harvests", dataToSend);
                      Widget dBwidget = Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.check),
                            Text(
                                "Database successfully updated with harvest data")
                          ]);
                      List<Widget> camWidgetChildren = [dBwidget];
                      _camWidget = Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: Column(
                          children: camWidgetChildren,
                        ),
                      );

                      Uploader upl = new Uploader(
                        pushKey: pushKey,
                        task: crud
                            .getHarvestUploadTask(super.widget.harvestImage),
                      );
                      print("upl instance created with uploadtask");

                      setState(() {
                        camWidgetChildren.add(upl);
                      });
                    } else {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Kindly provide an image of the harvest"),
                      ));
                    }
                  },
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.cloud_upload, color: Colors.white),
                      Text(
                        " Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: "Georgia"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}

// ignore: missing_return
Future<File> getImage({bool isCam = true}) async {
  try {
    File _ = isCam == true
        ? await ImagePicker.pickImage(
            source: ImageSource.camera, imageQuality: 40)
        : await ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 40);
    return _;
    //String fileName = path.basename(image.path);  // TODO: how to get image filename
  } catch (e) {
    print("getImage error!\n$e");
  }
}
