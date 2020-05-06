import 'package:flutter/material.dart';

class Radiobutton extends StatefulWidget {
  @override
  RadioButtonWidget createState() => RadioButtonWidget();
}

class RadioButtonWidget extends State {
  String radioItem = '';

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile(
          groupValue: radioItem,
          title: Text('Grupo Central'),
          value: 'Grupo Central',
          onChanged: (val) {
            setState(() {
              radioItem = val;
            });
          },
        ),
        RadioListTile(
          groupValue: radioItem,
          title: Text('Grupo 14 de Abril'),
          value: 'Grupo 14 de Abril',
          onChanged: (val) {
            setState(() {
              radioItem = val;
            });
          },
        ),
        RadioListTile(
          groupValue: radioItem,
          title: Text('Grupo C'),
          value: 'Grupo C',
          onChanged: (val) {
            setState(() {
              radioItem = val;
            });
          },
        ),
        RadioListTile(
          groupValue: radioItem,
          title: Text('Grupo D'),
          value: 'Grupo D',
          onChanged: (val) {
            setState(() {
              radioItem = val;
            });
          },
        ),
        Text(
          '$radioItem',
          style: TextStyle(fontSize: 23),
        )
      ],
    );
  }
}
