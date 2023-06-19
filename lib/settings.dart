import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intr_obleceni/vars.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intr_obleceni/vars.dart' as vars;
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:intr_obleceni/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

final TextEditingController _controller = TextEditingController();

List<String> modes = ["system", "dark", "light"];
String mode = modes[0];
int importMode = 0;
List<vars.Clothing>? importData;

class _SettingsState extends State<Settings> {
  String? newColor;
  bool isLoading = false;

  handleCheckingVersion() async {
    setState(() {
      isLoading = true;
    });
    var object = await checkVersion(vars.version);
    setState(() {
      isLoading = false;
    });
    if (object.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Dostupná aktualizace!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  children: const [
                    TextSpan(
                      text: "Aktuální verze: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: vars.version),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: "Nová verze: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(
                      text: object.body!["latestVersion"] + "\n",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            if (object.body!["downloadUrl"] != null)
              OutlinedButton(
                onPressed: () {
                  launchUrl(
                    Uri.parse(object.body!["downloadUrl"]),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: const Text("Stáhnout novou verzi"),
              ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else if (object.statusCode == 204) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Aplikace je aktuální!"),
          content: const Text("Žádná nová verze není k dispozici."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Chyba ${object.statusCode}"),
          content:
              const Text("Chyba při zjišťování verze. Kontaktujte vývojáře."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    setstate() {
      setState(() {});
    }

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
                      OutlinedButton(
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
          controller: ScrollController(),
          radius: const Radius.circular(10),
          thickness: 7,
          child: GlowingOverscrollIndicator(
            color: Theme.of(context).primaryColor,
            axisDirection: AxisDirection.down,
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
                                        lastChangedDateTime: DateTime.now(),
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
                            clothing.name,
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
                                  OutlinedButton(
                                    child: const Text("Uložit"),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OutlinedButton.icon(
                      icon: Icon(
                        (Theme.of(context).brightness == Brightness.dark)
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
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
                                OutlinedButton(
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
                                          OutlinedButton(
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
                      label: const Text("Změnit mód"),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.color_lens),
                      label: const Text("Změnit barvu"),
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
                              OutlinedButton(
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
                                        OutlinedButton(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OutlinedButton.icon(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: ((context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text("Import dat"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            'Vyberte metodu importu dat:',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            setState(() {
                                              importMode = 0;
                                            });
                                          },
                                          title: const Text(
                                              'Přepsat existující data'),
                                          leading: Radio(
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            value: 0,
                                            groupValue: importMode,
                                            onChanged: (value) {
                                              setState(() {
                                                importMode = value as int;
                                              });
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            setState(() {
                                              importMode = 1;
                                            });
                                          },
                                          title: const Text(
                                              'Přidat data k existujícím'),
                                          leading: Radio(
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            value: 1,
                                            groupValue: importMode,
                                            onChanged: (value) {
                                              setState(() {
                                                importMode = value as int;
                                              });
                                            },
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 2,
                                        ),
                                        const Text(
                                          'Vložte data do pole:',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          onChanged: (value) {
                                            var object = areDataValid(value);
                                            if (object != null) {
                                              importData = object;
                                            } else {
                                              importData = null;
                                            }
                                            setState(() {});
                                          },
                                          style: const TextStyle(
                                              fontFamily: 'IBM Plex Mono'),
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            errorText: importData == null
                                                ? 'Neplatná data'
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("Zrušit"),
                                      onPressed: () {
                                        importMode = 0;

                                        Navigator.pop(context);
                                      },
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        if (importMode == 0 &&
                                            importData != null) {
                                          vars.clothes = importData!;
                                          saveData();
                                          setstate();
                                          setState(() {});
                                        } else if (importMode == 1 &&
                                            importData != null) {
                                          for (vars.Clothing clothing
                                              in importData!) {
                                            vars.clothes.add(clothing);
                                          }
                                          saveData();
                                          setstate();
                                        }
                                        importMode = 0;
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Importovat"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                        );
                      },
                      label: const Text("Importovat data"),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.upload),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: ((context) {
                            List<String> list = [];
                            for (vars.Clothing clothing in vars.clothes) {
                              String json = clothing.toJson().toString();
                              list.add(json);
                            }
                            return AlertDialog(
                              title: const Text("Export dat"),
                              content: GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.down,
                                color: Theme.of(context).primaryColor,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text(
                                        "Níže jsou vyexportované data. Můžete si je zkopírovat.",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const Divider(
                                        thickness: 2,
                                      ),
                                      SelectableText(
                                        list.toString(),
                                        style: const TextStyle(
                                          fontFamily: 'IBM Plex Mono',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Zkopírovat"),
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: list.toString()),
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          }),
                        );
                      },
                      label: const Text("Exportovat data"),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    isLoading
                        ? const CircularProgressIndicator()
                        : OutlinedButton.icon(
                            icon: const Icon(Icons.update),
                            label: const Text('Zkontrolovat aktualizace'),
                            onPressed: () {
                              handleCheckingVersion();
                            },
                          ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          vars.checkForUpdates = !vars.checkForUpdates!;
                        });
                        saveData();
                      },
                      child: Chip(
                        backgroundColor:
                            vars.checkForUpdates! ? Colors.green : Colors.red,
                        label: const Text('Kontrolovat aktualizace'),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                const Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Verze: ${vars.version}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FlutterLogo(
                          size: 70,
                        ),
                      ),
                      Text(
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
    prefs.setBool("checkForUpdates", vars.checkForUpdates!);
  });
}

areDataValid(String data) {
  debugPrint("checking: $data");
  try {
    List<vars.Clothing> clothes = [];
    for (Map clothing in jsonDecode(data)) {
      clothes.add(Clothing.fromJson(clothing));
    }
    debugPrint('valid');
    return clothes;
  } catch (e) {
    debugPrint('invalid');
    return null;
  }
}
