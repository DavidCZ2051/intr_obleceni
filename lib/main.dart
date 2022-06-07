import 'package:flutter/material.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
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
          addAutomaticKeepAlives: true,
          children: [],
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
