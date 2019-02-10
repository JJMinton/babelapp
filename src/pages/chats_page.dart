import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './messaging_page.dart';
import '../services/database.dart';
import '../templates/signout_scaffold_template.dart';
import '../enums/languages.dart';

class ChatsPage extends StatelessWidget {
  final VoidCallback signOut;
  final String _uid;
  final Languages _language;
  String _chatId = "";

  ChatsPage(this._language, this._uid, this.signOut);

  @override
  Widget build (BuildContext context) {
    return SignOutScaffold(
      title: "My Chats",
      signOut: this.signOut,
      body: Column(
        children: <Widget>[
          _showJoinChatInput(),
          _showJoinChatButton(),
          _showCreateChatButton(),
          _showJoinedChats(),
        ],
        mainAxisSize: MainAxisSize.min,
      )
    );
  }

  Widget _showCreateChatButton() {
    return RaisedButton(
            child: Text('Create New Chat'),
            onPressed: createNewChat,
          );
  }

  Widget _showJoinChatButton() {
    return RaisedButton(
      child: Text('Join Babel Chat'),
      onPressed: joinChat,
    );
  }

  Widget _showJoinChatInput() {
    return TextField(
      maxLines: 1,
      autofocus: false,
      decoration: new InputDecoration(
        hintText: 'Chat ID',
        icon: Icon(Icons.chat_bubble, color: Colors.white),
      ),
      onChanged: (value) {
        print(value);
        _chatId = value;
      },
    );
  }

  Widget _showJoinedChats() {
    return StreamBuilder<QuerySnapshot>(
      stream: DBService.getUsersChats(this._uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text("Error: ${snapshot.error}");
        if (snapshot.connectionState == ConnectionState.waiting)
          return new Text("Loading");
        return new Flexible(
          child: ListView(
            children: snapshot.data.documents.map(
              (DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document.documentID),
                  subtitle: new Text("${document['messages'] == null ? 0 : document['messages'].length} Messages"),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MessagingPage(_language, _uid, document.documentID))),
                );
              }
            ).toList(),
          )
        );
      }
    );
  }

  void createNewChat (){
    DBService.createNewChat(_uid);
  }

  void joinChat() {
    DBService.joinChat(_chatId, _uid);
  }

}