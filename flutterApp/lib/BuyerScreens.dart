import 'package:essenkiosk1/firebaseCRUD.dart'
    show FarmHarvest; //RecipeDetailListItem
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class HarvestList {
  //RecipeList
  List<FarmHarvest> harvestList;

  HarvestList({this.harvestList});

  factory HarvestList.fromJSON(Iterable it) {
    List<FarmHarvest> hlist = [];
    it.forEach((val) {
      FarmHarvest fh = new FarmHarvest.fromJson(val as Map<dynamic, dynamic>);

      hlist.add(fh);
    });

    return HarvestList(harvestList: hlist);
  }
}

class MakeCall {
  List<FarmHarvest> listItems = [];
  Future<List<FarmHarvest>> firebaseCalls(DatabaseReference databaseReference) async {
    HarvestList harvestList;
    Query fbquery = databaseReference.child("harvests").orderByChild("quality");
    //DataSnapshot dataSnapshot = await databaseReference.once();
    DataSnapshot dataSnapshot = await fbquery.once();
    Map<dynamic, dynamic> jsonResponse = dataSnapshot.value;
print("unsorted resp "+jsonResponse.values.toList().toString());
    harvestList = new HarvestList.fromJSON(jsonResponse.values);
    listItems.addAll(harvestList.harvestList);
  //  listItems.sort((b, a) => a.(int.tryParse(price)).compareTo(b.price)); //TODO: replace by ranking function
    return listItems;
  }
}

class BuyerScreenHome extends StatefulWidget {
  @override
  BuyerScreenHomeState createState() => BuyerScreenHomeState();
}

class BuyerScreenHomeState extends State<BuyerScreenHome> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final databaseReference = FirebaseDatabase.instance.reference();
  MakeCall makecall = new MakeCall();

  final Widget loadingHarvests = Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Loading Harvests..."),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        CircularProgressIndicator()
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    Widget emptyHarvests = Container(
      child: Column(
        children: <Widget>[
          Icon(Icons.error_outline),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Text("Harvest database is empty.\nRefresh or Try again later")
        ],
      ),
    );
//var lvb = new ListView.builder(itemBuilder: null);
    var futureBuilder = new FutureBuilder(
      future: makecall.firebaseCalls(databaseReference), // async work
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return loadingHarvests;
          default:
            if (snapshot.hasError)
            {  return new Text('Error: ${snapshot.error}\nSnapshot Data: $snapshot\nMakecall.lisitems: \n${makecall.listItems}');}
          else  if (!snapshot.hasData)
              return emptyHarvests;
            else if (makecall.listItems.length == 0)
              return emptyHarvests;

            else
              return SingleChildScrollView(
                child: Column(
                  children: makecall.listItems,
                ),
              );

        }
      },
    );

    int appBarInt = 0;

    PreferredSizeWidget searchAppBar = AppBar();

    PreferredSizeWidget defAppBar = AppBar(centerTitle: true,
      backgroundColor: Colors.green,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        )
      ],
      title: Text('Harvests'),
    );
    List<PreferredSizeWidget> appBarStates = [defAppBar, searchAppBar];

    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
                  child: Icon(Icons.refresh),
                  tooltip: "Reload",
                  backgroundColor: Colors.green,
                  splashColor: Colors.lightGreen,
                  onPressed: () {
                    setState(() {
                      makecall = new MakeCall();
                    });
                  },
                )),
        appBar: appBarStates[appBarInt],
        resizeToAvoidBottomPadding: false,
        body: futureBuilder);
  }
}
