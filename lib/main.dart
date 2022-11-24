import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intr_obleceni/settings.dart';
import 'dart:convert';
import 'package:intr_obleceni/vars.dart' as vars;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadData();
  runApp(
    MaterialApp(
      home: const Main(),
      debugShowCheckedModeBanner: false,
      title: "Intr - seznam oblečení",
      themeMode: getThemeMode(),
      color: vars.materialColorMaker(vars.hexColor!),
      theme: ThemeData(
        primarySwatch: vars.materialColorMaker(vars.hexColor!),
        primaryColor: vars.materialColorMaker(vars.hexColor!),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: vars.materialColorMaker(vars.hexColor!),
        primaryColor: vars.materialColorMaker(vars.hexColor!),
        brightness: Brightness.dark,
      ),
    ),
  );
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

ThemeMode getThemeMode() {
  if (vars.theme == "dark") {
    return ThemeMode.dark;
  } else if (vars.theme == "light") {
    return ThemeMode.light;
  } else {
    return ThemeMode.system;
  }
}

loadData() async {
  debugPrint("loading data");
  List<String> list = [];
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  list = prefs.getStringList("clothes") ?? [];
  for (String item in list) {
    debugPrint(item);
    vars.clothes.add(vars.Clothing.fromJson(jsonDecode(item)));
  }
  vars.hexColor = prefs.getString("color") ?? "2196f3";
  vars.theme = prefs.getString("theme") ?? "system";
  mode = vars.theme;
  debugPrint("data loaded");
}

saveData() {
  debugPrint("saving data");
  List<String> list = [];
  for (vars.Clothing clothing in vars.clothes) {
    String json = clothing.toJson().toString();
    list.add(json);
    debugPrint(json);
  }
  SharedPreferences.getInstance().then((prefs) {
    prefs.setStringList("clothes", list);
    debugPrint("data saved");
  });
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Internát - seznam oblečení"),
          elevation: 2,
          actions: <Widget>[
            IconButton(
              tooltip: "Nastavení",
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                ).then((_) => setState(() {}));
              },
            ),
          ],
        ),
        body: (vars.clothes.isNotEmpty)
            ? Scrollbar(
                controller: ScrollController(),
                radius: const Radius.circular(10),
                thickness: 7,
                child: GlowingOverscrollIndicator(
                  color: Theme.of(context).primaryColor,
                  axisDirection: AxisDirection.down,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        for (vars.Clothing clothing in vars.clothes)
                          ClothingItem(clothing: clothing),
                        const SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: Text(
                  "Zatím žádná položka",
                  style: TextStyle(fontSize: 25),
                ),
              ),
        floatingActionButton: (vars.clothes.isNotEmpty)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    tooltip: "Resetovat počet",
                    heroTag: "btn1",
                    child: const Icon(Icons.restore),
                    mini: true,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Resetovat počet položek?"),
                            content: const Text(
                                "Opravdu chcete resetovat počet všech položek?"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("Zrušit"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text("Ano"),
                                onPressed: () {
                                  for (vars.Clothing clothing in vars.clothes) {
                                    clothing.count = 0;
                                  }
                                  saveData();
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  FloatingActionButton(
                    tooltip: "Uložit",
                    heroTag: "btn2",
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.done),
                    onPressed: () {
                      saveData();
                      setState(() {});
                    },
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

class ClothingItem extends StatefulWidget {
  const ClothingItem({Key? key, required this.clothing}) : super(key: key);

  final vars.Clothing clothing;

  @override
  State<ClothingItem> createState() => _ClothingItemState();
}

class _ClothingItemState extends State<ClothingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "${widget.clothing.count}x ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: widget.clothing.name,
                        style: TextStyle(
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                      "Poslední změna: ${widget.clothing.lastChangedString}"),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: "Resetovat počet",
            onPressed: () {
              widget.clothing.count = 0;
              setState(() {});
              saveData();
            },
            icon: const Icon(Icons.restore),
          ),
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                style: const TextStyle(fontSize: 20),
                onChanged: (value) {
                  try {
                    widget.clothing.count = int.parse(value);
                  } catch (e) {
                    return;
                  }
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
