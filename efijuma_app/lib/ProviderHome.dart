import 'package:efijuma_app/ManageMembers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'firebaseCRUD.dart' as crud;
import 'package:url_launcher/url_launcher.dart' as urlOpen;

class ProviderHome extends StatefulWidget {
  @override
  _ProviderHomeState createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.person_rounded),
            tooltip: "Manage Profile",
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ManageMembers())),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Current Offers Received:\n",
                style: TextStyle(fontSize: 20),
              ),
              FutureBuilder(
                  future: crud.readData("efijuma/offers"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done)
                      return CircularProgressIndicator();
                    else {
                      print(snapshot.data);
                      List<Offer> offerList = [];
                      snapshot.data.forEach((offerKey, offerVal) {
                        print(offerKey);
                        offerList.add(Offer(
                          buyerName: snapshot.data[offerKey]['buyerName'],
                          buyerNumber: snapshot.data[offerKey]['buyerNumber'],
                          service: snapshot.data[offerKey]['service'],
                        ));
                      });
                      if (offerList.isEmpty) return Text("No offers");
                      return Column(
                        children: offerList,
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class Offer extends StatelessWidget {
  final String buyerName;
  final String buyerNumber;
  final String service;

  Offer({this.buyerName, this.buyerNumber, this.service});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async => await urlOpen.launch("tel://${this.buyerNumber}"),
      leading: Icon(Icons.person_pin ?? ""),
      title: Text(this.buyerNumber ?? ""),
      trailing: Text(this.buyerName ?? ""),
      subtitle: Text(this.service ?? ""),
    );
  }
}
