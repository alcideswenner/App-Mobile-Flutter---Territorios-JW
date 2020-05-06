import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:territorios/pages/home.dart';
import 'package:territorios/pages/login.dart';

class PageInicial extends StatefulWidget {
  @override
  _PageInicialState createState() => _PageInicialState();
}

class _PageInicialState extends State<PageInicial> {
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    startNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: logoIniciar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: null,
          label: Column(
            children: <Widget>[
              Text(
                "from ",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              Text("Alcides Wenner ",
                  style: TextStyle(
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ))
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ));
  }

  startNextPage() async {
    SystemChrome.setEnabledSystemUIOverlays([]);
    var duracao = Duration(seconds: 4);
    return new Timer(duracao, tela);
  }

  Widget imagemIcone() {
    return FadeInImage(
      placeholder: (AssetImage("icon/icone_terr.webp")),
      image: AssetImage("icon/icone_terr.webp"),
      width: 92.0,
    );
  }

  Widget logoIniciar() {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Center(child: imagemIcone()),
            ),
            SizedBox(
              height: 52.0,
            ),
            Center(
              child: Container(
                width: 200,
                height: 200,
                child: FlareActor("icon/loading.flr",
                    animation: "loading",
                    fit: BoxFit.contain,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        )
      ],
    );
  }

  void tela() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("cpf") == null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => Login()));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => Home()));
    }
  }
}
