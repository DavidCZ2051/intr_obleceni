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
          leading: IconButton(
            tooltip: "Zpět",
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Nastavení - Verze: ${vars.version}"),
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
                          vars.clothes.clear();
                          saveData();
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
                                if (vars.addedClothing!.contains("\"") ||
                                    vars.addedClothing!.contains("\\")) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title:
                                          const Text("Nelze přidat položku!"),
                                      content: const Text(
                                          "Položka obsahuje nepovolené znaky."),
                                      actions: [
                                        TextButton(
                                          child: const Text("Zavřít"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  vars.clothes.add(
                                    vars.Clothing(
                                      name: vars.addedClothing!.trim(),
                                      count: 0,
                                    ),
                                  );
                                  saveData();
                                }
                                vars.addedClothing = null;
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
              for (vars.Clothing clothing in vars.clothes)
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        tooltip: "Odebrat položku",
                        onPressed: () {
                          vars.clothes.remove(clothing);
                          saveData();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
                      Expanded(
                        flex: 10,
                        child: Text(
                          clothing.name!,
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: "Upravit název",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Zadejte nový název"),
                              content: TextField(
                                onChanged: (value) {
                                  vars.newName = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  child: const Text("Zrušit"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    if (vars.newName != null) {
                                      if (vars.newName!.contains("\"") ||
                                          vars.newName!.contains("\\")) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                "Nelze přidat položku!"),
                                            content: const Text(
                                                "Položka obsahuje nepovolené znaky."),
                                            actions: [
                                              TextButton(
                                                child: const Text("Zavřít"),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        clothing.name = vars.newName!.trim();
                                        saveData();
                                        Navigator.pop(context);
                                        setState(() {});
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                      )
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

saveData() {
  List<String> list = [];
  for (vars.Clothing clothing in vars.clothes) {
    list.add(clothing.toJson().toString());
  }
  SharedPreferences.getInstance().then((prefs) {
    prefs.setStringList("clothes", list);
    print("saved");
  });
}
