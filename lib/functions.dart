import 'package:flutter/material.dart';

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

item(itemName, color, itemVariable) {
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
                //setState(() {});
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
