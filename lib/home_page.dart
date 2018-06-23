import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {

  HomePage({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _HomePageState();


}
  class _HomePageState extends State<HomePage>{

  var details_fetched;



  void _signOut() async{

    try{
      await widget.auth.signOut();
      widget.onSignedOut();

    }catch(e) {
      print(e);
    }
  }



  @override
  void initState()  {
      super.initState();
      widget.auth.currentUser().then((email) {
        setState(() {
          Firestore.instance.collection('users')
              .where('email', isEqualTo: email)
              .snapshots().listen(
                  (data){
                data.documents.forEach((doc) => details_fetched=doc.data);
              }
          );
        });
      });
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('HOME'),
          actions: <Widget>[
            new FlatButton(
                onPressed: _signOut,
                child: new Text('Signout', style: new TextStyle(fontSize: 17.0, color: Colors.white))
            )
          ]
      ),
      body:


      new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Card(
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.all(30.0),
                        child:new Image.network(details_fetched["imageurl"]),
                      ),
                      new Container(
                        child: new Text('${details_fetched["name"]}\n\n${details_fetched["email"]}'),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ],
        ),

        // Load image from network


//          child:new Text("${details_fetched["name"]}, ${details_fetched["email"]}, ${details_fetched["imageurl"]}", style: new TextStyle(fontSize: 12.0))

            ),


    );
  }
}


