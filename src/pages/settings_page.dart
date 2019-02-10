import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../templates/signout_scaffold_template.dart';
import '../enums/languages.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback signOut;
  final updateLanguage;
  Languages _language;

  SettingsPage(this.updateLanguage, this.signOut, this._language);

  @override
  Widget build (BuildContext context) {
    return SignOutScaffold(
      title: "Settings",
      signOut: this.signOut,
      body: CupertinoPicker(
        onSelectedItemChanged: (value) {
          _language = Languages.values[value];
          updateLanguage(_language);
        },
        children: Languages.values.map((language) => Text(language.toString())).toList(),
        scrollController: new FixedExtentScrollController(
          initialItem: _language.index,
        ),
        itemExtent: 36.0,
      ),
    );
  }
}


