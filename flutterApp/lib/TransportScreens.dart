import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as UrlOpen;
import 'firebaseCRUD.dart' as crud;

class TransportScreenHome extends StatelessWidget {
  final String helpline = "080010000"; // = Firebase.currentHelpline;
  @override
  Widget build(BuildContext context) {
    Widget offerDetails = Center(
        child: Column(children: [
      Text("1 Order received!", style: TextStyle(fontSize: 18)),
      RaisedButton(
        onPressed: () async {
          UrlOpen.launch("tel://0244542542");
        },
        child: Text("Accept Offer"),
      )
    ]));
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        leading: MaterialButton(
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Transport Agent Home",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hi, Francis Ayaweh", style: TextStyle(fontSize: 20)),
              Image.asset("assets/images/transport_agent.png",
                  width: double.maxFinite),
//              Text(
//                "Transport Agents can use the platform\n by speaking to an EssenKiosk Agent",
//                style: TextStyle(
//                    //color: Colors.green,
//                    fontSize: 20,
//                    fontStyle: FontStyle.normal),
//              ),
              Divider(),
              RaisedButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(child: Icon(Icons.call)),
                    Text(
                      "     Call EssenKiosk     ",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                color: Colors.green,
                onPressed: () => UrlOpen.launch("tel://$helpline"),
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.white60,
              ),
              Divider(
                height: 10,
                color: Colors.white,
              ),
              RaisedButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(child: Icon(Icons.map)),
                    Text(
                      "  View Harvests Map  ",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                color: Colors.green,
                onPressed: () => showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: Stack(fit: StackFit.expand, children: [
                              Image.asset(
                                "assets/images/transport_shot2.jpg",
                                fit: BoxFit.contain,
                              ),
                              Center(
                                  child: Container(
                                      color: Colors.green.withOpacity(0.5),
                                      height: 30,
                                      width: 90,
                                      child: Row(children: [
                                        Icon(
                                          Icons.pin_drop,
                                          color: Colors.white,
                                        ),
                                        Text("harvest",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white))
                                      ])))
                            ])),
                      );
                    }),
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.white60,
              ),
              Divider(color: Colors.transparent, thickness: 2),
              Text("Pending offers:", style: TextStyle(fontSize: 21.5)),
              Divider(color: Colors.green),
              FutureBuilder<dynamic>(
                  future: crud.readData("users/transport/JkS83jscm/isOffered"),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                            child: Column(children: [
                          Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("Loading...")),
                          CircularProgressIndicator()
                        ])); break;
                      default:
                        /*if (!snapshot.hasData)
                          return Center(
                              heightFactor: 2.5,
                              child: Text(
                                  "This has taken longer than expected😢\nPlease wait "));*/
                         if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        else {
                          bool isOffered = snapshot.data;
                          return isOffered
                              ? offerDetails
                              : Text("No offers Available");
                        }
                    }
                  }),
            ],
          ),
        ),
      ),
    ));
  }
}

class TransportProfile {
  String key;
  String transporterID;
  String transporterName;
  String truckLoadCapacityKg;
  String availabiilty; //this is the farmer's phone number
  String centralLocation;
  String image;
  String truckModelName;

  //Set<String> set,    //automated addition. Confirm if there are no problems ******************************
  TransportProfile(
      {this.transporterName,
      this.transporterID, //The ID is the phone number, and is the [key] when pushed to firebase
      this.truckLoadCapacityKg,
      this.availabiilty,
      this.centralLocation,
      this.image,
      this.truckModelName});

/////////////////convert dataset into JSON usable by firebaseCRUD's pushData method
  TransportProfile.fromJson(Map json) {
    this.transporterName = json['transporterName'];
    this.transporterID = json['transporterID'];
    this.truckLoadCapacityKg = json['truckLoadCapacityKg'] ?? '';
    this.availabiilty = json['availabiilty'] ?? '';
    this.centralLocation = json['centralLocation'] ?? '';
    this.image = json['picture'] ?? '';
    this.truckModelName = json['truckModelName'] ?? '';
  }

  //Example format of Set<String> type to be used as input, setStringVariable = {"value1", "value2", "value3"}
  // , where the exact order matters according to the .elementAt() indices below.
  // //all value types are strings.
  TransportProfile.fromString(Set<String> input) {
    this.transporterName = input.elementAt(0);
    this.truckLoadCapacityKg = input.elementAt(1) ?? '';
    this.availabiilty = input.elementAt(2) ?? '';
    this.centralLocation = input.elementAt(3) ?? '';
    this.image = input.elementAt(4) ?? '';
    this.truckModelName = input.elementAt(5) ?? '';
  }

  TransportProfile.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        transporterName = snapshot.value['transporterName'],
        truckLoadCapacityKg = snapshot.value['truckLoadCapacityKg'] ?? '',
        availabiilty = snapshot.value['availabiilty'] ?? '',
        centralLocation = snapshot.value['centralLocation'] ?? '',
        image = snapshot.value['image'] ?? '',
        truckModelName = snapshot.value['truckModelName'] ?? '';

  toJson() {
    return {
      "truckLoadCapacityKg": truckLoadCapacityKg,
      "foodClass": transporterName,
      "centralLocation": centralLocation,
      "availability": availabiilty,
      "truckModelName": truckModelName,
      "image": image,
    };
  }
}
