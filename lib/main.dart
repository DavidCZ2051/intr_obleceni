import 'package:flutter/material.dart';
import 'package:intr_obleceni/items.dart';
import 'package:intr_obleceni/functions.dart';
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
            item("Softčílová bunda", false, Bundy.softcilovaBunda),
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
