import 'package:flutter/material.dart';
import '../vars.dart' as vars;

class ClothesScreen extends StatefulWidget {
  const ClothesScreen({Key? key}) : super(key: key);

  @override
  State<ClothesScreen> createState() => _ClothesScreenState();
}

class _ClothesScreenState extends State<ClothesScreen> {
  void resetClothesCountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Resetovat počet položek?"),
          content: const Text("Opravdu chcete resetovat počet všech položek?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Zrušit"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            OutlinedButton(
              child: const Text("Resetovat"),
              onPressed: () {
                setState(() {
                  for (vars.Clothing clothing in vars.clothes) {
                    clothing.count = 0;
                    clothing.lastChangedDateTime = DateTime.now();
                  }
                  vars.saveData();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Internát - seznam oblečení"),
        actions: <Widget>[
          IconButton(
            tooltip: "Nastavení",
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
        ],
      ),
      body: SafeArea(
        child: (vars.clothes.isNotEmpty)
            ? SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    for (vars.Clothing clothing in vars.clothes)
                      ClothingItem(clothing: clothing),
                  ],
                ),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Zatím žádná položka",
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Přejděte do nastavení",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: (vars.clothes.isNotEmpty)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  tooltip: "Resetovat počet",
                  heroTag: "btn1",
                  mini: true,
                  onPressed: resetClothesCountDialog,
                  child: const Icon(Icons.restore),
                ),
                const SizedBox(
                  width: 8,
                ),
                FloatingActionButton(
                  tooltip: "Uložit",
                  heroTag: "btn2",
                  child: const Icon(Icons.save),
                  onPressed: () {
                    vars.saveData();
                  },
                ),
              ],
            )
          : null,
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
    return const Placeholder();
  }
}
