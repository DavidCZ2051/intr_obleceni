import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intr_obleceni/settings.dart';
import 'dart:convert';
import 'package:intr_obleceni/vars.dart' as vars;

void main() => runApp(
      const MaterialApp(
        home: Main(),
        debugShowCheckedModeBanner: false,
        title: "Intr - seznam oblečení",
      ),
    );

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

loadData() async {
  print("loading  data");
  List<String> list = [];
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  list = prefs.getStringList("clothes") ?? [];
  for (String item in list) {
    vars.clothes.add(vars.Clothing.fromJson(jsonDecode(item)));
  }
  print("data loaded");
}

saveData() {
  print("saving data");
  List<String> list = [];
  for (vars.Clothing clothing in vars.clothes) {
    list.add(clothing.toJson().toString());
  }
  print(list);
  SharedPreferences.getInstance().then((prefs) {
    prefs.setStringList("clothes", list);
    print("data saved");
  });
}

class _MainState extends State<Main> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await loadData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Internát - seznam oblečení"),
          actions: [
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
          elevation: 2,
        ),
        body: Scrollbar(
          radius: const Radius.circular(10),
          thickness: 7,
          child: ListView(
            addAutomaticKeepAlives: true,
            children: [
              for (vars.Clothing clothing in vars.clothes)
                clothingItem(clothing),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                for (vars.Clothing clothing in vars.clothes) {
                  clothing.count = 0;
                }
                saveData();
                setState(() {});
              },
              child: const Icon(Icons.restore),
              mini: true,
            ),
            const SizedBox(
              width: 8,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                saveData();
                setState(() {});
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.done),
            ),
          ],
        ),
      ),
    );
  }
}

clothingItem(vars.Clothing clothing) {
  return Container(
    padding: const EdgeInsets.all(8),
    child: Row(
      children: <Widget>[
        Text(
          "${clothing.count}x ${clothing.name}",
          style: const TextStyle(fontSize: 30),
        ),
        const Spacer(),
        SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              style: const TextStyle(fontSize: 20),
              onChanged: (value) {
                if (value == "") {
                  clothing.count = 0;
                } else {
                  try {
                    clothing.count = int.parse(value);
                    print("parsed to int");
                  } catch (e) {
                    print("error");
                    return;
                  }
                }
              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
