import 'package:flutter/material.dart';


class SignOutScaffold extends Scaffold {


  SignOutScaffold({
    Key key,
    title,
    signOut,
    body,
    floatingActionButton,
    floatingActionButtonLocation,
    floatingActionButtonAnimator,
    persistentFooterButtons,
    drawer,
    endDrawer,
    bottomNavigationBar,
    bottomSheet,
    backgroundColor,
    resizeToAvoidBottomPadding = true,
    primary = true,
  }) : super(
    key: key,
    appBar: AppBar(
      title: Row(
        children: <Widget>[
          Text(title),
          RaisedButton(
            child: Text('Sign Out'),
            onPressed: signOut,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      )
    ),
    body: body,
    floatingActionButton: floatingActionButton,
    floatingActionButtonLocation: floatingActionButtonLocation,
    floatingActionButtonAnimator: floatingActionButtonAnimator,
    persistentFooterButtons: persistentFooterButtons,
    drawer: drawer,
    endDrawer: endDrawer,
    bottomNavigationBar: bottomNavigationBar,
    bottomSheet: bottomSheet,
    backgroundColor: backgroundColor,
    resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
    primary: primary,
  );

}