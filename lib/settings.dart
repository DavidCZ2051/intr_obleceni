import 'package:flutter/material.dart';
import 'package:intr_obleceni/main.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nastavení"),
        elevation: 2,
      ),
    );
  }
}
