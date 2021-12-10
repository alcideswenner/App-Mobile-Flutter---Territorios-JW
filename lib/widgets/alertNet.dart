import 'package:flutter/material.dart';

alerta(BuildContext context) {
  showDialog(
      builder: (context) => AlertDialog(
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: RaisedButton(
                  color: Colors.red,
                  child: Text(
                    "FECHAR",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
            content: Text(
                "Você não está conectado com a Internet. Tente outra vez."),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                Text(
                  " Opa...",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
      context: context);
}
