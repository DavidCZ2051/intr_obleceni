import 'package:flutter/material.dart';
import '../vars.dart' as vars;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nastavení"),
        leading: IconButton(
          tooltip: "Zpět",
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                        setState(() {
                          vars.clothes.clear();
                          vars.saveData();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              for (vars.Clothing clothing in vars.clothes)
                ClothingItem(clothing),
              AddClothing(
                onAdd: () {
                  vars.saveData();
                  setState(() {});
                },
              ),
              const Others(),
            ],
          ),
        ),
      ),
    );
  }
}

class AddClothing extends StatefulWidget {
  const AddClothing({Key? key, required this.onAdd}) : super(key: key);

  final Function() onAdd;

  @override
  State<AddClothing> createState() => AddClothingState();
}

class AddClothingState extends State<AddClothing> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void addClothing() {
    vars.clothes.add(vars.Clothing(
      name: _controller.text,
      count: 0,
      lastChangedDateTime: DateTime.now(),
    ));

    setState(() {
      _controller.clear();
    });

    widget.onAdd();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: "Název",
          suffixIcon: IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                addClothing();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "Název nesmí být prázdný";
          }
          return null;
        },
      ),
    );
  }
}

class ClothingItem extends StatefulWidget {
  const ClothingItem(this.clothing, {Key? key}) : super(key: key);

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

class Others extends StatefulWidget {
  const Others({Key? key}) : super(key: key);

  @override
  State<Others> createState() => _OthersState();
}

class _OthersState extends State<Others> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
