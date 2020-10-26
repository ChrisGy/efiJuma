import 'dart:io';

import 'package:efijuma_app/CustomLists.dart' show CustomListItem;
import 'package:efijuma_app/GeoLocationClass.dart' as GeoLoc;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:url_launcher/url_launcher.dart' as UrlOpen;

StorageUploadTask getHarvestUploadTask(File input) {
  StorageUploadTask _ = storage
      .ref()
      .child("harvests/images/${Path.basename(input.path)}")
      .putFile(input);

  return _;
}

final rootRef = FirebaseDatabase.instance.reference();
FirebaseStorage storage = new FirebaseStorage();

Future<void> writeData(String mkey, dynamic value, String path) async {
  //implement a push here
  await rootRef.child(path).update({
    mkey: value,
  });
}

//TODO: use the existing writeData method in firebaseCRUD
Future<void> keyPush(String pushKey, String dLoadUrl) async {
  await FirebaseDatabase.instance
      .reference()
      .child("harvests/$pushKey")
      .update({"img": dLoadUrl});
}

Future<String> pushData(String path, FarmHarvest input) async {
  //The input to pushData, "input", must be a JSON string. see class FarmHarvest. Returns push unique ID.
  final DatabaseReference pathref =
      rootRef.child(path); //or trying adding .reference()
  var pushref = pathref.push();

  await pushref.update(input.toJson());
  return pushref.key;
  //site: https://stackoverflow.com/questions/29140887/how-to-push-in-firebase-dart
}

// ignore: missing_return
Future<dynamic> readData(String child) async {
  DataSnapshot ds;
  ds = await rootRef.child(child).once();
  return ds.value;
}

void deleteData(String path) {
  rootRef.child(path).remove();
}

Future<String> uploadFile(File file, String pathStr) async {
  StorageReference storageRef = storage.ref().child(
      "$pathStr/${Path.basename(file.path)}"); //FirebaseStorage.instance.ref();
  // final StorageUploadTask uploadTask = storageRef.putFile(file);
  final String dLoadURL = await storageRef.getDownloadURL();
  return dLoadURL ??
      'https://firebasestorage.googleapis.com/v0/b/essenkiosk1.appspot.com/o/harvests%2Fimages%2FdefaultHarvestImage.png?alt=media&token=a13ed895-10ac-4f11-97d1-a6d24f07ca9b';
}

///////////////////////// Classes //////////////////////////
//ignore:must_be_immutable
class FarmHarvest extends StatefulWidget {
  //String key;
  String foodClass;
  String price;
  String farmerID; //this is the farmer's phone number
  String farmLocation;
  String img; //Firebase Storage location of harvest image path
  String quality;
  String farmerName;
  String timeStamp;

  FarmHarvest(
      { //this.key,
      this.foodClass,
      this.price,
      this.farmerID,
      this.farmLocation,
      this.img,
      this.quality,
      this.farmerName,
      this.timeStamp});

/////////////////convert dataset into JSON usable by firebaseCRUD's pushData method
/*  FarmHarvest.fromJson(Map<dynamic,dynamic> json) {
    this.foodClass = json['foodClass'];
    this.price = json['price'] ?? '';
    this.farmerID = json['farmerID'] ?? '';
    this.farmLocation = json['farmLocation'] ?? '';
    this.img = json['img'] ?? '';
    this.quality = json['quality'] ?? '';
    this.farmerName = json['farmerName'] ?? '';
    this.timeStamp = json['timeStamp'] ?? '';
  }*/

  factory FarmHarvest.fromJson(Map<dynamic, dynamic> json) {
    return FarmHarvest(
        foodClass: json['foodClass'].toString() ?? '',
        price: json['price'].toString() ?? '',
        farmerID: json['farmerID'].toString() ?? '',
        farmLocation: json['farmLocation'].toString() ?? '',
        img: json['img'].toString() ?? '',
        quality: json['quality'].toString() ?? '',
        farmerName: json['farmerName'].toString() ?? '',
        timeStamp: json['timeStamp'].toString() ?? '');
  }

  //Example format of Set<String> type to be used as input, setStringVariableInput = {"value1", "value2", "value3"}
  // , where the exact order is, foodClass, price, farmerID, farmLocation, image, quality.
  // //all value types are strings.
  //TODO: replace with [FarmHarvest.fromJSON]. this is ridiculous.
  FarmHarvest.fromString(Set<String> input) {
    this.foodClass = input.elementAt(0) ?? '';
    this.price = input.elementAt(1) ?? '';
    this.farmerID = input.elementAt(2) ?? '';
    this.farmLocation = input.elementAt(3) ?? '';
    this.img = input.elementAt(4) ??
        'https://firebasestorage.googleapis.com/v0/b/essenkiosk1.appspot.com/o/harvests%2Fimages%2FdefaultHarvestImage.png?alt=media&token=a13ed895-10ac-4f11-97d1-a6d24f07ca9b';
    //'harvests/images/essenkiosk_logo.jpg';
    this.quality = input.elementAt(5) ?? '';
    this.farmerName = input.elementAt(6) ?? '';
    this.timeStamp = input.elementAt(7) ?? '';
  }

  FarmHarvest.fromSnapshot(DataSnapshot snapshot)
      : //key = snapshot.key,
        foodClass = snapshot.value['foodClass'],
        price = snapshot.value['price'] ?? '',
        farmerID = snapshot.value['farmerID'] ?? '',
        farmLocation = snapshot.value['farmLocation'] ?? '',
        img = snapshot.value['img'] ?? '',
        quality = snapshot.value['quality'] ?? '',
        farmerName = snapshot.value['farmerName'] ?? '',
        timeStamp = snapshot.value['timeStamp'];

  toJson() {
    return {
      "price": price,
      "foodClass": foodClass,
      "farmLocation": farmLocation,
      "farmerID": farmerID,
      "quality": quality,
      "img": img,
      "key": key,
      "farmerName": farmerName,
      "timeStamp": timeStamp,
    };
  }

  @override
  _FarmHarvestState createState() => _FarmHarvestState();
}

class _FarmHarvestState extends State<FarmHarvest> {
  @override
  Widget build(BuildContext context) {
    Image imagethumb = Image.network(
      this.widget.img ?? "",
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );

    void openBuyerDetails(BuildContext context) {
      debugPrint("open buyer details");
      showModalBottomSheet(
          isDismissible: true,
          enableDrag: true,
          isScrollControlled: false,
          backgroundColor: Colors.transparent.withOpacity(0.5),
          clipBehavior: Clip.hardEdge,
          elevation: 1,
          context: context,
          builder: (context) => Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topCenter,
                      height: 40,
                      color: Colors.green.withOpacity(0.5),
                      child: IconButton(
                          iconSize: 38,
                          icon: Icon(Icons.keyboard_arrow_down),
                          color: Colors.green,
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  Expanded(
                    child: ListView(
                        /* expand: true,
                    initialChildSize: 0.4,
                    maxChildSize: 1.0,
                    builder: (context, ScrollController scrollController) {
                      return Column(*/
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: imagethumb,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.map),
                                color: Colors.green,
                                onPressed: () {
                                  UrlOpen.launch(
                                      'http://maps.google.com?q="${this.widget.farmLocation}"');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.directions_car),
                                color: Colors.green,
                                tooltip: "Get Transporter",
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return Center(
                                          child: Container(
                                            height: 450,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.92,
                                            child: Card(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  Text("Nearest Transporter",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Image.asset(
                                                    "assets/images/dummytran.jpg",
                                                    fit: BoxFit.fitWidth,
                                                    scale: 0.2,
                                                  ),
                                                  Text("Kia Rhino",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text(
                                                      "Driver:\t\t\t\t\t\t\t\t        Francis Ayaweh",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Text(
                                                      "Gross Weight:\t\t12,000 kg\n",
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Divider(
                                                      color: Colors.transparent,
                                                      thickness: 5),
                                                  RaisedButton(
                                                      onPressed: () async {
                                                        await writeData(
                                                            "isOffered",
                                                            true,
                                                            "users/transport/JkS83jscm");
                                                        showDialog(
                                                            context: context,
                                                            child: Center(
                                                              child: Text(
                                                                "Order sent!",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ));
                                                      },
                                                      child: Row(children: [
                                                        Icon(Icons.check),
                                                        Text("Accept",
                                                            style: TextStyle(
                                                                fontSize: 20))
                                                      ])),
                                                  Text(
                                                      "Transporter is available")
                                                ])),
                                          ),
                                        );
                                      });
                                },
                              ),
                              IconButton(
                                  icon: Icon(Icons.call),
                                  color: Colors.green,
                                  onPressed: () {
                                    UrlOpen.launch(
                                        "tel://${this.widget.farmerID}");
                                  }),
                            ],
                          ),
                          Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Text("Farmer's Name"),
                                subtitle: Text(this.widget.farmerName != "null"
                                    ? this.widget.farmerName
                                    : "Unknown"),
                              )),
                          Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Text("Quality"),
                                subtitle: Text(this.widget.quality != "null"
                                    ? "${this.widget.quality} / 5"
                                    : "Unknown"),
                              )),
                          if (this.widget.quality != "null")
                            Container(
                                color: Colors.white,
                                child: LinearProgressIndicator(
                                    value:
                                        double.tryParse(this.widget.quality))),
                        ]),
                  ),
                ],
              ));
    }

    return Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        child: Card(
          //semanticContainer: false ,
          margin: EdgeInsets.all(2),
          elevation: 0.5,
          child: FutureBuilder<String>(
              future: GeoLoc.getAddressFromLatLng(widget.farmLocation),
              initialData: "Loading...",
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return Container();
                return CustomListItem(
                  onTapCallback: () => openBuyerDetails(this.context),
                  title: "\n${this.widget.foodClass}, GHC ${this.widget.price}",
                  description:
                      "${DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.widget.timeStamp ?? '0')).toString().split(" ")[0] ?? "Upload Time: N/A"}\n"
                      "Location: ${snapshot.data ?? GeoLoc.getAddressFromLatLng(snapshot.data) ?? 'N/A'}",
                  thumbnail: imagethumb,
                );
              }),
        ));
  }
}
