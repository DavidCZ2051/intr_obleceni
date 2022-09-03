import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intr_obleceni/vars.dart' as vars;
import 'package:flutter/services.dart';
import 'dart:io';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

final TextEditingController _controller = TextEditingController();

List<String> modes = ["system", "dark", "light"];
String mode = modes[0];

class _SettingsState extends State<Settings> {
  String? newColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            tooltip: "Zpět",
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Nastavení"),
          actions: <Widget>[
            IconButton(
              tooltip: "Smazat data",
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Smazat všechna data?"),
                    content: const Text("Tato akce je nevratná."),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Zrušit"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
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
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
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
                                      actions: <Widget>[
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
                        icon: const Icon(Icons.edit),
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
                              actions: <Widget>[
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
                                            actions: <Widget>[
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
                      )
                    ],
                  ),
                ),
              const Divider(
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => WillPopScope(
                          onWillPop: () async {
                            mode = mode;
                            return true;
                          },
                          child: AlertDialog(
                            title: const Text("Vyberte mód"),
                            content: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      mode = modes[2];
                                      setState(() {});
                                    },
                                    title: const Text("Světlý"),
                                    leading: Radio(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: modes[2],
                                      groupValue: mode,
                                      onChanged: (value) {
                                        setState(() {
                                          mode = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      mode = modes[1];
                                      setState(() {});
                                    },
                                    title: const Text("Tmavý"),
                                    leading: Radio(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: modes[1],
                                      groupValue: mode,
                                      onChanged: (value) {
                                        setState(() {
                                          mode = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      mode = modes[0];
                                      setState(() {});
                                    },
                                    title: const Text("Podle systému"),
                                    leading: Radio(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: modes[0],
                                      groupValue: mode,
                                      onChanged: (value) {
                                        setState(() {
                                          mode = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("Zavřít"),
                                onPressed: () {
                                  mode = vars.theme;
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text("Potvrdit"),
                                onPressed: () {
                                  vars.theme = mode;
                                  saveData();
                                  setState(() {});
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text(
                                          "Pro zobrazení změny je nutné restartovat aplikaci."),
                                      actions: <Widget>[
                                        TextButton(
                                            child: const Text("Později"),
                                            onPressed: () =>
                                                Navigator.pop(context)),
                                        ElevatedButton(
                                          child: const Text("Restartovat"),
                                          onPressed: () {
                                            if (Platform.isAndroid) {
                                              SystemNavigator.pop();
                                            } else {
                                              exit(0);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon((Theme.of(context).brightness == Brightness.dark)
                            ? Icons.light_mode
                            : Icons.dark_mode),
                        const SizedBox(width: 5),
                        const Text("Změnit mód"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.color_lens),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Změnit barvu"),
                      ],
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Vyberte si barvu"),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor:
                                  vars.materialColorMaker(vars.hexColor!),
                              onColorChanged: (color) {
                                newColor = vars.colorToHex(color);
                                setState(() {});
                              },
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Zrušit"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                              child: const Text("Potvrdit"),
                              onPressed: () {
                                vars.hexColor = newColor;
                                saveData();
                                setState(() {});
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text(
                                        "Pro zobrazení změny je nutné restartovat aplikaci."),
                                    actions: <Widget>[
                                      TextButton(
                                          child: const Text("Později"),
                                          onPressed: () =>
                                              Navigator.pop(context)),
                                      ElevatedButton(
                                        child: const Text("Restartovat"),
                                        onPressed: () {
                                          if (Platform.isAndroid) {
                                            SystemNavigator.pop();
                                          } else {
                                            exit(0);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Verze: ${vars.version}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FlutterLogo(
                        size: 70,
                      ),
                    ),
                    const Text(
                      "Made by David Vobruba using Flutter",
                      style: TextStyle(fontSize: 15),
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

saveData() {
  List<String> list = [];
  for (vars.Clothing clothing in vars.clothes) {
    list.add(clothing.toJson().toString());
  }
  SharedPreferences.getInstance().then((prefs) {
    prefs.setStringList("clothes", list);
    prefs.setString("color", vars.hexColor!);
    prefs.setString("theme", vars.theme);
  });
}
