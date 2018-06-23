import 'package:flutter/material.dart';
import 'login.dart';
import 'auth.dart';
import 'home_page.dart';


class Home extends StatefulWidget{
  Home({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomeState();
  }


}
enum AuthStatus{
  notSignedIn,
  signedIn
}

class _HomeState extends State<Home>{


  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    widget.auth.currentUser().then((email){
      setState(() {
        authStatus = email== null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn(){
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch(authStatus) {
      case AuthStatus.notSignedIn:
        return new Login(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return new HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
    return null;
  }

}


