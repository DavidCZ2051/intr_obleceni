import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intr_obleceni/vars.dart' as vars;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

final TextEditingController _controller = TextEditingController();

loadData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  vars.clothes = prefs.getStringList("clothes") ?? [];
}

class _SettingsState extends State<Settings> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await loadData();
    setState(() {});
    print(vars.clothes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nastavení"),
        actions: [
          IconButton(
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
                        vars.clothes.clear();
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
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (vars.addedClothing != null) {
                            vars.clothes.add(vars.addedClothing!);
                            vars.addedClothing = null;
                            print(vars.clothes);
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
          for (String item in vars.clothes)
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Text(
                    "$item",
                    style: const TextStyle(fontSize: 25),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          vars.clothes.remove(item);
                          update();
                          print(vars.clothes);
                        });
                      },
                      icon: const Icon(Icons.close)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

update() {
  SharedPreferences.getInstance().then((prefs) {
    prefs.setStringList("clothes", vars.clothes);
  });
}
