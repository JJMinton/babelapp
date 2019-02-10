import 'package:flutter/material.dart';

import '../services/authentication.dart';
import 'login_page.dart';
import 'home_page.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}


class AuthenticationCheckPage extends StatefulWidget {
  AuthenticationCheckPage({this.auth});

  final BaseAuth auth;

  @override
  State<AuthenticationCheckPage> createState() => _AuthenticationCheckPageState();
}

class _AuthenticationCheckPageState extends State<AuthenticationCheckPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user?.uid != null ? user.uid.toString() : "";
        authStatus = user?.uid != null ? AuthStatus.LOGGED_IN : AuthStatus.NOT_LOGGED_IN;
      });
    });
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      _onSignedOut();
    } catch (e) {
      print(e);
    };
  }

  void _onSignedIn() {
    widget.auth.getCurrentUser().then((user){
      setState(() => _userId = user.uid.toString());
    });
    setState(() => authStatus = AuthStatus.LOGGED_IN);
  }

  void _onSignedOut() {
    setState((){
      _userId = "";
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch(authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginPage(
          auth: widget.auth,
          onSignedIn: _onSignedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId != null && _userId.length > 0) {
          return HomePage(
            userId: _userId,
            signOut: _signOut,
          );
        }
        return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}