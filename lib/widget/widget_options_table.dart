
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetOptionsTables extends StatefulWidget {
  @override
  _WidgetOptionsTablesState createState() => _WidgetOptionsTablesState();
}

class _WidgetOptionsTablesState extends State<WidgetOptionsTables> {
  bool _allowSorting = true;
  bool _allowMultiSorting = false;
  bool _allowTriStateSorting = false;
  bool _allowColumnSorting = true;
  bool _showSortNumbers = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
        child: Stack(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Settings',
                  style: TextStyle(

                      fontSize: 18,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.w500)),
              IconButton(
                icon: Icon(
                  Icons.close,

                ),
                onPressed: () {
                  Navigator.pop(context,[_allowSorting]);
                },
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    title:
                    Text('Allow sorting', style: TextStyle()),
                    trailing: Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: _allowSorting,
                          onChanged: (bool value) {
                            setState(() {
                              print(_allowSorting);
                              _allowSorting = value;
                            });
                          },
                        )),
                  ),
                  ListTile(
                      title: Text('Allow multiple column sorting',
                          style: TextStyle()),
                      trailing: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: _allowMultiSorting,
                            onChanged: (bool value) {
                              setState(() {
                                _allowMultiSorting = value;
                              });
                            },
                          ))),
                  ListTile(
                      title: Text('Allow tri-state sorting',
                          style: TextStyle()),
                      trailing: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: _allowTriStateSorting,
                            onChanged: (bool value) {
                              setState(() {
                                _allowTriStateSorting = value;
                              });
                            },
                          ))),
                  ListTile(
                    trailing: Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: _allowColumnSorting,
                          onChanged: (bool value) {
                            setState(() {
                              _allowColumnSorting = value;

                            });
                          },
                        )),
                    title: Text('Allow sorting for the Name column',
                        style: TextStyle()),
                  ),
                  ListTile(
                      title: Text('Display sort sequence numbers',
                          style: TextStyle()),
                      trailing: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: _showSortNumbers,
                            onChanged: (bool value) {
                              setState(() {
                                _showSortNumbers = value;

                              });
                            },
                          ))),
                ],
              ),)
        ]),
      )



    );
  }
}
