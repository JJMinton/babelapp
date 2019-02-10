import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/database.dart';
import '../templates/signout_scaffold_template.dart';

class PeoplePage extends StatelessWidget {
  VoidCallback signOut;

  PeoplePage(this.signOut);

  @override
  Widget build(BuildContext context) {
    return SignOutScaffold(
      title: "People",
      signOut: this.signOut,
      body: PersonStream(),
    );
  }
}

class PersonStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DBService.getUsers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map(
                (DocumentSnapshot document) {
                  return new ListTile(
                    title: new Text(document['displayName']),
                    subtitle: new Text(document['email']),
                  );
                }
              ).toList(),
            );
        }
      }
    );
  }
}