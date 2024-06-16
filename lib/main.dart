import 'package:flutter/material.dart';
import 'package:intr_obleceni/routes/clothes.dart';
import 'package:intr_obleceni/routes/settings.dart';
import 'package:intr_obleceni/vars.dart' as vars;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await vars.loadData();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Intr - seznam oblečení",
      themeMode: vars.themeMode,
      // color: vars.materialColorMaker(vars.hexColor!),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        /* colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: vars.materialColorMaker(vars.hexColor!),
        ), */
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        /* colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: vars.materialColorMaker(vars.hexColor!),
        ), */
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const ClothesScreen(),
        "/settings": (context) => const SettingsScreen(),
      },
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
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "${widget.clothing.count}x ",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).primaryColorLight
                              : Theme.of(context).primaryColor,
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
              widget.clothing.lastChangedDateTime = DateTime.now();
              vars.saveData();
              setState(() {});
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
                    widget.clothing.lastChangedDateTime = DateTime.now();
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
