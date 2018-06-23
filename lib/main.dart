import 'package:flutter/material.dart';
//import 'login.dart';
import 'auth.dart';
import 'home.dart';

void main(){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        title: 'trial',
        theme:new ThemeData(
          primarySwatch: Colors.blue,

        ),
        home: new Home(auth: new Auth())

    );
  }
}