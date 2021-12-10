import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:territorios/googleMapa.dart';

import 'package:territorios/pages/ajustes.dart';
import 'package:territorios/pages/historico.dart';
import 'package:territorios/pages/inicio.dart';

final usuariosBase = Firestore.instance.collection("usuarios");
final notificacoesBase = Firestore.instance.collection("notificacoes");

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    return WillPopScope(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.map),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => GoogleMapa()));
            },
          ),
          appBar: appBar(),
          body: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[Inicio(), Historico()],
          ),
          bottomNavigationBar: CupertinoTabBar(
            currentIndex: pageIndex,
            onTap: onTap,
            activeColor: Theme.of(context).primaryColor,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home)),
              BottomNavigationBarItem(icon: Icon(Icons.history)),
            ],
          ),
        ),
        onWillPop: _onBackPressed);
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeInOut);
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text("Território Central"),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Ajustes()));
            }),
      ],
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Mapas da Congregação'),
            content: new Text('Você deseja sair do app?'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    "Não",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => SystemNavigator.pop(),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    "Sim",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
