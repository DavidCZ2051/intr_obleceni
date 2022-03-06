import 'package:flutter/material.dart';
import 'package:intr_obleceni/items.dart';
import 'package:intr_obleceni/settings.dart';

void main() => runApp(
      const MaterialApp(
        home: Main(),
        title: "Intr - seznam oblečení",
      ),
    );

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void callback() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Internát - seznam oblečení"),
        elevation: 2,
      ),
      body: Scrollbar(
        radius: const Radius.circular(10),
        thickness: 7,
        child: ListView(
          addAutomaticKeepAlives: true,
          children: [
            category("Bundy", false),
            item("Bunda", false, Bundy.bunda),
            item("Softshellová bunda", false, Bundy.softshellovaBunda),
            category("Ostatní", true),
            item("Ručník", true, Ostatni.rucnik),
            category("Pokrývky hlavy", false),
            item("Čepice", false, PokryvkyHlavy.cepice),
            item("Kšiltovka", false, PokryvkyHlavy.ksiltovka),
            category("Rukavice", true),
            item("Pletené rukavice", true, Rukavice.pleteneRukavice),
            category("Spodní prádlo", false),
            item("Ponožky", false, SpodniPradlo.ponozky),
            item("Slipy", false, SpodniPradlo.slipy),
            item("Zateplené ponožky", false, SpodniPradlo.zateplenePonozky),
            category("Tepláky", true),
            item("Džíny", true, Teplaky.dziny),
            item("Kraťasy", true, Teplaky.kratasy),
            item("Tepláky", true, Teplaky.teplaky),
            category("Trika", false),
            item("Trika na doma", false, Trika.domaciTriko),
            item("Košile", false, Trika.kosile),
            item("Mikiny", false, Trika.mikina),
            item("Trika do školy", false, Trika.skolniTriko)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("ukládám...");
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.done),
      ),
    );
  }
}

//functions

item(itemName, color, itemVariable, {Function? callstate}) {
  return Container(
    color: color ? Colors.grey[200] : Colors.white,
    child: Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${itemVariable}x",
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
        Text(
          itemName,
          style: const TextStyle(fontSize: 25),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 0, 10),
            child: TextField(
              onSubmitted: (value) {
                itemVariable = int.parse(value);
                print("Hodnota pro $itemName nastavena na: $itemVariable");
                callback();
              },
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

category(categoryName, color) {
  return Container(
    color: color ? Colors.grey[200] : Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        const Flexible(
            child: Divider(
          color: Colors.black87,
          endIndent: 8,
          indent: 8,
        )),
        Text(
          categoryName,
          style: const TextStyle(fontSize: 18),
        ),
        const Flexible(
            child: Divider(
          color: Colors.black87,
          endIndent: 8,
          indent: 8,
        )),
      ]),
    ),
  );
}
