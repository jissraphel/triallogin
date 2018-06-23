import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {

  Login({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  State<StatefulWidget> createState() => new _LoginState();

}

enum FormType {

  login,
  register
}


class _LoginState extends State<Login> {

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  void signInWithGoogle() async {


    FirebaseUser user = await widget.auth.signInWithGoogle();

  Firestore.instance.runTransaction((Transaction transaction) async{

    CollectionReference reference = Firestore.instance.collection('users');

    await reference.add({
      "name": user.displayName,
      "email": user.email,
      "imageurl": user.photoUrl,

                        });
    });

    widget.onSignedIn();
  }


  void signInWithFacebook() async {


  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signInWithEmailAndPassword(
              _email, _password);
          print("Signed with $userId");
        } else {
          String userId = await widget.auth.createUserWithEmailAndPassword(
              _email, _password);
          print('Registered $userId');
        }
        widget.onSignedIn();
      }
      catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    setState(() {
      _formType = FormType.login;
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('TrialApp'),

      ),
      body: new Column(
          children: <Widget>[


            new Container(
              padding: EdgeInsets.all(20.0),
              child: new Form(
                key: formKey,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildInputs() + buildButtons(),
                ),
              ),

            ),


            new Container(
              child: new Text(
                  "------------------------------------OR----------------------------------------"),
              margin: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
            ),


            new Container(
              child: new Text(""),
              margin: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            ),
            new Container(
                padding: new EdgeInsets.all(20.0),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[


                      new RaisedButton(
                        child: new Text("LOG IN WITH FACEBOOK"),
                        color: Colors.blueAccent,
                        onPressed: signInWithFacebook,
                      ),
                    ]
                )
            ),
            new Container(
              child: new Text(""),
              margin: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            ),

            new Container(
                padding: new EdgeInsets.all(20.0),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[


                      new RaisedButton(
                        child: new Text("LOG IN WITH GOOGLE"),
                        color: Colors.redAccent,
                        onPressed: signInWithGoogle,
                      ),
                    ]
                )
            ),


          ]
      ),


    );
  }

  List <Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email Field is empty' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Give Valid Password' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }


  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return [

        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
          color: Colors.greenAccent,
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text(
              'create an account', style: new TextStyle(fontSize: 15.0)),

          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text(
              'create an account', style: new TextStyle(fontSize: 20.0)),
          color: Colors.greenAccent,
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text(
              'already created', style: new TextStyle(fontSize: 15.0)),

          onPressed: moveToLogin,
        )
      ];
    }
  }

}
