import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/languages.dart';
import '../services/database.dart';


class MessagingPage extends StatelessWidget{
  final Languages _language;
  final String _uid;
  final String _chatId;
  String _message;

  MessagingPage(this._language, this._uid, this._chatId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text("Chat $_chatId"),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: _showMessages(),
          ),
          _showMessageInput(),
        ]
      ),
    );
  }

  Widget _showMessages() {
    return new StreamBuilder<DocumentSnapshot>(
      stream: DBService.getMessages(_chatId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError)
          return Text("Error in DB request");
        if (snapshot.connectionState == ConnectionState.waiting)
          return Text("Loading...");
        return ListView(
          shrinkWrap: true,
          children: _showMessageList(snapshot)
        );
      },
    );
  }

  List<Widget> _showMessageList(snapshot) {
    return (snapshot.data["messages"] as List).map(_showMessage).toList();
  }

  Widget _showMessage(dynamic message) {
    return ListTile(
        title: Text(message["content"].split("<<>>")[0]),
        subtitle: Text(message["uid"]),
    );
  }

  Widget _showMessageInput() {
    return Row(
      children: <Widget>[
        TextField(
          maxLines: 4,
          onChanged: (value) => _message = value,
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () => _sendMessage(_message),
        )
      ],
      mainAxisSize: MainAxisSize.max,
    );
  }

  void _sendMessage(String message) {
    DBService.sendMessage(_uid, _chatId, message);
  }
}