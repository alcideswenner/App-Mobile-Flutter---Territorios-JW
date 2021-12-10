import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:territorios/pages/home.dart';
import 'dart:async';
import 'package:territorios/pages/maps.dart';
import 'package:territorios/pages/movimentacaoMapa.dart';
import 'package:territorios/widgets/alertNet.dart';
import 'package:territorios/widgets/ampliarImagem.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  String nome = "";
  SharedPreferences preferencias;
  var listRefresh;
  var randomRefresh;

  String cpfList = "";

  @override
  void initState() {
    super.initState();
    randomRefresh = Random();
    listRefresh = List.generate(randomRefresh.nextInt(10), (i) => "Item $i");
    mostraNome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: RefreshIndicator(
                child: ListView(
                  children: <Widget>[
                    header(context),
                    local(),
                    sectionMeuMapas(context),
                    mostraMapas("Em Escolha", 0),
                    sectionMapasTrabalhados(),
                    mostraMapas("Em Andamento", 1),
                  ],
                ),
                onRefresh: refresh)));
  }

  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      listRefresh = List.generate(randomRefresh.nextInt(10), (i) => "Item $i");
    });
    return null;
  }

  mostraNome() async {
    preferencias = await SharedPreferences.getInstance();
    cpfList = preferencias.getString("cpf");
    DocumentSnapshot doc = await usuariosBase.document(cpfList).get();
    print(doc.data["nome"]);
    if (mounted && doc.data["nome"] != null) {
      setState(() {
        nome = doc.data["nome"];
      });
    }
  }

  header(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("icon/home.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      margin: EdgeInsets.only(top: 3.0, bottom: 10.0),
      height: 190.0,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 40.0, left: 35.0, right: 35.0, bottom: 5.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Olá, " + nome,
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text("Publicador | Mapas"),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "29",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Mapas".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "100+",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Publicadores".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "40.000+",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Cidade".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 4.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 28.0,
                    backgroundImage: AssetImage("icon/user.png")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  sectionMeuMapas(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Meus mapas (Offline)",
            style: Theme.of(context).textTheme.headline6,
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => Maps()));
              refresh();
            },
            child: Text(
              "Escolher novo mapa",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
    );
  }

  sectionMapasTrabalhados() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
        child: Text("Mapas Designados",
            style: Theme.of(context).textTheme.headline6));
  }

  mostraMapas(String status, int cor) {
    return Container(
        height: 200,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("designacoes")
              .where("CPF", isEqualTo: cpfList)
              .where("status", isEqualTo: status)
              .snapshots(),
          builder: (context, snap) {
            switch (snap.connectionState) {
              case ConnectionState.none:
                return Text("sjjjdjdjd");
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              default:
                return snap.data.documents.length != 0
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: snap.data.documents.length,
                        itemBuilder: (context, index) {
                          //timestamp = snap.data.documents[index].data["timestamp"];
                          return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              width: 195.0,
                              height: 200.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              imagemAmpliada(
                                                  context,
                                                  snap.data.documents[index]
                                                      .data["imagem"],
                                                  snap.data.documents[index]
                                                      .data["territorio"],
                                                  snap.data.documents[index]
                                                      .data["bairro"],
                                                  "");
                                            },
                                            child: Image.asset(snap
                                                .data
                                                .documents[index]
                                                .data["imagem"]),
                                          ))),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  ListTile(
                                    title: Text(
                                        snap.data.documents[index]
                                            .data["territorio"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .merge(TextStyle(
                                                color: Colors.grey.shade600))),
                                    leading: IconButton(
                                        icon: Icon(
                                          Icons.cloud_upload,
                                          color: cor == 0
                                              ? Colors.red
                                              : Colors.yellow,
                                          size: 30,
                                        ),
                                        onPressed: () async {
                                          try {
                                            final result =
                                                await InternetAddress.lookup(
                                                    'google.com');
                                            if (result.isNotEmpty &&
                                                result[0]
                                                    .rawAddress
                                                    .isNotEmpty) {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                refresh();
                                                return MovimentacaoMapa(
                                                  cpf: snap
                                                      .data
                                                      .documents[index]
                                                      .data["CPF"],
                                                  titulo: snap
                                                      .data
                                                      .documents[index]
                                                      .data["territorio"],
                                                  nome: nome,
                                                  imagem: snap
                                                      .data
                                                      .documents[index]
                                                      .data["imagem"],
                                                  status: "-",
                                                  dataInicio: "",
                                                  dataConclusao: "",
                                                  bairro: snap
                                                      .data
                                                      .documents[index]
                                                      .data["bairro"],
                                                );
                                              }));
                                              refresh();
                                            } else {
                                              alerta(context);
                                            }
                                          } on SocketException catch (_) {
                                            alerta(context);
                                          }
                                        }),
                                  )
                                ],
                              ));
                        },
                      )
                    : Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Icon(Icons.branding_watermark),
                            ),
                            Divider(),
                            Center(
                              child: Text("Nenhum mapa escolhido"),
                            )
                          ],
                        ),
                      );
            }
          },
        ));
  }

  Widget local() {
    return ListTile(
      title: Text(
        "Coelho Neto - Ma",
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
        ),
      ),
      leading: Icon(Icons.location_on),
      trailing: Text("Brasil"),
      subtitle: Text("Congregação Central"),
    );
  }
}
