import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intr_obleceni/vars.dart' as vars;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

final TextEditingController _controller = TextEditingController();

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nastavení"),
          actions: [
            IconButton(
              tooltip: "Smazat data",
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Smazat všechny data?"),
                    content: const Text("Tato akce je nevratná."),
                    actions: [
                      TextButton(
                        child: const Text("Zrušit"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text("Smazat"),
                        onPressed: () {
                          vars.clothesSettings.clear();
                          vars.clothes.clear();
                          update();
                          Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          elevation: 2,
        ),
        body: Scrollbar(
          radius: const Radius.circular(10),
          thickness: 7,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Zadejte položku",
                          suffixIcon: IconButton(
                            tooltip: "Přidat položku",
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              if (vars.addedClothing != null) {
                                vars.clothesSettings.add(vars.addedClothing!);
                                vars.addedClothing = null;
                                print(vars.clothesSettings);
                                update();
                                _controller.clear();
                                setState(() {});
                              }
                            },
                          ),
                        ),
                        onChanged: (value) {
                          vars.addedClothing = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              for (String item in vars.clothesSettings)
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        tooltip: "Odebrat položku",
                        onPressed: () {
                          setState(() {
                            vars.clothesSettings.remove(item);
                            update();
                            print(vars.clothesSettings);
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                      Text(
                        item,
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

update() {
  SharedPreferences.getInstance().then((prefs) {
    prefs.setStringList("clothes-settings", vars.clothesSettings);
  });
}
