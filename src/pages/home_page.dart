import 'package:flutter/material.dart';

import '../enums/languages.dart';
import './people_page.dart';
import './chats_page.dart';
import './settings_page.dart';
import '../templates/signout_scaffold_template.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.userId, this.signOut}) : super(key: key);

  final VoidCallback signOut;
  final String userId;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Languages _language;

  @override
  void initState() {
    super.initState();
    setState(() {
      _language = Languages.English;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
        children: [
          PeoplePage(widget.signOut),
          ChatsPage(_language, widget.userId, widget.signOut),
          SettingsPage(updateLanguage, widget.signOut, _language),
        ]


    );
  }

  void updateLanguage(Languages language){
    setState(() {
      _language = language;
    });
  }

}