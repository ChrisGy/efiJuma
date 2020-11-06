import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'GeoLocationClass.dart';
import 'Uploader.dart';
import 'firebaseCRUD.dart' as crud;

class ManageMembers extends StatefulWidget {
  File harvestImage;

  @override
  _ManageFarmDataState createState() => _ManageFarmDataState();
}

class _ManageFarmDataState extends State<ManageMembers> {
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
              "Your Profile",
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

                Divider(
                  color: Colors.white,
                ),
                TextFormField(
                  controller: farmerNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    enabled: false,
                    icon: Icon(Icons.person),
                    hintText: "(surname), (other names)",
                    labelText: "Mr. John Smith",
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
                    labelText: '+233 123123 321',
                    enabled: false,
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                TextFormField(
                  enabled: false,
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.calendar_today_rounded),
                    hintText: "1 (Poor) - 5 (Excellent)",
                    labelText: 'Joined on: 05-Nov-2020',
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
                    labelText: 'Kumasi, Ghana',
                    enabled: false,
                    suffix: Builder(
                      builder: (context) =>
                          FlatButton(
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
                /*Container(
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
                ),*/
                /*_camWidget,
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
                RaisedButton(onPressed: () {}),*/
              ],
            ),
          )),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}

Future<File> getImage({bool isCam = true}) async {
  try {
    final File _ = isCam == true
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
