import 'package:flutter/material.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Select Preferences"),
          Padding(
            padding: EdgeInsets.all(10),
          )
        ],
      ),
    );
  }
}
