import 'package:flutter/material.dart';
import 'package:litera/menu.dart';
import 'package:litera/globals.dart';

class PageContact extends StatefulWidget {
  @override
  _PageContactState createState() => _PageContactState();
}

class _PageContactState extends State<PageContact> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(getAssetsVocab('CONTACT')),
      ),
      drawer: () {
        Menu();
      } (),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                devEmail,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

}