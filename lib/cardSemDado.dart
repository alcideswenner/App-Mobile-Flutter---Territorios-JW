import 'package:flutter/material.dart';

Widget section(BuildContext context, String texto) {
  return Padding(
    padding: EdgeInsets.all(25),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        
        Ink(
          child: Image(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            image: AssetImage("icon/semdado.jpg"),
          ),
        ),
      ],
    ),
  );
}
