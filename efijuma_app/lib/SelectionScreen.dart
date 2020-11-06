import 'package:flutter/material.dart';
import 'firebaseCRUD.dart' as crud;
import 'package:url_launcher/url_launcher.dart' as urlOpen;

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Specify efiJuma"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Text("Your location is Kumasi"),
              Text("Available efiJuma:\n\n"),
              FutureBuilder(
                  future: crud.readData("efijuma/providers"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done)
                      return CircularProgressIndicator();
                    else {
                      if (snapshot.data == null)
                        return Text("No closeby providers");
                      print(snapshot.data);
                      List<ProviderModel> offerList = [];
                      snapshot.data.forEach((offerKey, offerVal) {
                        print(offerKey);
                        offerList.add(ProviderModel(
                          providerName: snapshot.data[offerKey]['providerName'],
                          providerNumber: snapshot.data[offerKey]
                          ['providerNumber'],
                          service: snapshot.data[offerKey]['service'],
                        ));
                      });
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

class ProviderModel extends StatelessWidget {
  final String providerName;
  final String providerNumber;
  final String service;

  ProviderModel({this.providerName, this.providerNumber, this.service});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.lightGreenAccent,
      onTap: () async =>
          Scaffold.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 2), content: Text("Offer Sent!"))),
      leading: IconButton(
        icon: Icon(Icons.contact_mail_rounded),
        onPressed: () async =>
        await urlOpen.launch("tel://${this.providerNumber}"),
      ),
      title: Text(this.providerNumber ?? ""),
      trailing: Text(this.providerName ?? ""),
      subtitle: Text(this.service ?? ""),
    );
  }
}
