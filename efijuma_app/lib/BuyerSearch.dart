import 'package:flutter/material.dart';
import 'GeoLocationClass.dart' as GeoLoc;
import 'DbQueries.dart' as dbquery;
import 'package:flutter/animation.dart';

class BuyerMainSearch extends StatefulWidget {
  @override
  _BuyerMainSearchState createState() => _BuyerMainSearchState();
}

class _BuyerMainSearchState extends State<BuyerMainSearch>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEditingController = new TextEditingController();
  String responseText = "";
  AnimationController _playAnimation;
  String animVal = "";

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    _playAnimation =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
    _playAnimation.addListener(() {
      setState(() {
        animVal = _playAnimation.value.toStringAsPrecision(2);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _playAnimation.dispose();
  }

  @override
  Widget build(BuildContext context) {
    searchFunction(String queryText) {
      setState(() {
        responseText = queryText;
      });
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green,
            centerTitle: false,
            title: Row(children: [
              Expanded(
                child: TextField(
                  onSubmitted: (queryText) => searchFunction(queryText),
                  controller: _textEditingController,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  // onChanged: (queryText) => searchFunction(queryText)
                ),
              ),
              IconButton(
                  icon: Text("Go"),
                  onPressed: () {
                    String queryText = _textEditingController.text;
                    searchFunction(queryText);
                  })
            ])),
        body: Center(
            child: Column(
          children: [
            Text(responseText),
            RaisedButton(
              child: Text("test1"),
              onPressed: () async {
                String current = await GeoLoc.getCurrentLocation();
                double currentLat = double.parse(current.split(",")[0]);
                double currentLng = double.parse(current.split(",")[1]);
                double loc = await GeoLoc.geolocator.distanceBetween(
                  currentLat,
                  currentLng,
                  6.6756377,
                  -1.5699161,
                );
                print(loc);
              },
            ),
            RaisedButton(
              child: Text("animation forward"),
              onPressed: () {
                setState(() {
                  _playAnimation.forward();
                });
              },
            ),
            RaisedButton(
              child: Text("animation reverse"),
              onPressed: () {
                setState(() {
                  _playAnimation.value < 0.49
                      ? _playAnimation.forward()
                      : _playAnimation.reverse();
                });
              },
            ),
            AnimatedIcon(
              icon: AnimatedIcons.arrow_menu,
              progress: _playAnimation,
            ),
            Text(animVal)
          ],
        )));
  }
}
