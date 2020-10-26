import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.thumbnail,
    this.title,
    this.description,
    this.onTapCallback,
  });

  final Widget thumbnail;
  final String title;
  final String description;

  final VoidCallback onTapCallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        highlightColor: Colors.lightGreen,
        focusColor: Colors.lightGreen,
        splashColor: Colors.lightGreen,
        onTap: onTapCallback,
        child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: thumbnail,
              ),
              Expanded(
                flex: 3,
                child: _BoxDescription(
                  title: title,
                  descr: description,
                ),
              ),
            ],
          ),
        ));
  }
}

class _BoxDescription extends StatelessWidget {
  const _BoxDescription({
    Key key,
    this.title,
    this.descr,
  }) : super(key: key);

  final String title;
  final String descr;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          //padding: const EdgeInsets.all(0),
          //EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  //height: 0.1,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 0.0)),
              Text(
                descr,
                style: const TextStyle(fontSize: 14.0),
                softWrap: true,
                textScaleFactor: 1,
              ),
              //const Padding(padding: EdgeInsets.symmetric(vertical: 0.0)),
            ],
          ),
        ),
      ],
    );
  }
}
