import 'package:flutter/material.dart';

String valor = "";
String alertaPadrao(BuildContext context) {
  showDialog(
      builder: (context) => AlertDialog(
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Radio(
                      value: "Grupo Central",
                      groupValue: 1,
                      onChanged: (T) {
                        valor = T;
                      },
                    ),
                    new Text(
                      'Grupo Central',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Radio(
                      value: "Grupo 14 de Abril",
                      groupValue: 1,
                      onChanged: (T) {
                        valor = T;
                      },
                    ),
                    new Text(
                      'Grupo 14 de Abril',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Radio(
                      value: "Grupo C",
                      groupValue: 1,
                      onChanged: (T) {
                        valor = T;
                      },
                    ),
                    new Text(
                      'Grupo C',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Radio(
                      value: "Grupo D",
                      groupValue: 1,
                      onChanged: (T) {
                        valor = T;
                      },
                    ),
                    new Text(
                      'Grupo D',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ],
                )
              ],
            ),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.description,
                  color: Colors.blue,
                ),
                Text(
                  "Escolha um grupo",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
      context: context);
  return "";
}
