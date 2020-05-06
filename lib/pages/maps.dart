import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:territorios/cardSemDado.dart';
import 'package:territorios/pages/anotacao.dart';
import 'package:territorios/pages/grupos.dart';
import 'package:territorios/pages/home.dart';
import 'package:territorios/widgets/alertNet.dart';
import 'package:territorios/widgets/ampliarImagem.dart';
import 'package:territorios/widgets/cardOffline2.dart';
import 'package:toast/toast.dart';

class Mapas extends StatefulWidget {
  @override
  MapasState createState() => MapasState();
}

class MapasState extends State<Mapas> {
  void ma(
      String titulo,
      String bairro,
      String link,
      String legenda,
      String image,
      List<dynamic> semana,
      String status,
      String grupo,
      String atualizacao) {
    Firestore.instance.collection("mapas").document(titulo).setData({
      "titulo": titulo,
      "bairro": bairro,
      "image": image,
      "legenda": legenda,
      "link": link,
      "semana": semana,
      "status": status,
      "grupo": grupo,
      "atualizacao": atualizacao
    });
  }

  SharedPreferences preferencias;
  String nome = "";
  String cpf = "";
  DateFormat dateFormat;
  DateFormat timeFormat;

  @override
  void initState() {
    super.initState();
    selecao = "";
    mostraNome();
    dateFormat = new DateFormat.yMMMMd('pt_BR');
    timeFormat = new DateFormat.Hms('pt_BR');
    data.forEach((d) {
      ma(d.titulo, d.bairro, d.link, d.legenda, d.image, d.semana, d.status,
          d.grupo, d.atualizacao);
    });
  }

  String titulo = "";
  String order = "titulo";
  bool orderBool = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: listaMapasStream(order, orderBool),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.sort),
        backgroundColor: Colors.redAccent,
        overlayOpacity: 0.4,
        overlayColor: Colors.black,
        children: [
          SpeedDialChild(
              child: Icon(
                Icons.map,
                color: Colors.redAccent,
              ),
              backgroundColor: Colors.white,
              label: "Ordenar por Território",
              onTap: () {
                setState(() {
                  order = "titulo";
                  orderBool = false;
                });
              }),
          SpeedDialChild(
              child: Icon(
                Icons.format_color_text,
                color: Colors.redAccent,
              ),
              backgroundColor: Colors.white,
              label: "Ordenar por status",
              onTap: () {
                setState(() {
                  order = "status";
                  orderBool = false;
                });
              })
        ],
      ),
    );
  }

  StreamBuilder listaMapasStream(String order, bool orderBool) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("mapas")
          .orderBy(order, descending: orderBool)
          .where("semana", arrayContains: selecao)
          .snapshots(),
      builder: (context, snap) {
        switch (snap.connectionState) {
          case ConnectionState.none:
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                Item item = data[index];
                return selecao == null || selecao == ""
                    ? cardOffline2(item, context)
                    : item.semana.contains(selecao)
                        ? cardOffline2(item, context)
                        : new Container();
              },
            );
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          default:
            return snap.data.documents.length != 0
                ? ListView.builder(
                    itemCount: snap.data.documents.length,
                    itemBuilder: (context, index) {
                      List<String> f = [];
                      f.add(snap.data.documents[index]["semana"].toString());
                      Item item = Item(
                          bairro: snap.data.documents[index]["bairro"],
                          image: snap.data.documents[index]["image"],
                          legenda: snap.data.documents[index]["legenda"],
                          link: snap.data.documents[index]["link"],
                          titulo: snap.data.documents[index]["titulo"],
                          semana: f,
                          status: snap.data.documents[index]["status"],
                          grupo: snap.data.documents[index]["grupo"],
                          atualizacao: snap.data.documents[index]
                              ["atualizacao"]);
                      return listCard(item);
                    })
                : ListView.builder(
                    itemCount:
                        selecao == null || selecao == "" ? 1 : data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Item item = data[index];

                      return selecao == null || selecao == ""
                          ? section(context, "Escolha um dia")
                          : item.semana.contains(selecao)
                              ? cardOffline2(item, context)
                              : new Container();
                    },
                  );
        }
      },
    );
  }

  mostraNome() async {
    preferencias = await SharedPreferences.getInstance();
    cpf = preferencias.getString("cpf");
    DocumentSnapshot doc =
        await usuariosBase.document(preferencias.getString("cpf")).get();
    print(doc.data["nome"]);
    setState(() {
      nome = doc.data["nome"];
    });
  }

  Container listCard(Item item) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        imagemAmpliada(context, item.image, item.titulo,
                            item.bairro, item.link); //ampliar imagem
                      },
                      child: Ink(
                        child: Image.asset(
                          item.image, //mostrando imagem
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                        ),
                      ),
                    ),
                    Ink(
                      height: 200,
                      decoration: BoxDecoration(color: Colors.black12),
                    ),
                    Positioned(
                      right: 8,
                      top: 20,
                      child: IconButton(
                        icon: Icon(Icons.map),
                        onPressed: () {
                          abrirLink(item.link);
                        },
                        color: Theme.of(context).primaryColor,
                        disabledColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    Positioned(
                        right: 10,
                        bottom: 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                              padding: EdgeInsets.all(10.0),
                              color: item.status == "Indisponível" ||
                                      item.status == "Em Escolha"
                                  ? Colors.orange[200]
                                  : Colors.green[200],
                              child: Text(
                                item.status,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                        ))
                  ],
                ),
                Divider(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(
                          item.titulo,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                        subtitle: Text(
                          item.bairro,
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                        trailing: Text(
                          "" + item.atualizacao,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () async {
                        //selecionar ou retirar
                        try {
                          final result =
                              await InternetAddress.lookup('google.com');
                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty) {
                            if (item.status == "Em Escolha") {
                              //com net
                              if (await verificaUsuarioDesignacao(
                                  item.titulo, cpf)) {
                                Toast.show("Atualizando...", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.CENTER);
                                apagarDesignacaoEmEscolha(item.titulo);
                                atualizaMapaStatus(item.titulo, "Disponível");
                              } else {
                                Toast.show(
                                    "Somente quem solicitou pode apagar!",
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.CENTER);
                              }
                            } else if (item.status == "Disponível") {
                              //com net
                              Toast.show("Atualizando...", context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.CENTER);
                              addDesignacaoEmEscolha(cpf, nome, item.titulo,
                                  item.bairro, item.image);
                              atualizaMapaStatus(item.titulo, "Em Escolha");
                            } else if (item.status == "Indisponível") {
                              Toast.show("Atualizando...", context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.CENTER);
                            }
                          } else {
                            alerta(context);
                          }
                        } on SocketException catch (_) {
                          alerta(context);
                        }
                      },
                      child: Text(
                        item.status == "Em Escolha" ? "Retirar" : "Selecionar",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: item.status == "Em Escolha" ||
                              item.status == "Indisponível"
                          ? Colors.red
                          : Theme.of(context).primaryColor,
                      disabledColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      onPressed: () async {
                        try {
                          final result =
                              await InternetAddress.lookup('google.com');
                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Anotacao(
                                          titulo: item.titulo,
                                          bairro: item.bairro,
                                          mapa: item.image,
                                        )));
                          } else {
                            alerta(context);
                          }
                        } on SocketException catch (_) {
                          alerta(context);
                        }
                      },
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.description),
                          Text("Anotações")
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> verificaUsuarioDesignacao(String titulo, String cpf) async {
    bool verifica = false;
    await Firestore.instance
        .collection("designacoes")
        .document(titulo)
        .get()
        .then((a) {
      if (a.data.containsValue(cpf)) {
        verifica = true;
        print(verifica);
      } else {
        verifica = false;
      }
    });
    return verifica;
  }

  apagarDesignacaoEmEscolha(String id) async {
    final doc =
        await Firestore.instance.collection("designacoes").document(id).get();

    if (doc.exists) {
      doc.reference.delete();
    }
  }

  addDesignacaoEmEscolha(String cpf, String nome, String titulo, String bairro,
      String imagem) async {
    var dateTime = new DateTime.now();
    try {
      Firestore.instance.collection("designacoes").document(titulo).setData({
        "CPF": cpf,
        "nome": nome,
        "timestamp": DateTime.now(),
        "territorio": titulo,
        "bairro": bairro,
        "imagem": imagem,
        "status": "Em Escolha",
        "dataInicio":
            dateFormat.format(dateTime) + " - " + timeFormat.format(dateTime),
        "dataConclusao": ""
      });
    } catch (e) {
      print(e);
    }
  }

  atualizaMapaStatus(String id, String status) async {
    final doc = await Firestore.instance.collection("mapas").document(id).get();
    if (doc.exists) {
      doc.reference.updateData({"status": status});
    }
  }

  addHistorico(String tipo) async {
    preferencias = await SharedPreferences.getInstance();
    Firestore.instance.collection("historico").add({
      "CPF": preferencias.getString("cpf"),
      "historico": "$nome compartilhou um mapa",
      "timestamp": DateTime.now(),
      "territorio": this.titulo,
      "nome": nome,
      "tipo": tipo
    });
  }
}

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

String selecao = "";
String bairro;
String valor = "Segunda-Feira";
String order = "";

class _MapsState extends State<Maps> {
  @override
  void initState() {
    super.initState();
  }

  List<String> diaSemana = [
    'Domingo',
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-Feira',
    'Sábado'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Escolha um dia"),
        elevation: 2,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15, left: 15),
            child: DropdownButton<String>(
              value: valor,
              icon: Icon(Icons.calendar_today, color: Colors.white),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String newValue) {
                setState(() {
                  valor = newValue;
                  selecao = newValue;
                  if (selecao == "Domingo") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Grupos()));
                    selecao = "";
                    valor = "Segunda-Feira";
                  }
                });
              },
              items: diaSemana.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          )
        ],
      ),
      body: Mapas(),
    );
  }
}

class Item {
  final String titulo;
  final String bairro;
  final String image;
  final String legenda;
  final String link;
  final List<String> semana;
  final String status;
  final String grupo;
  final String atualizacao;
  Item(
      {this.titulo,
      this.bairro,
      this.image,
      this.legenda,
      this.link,
      this.semana,
      this.status,
      this.grupo,
      this.atualizacao});
}

final List<Item> data = [
  Item(
      titulo: "Território 01",
      bairro: "Centro",
      image: "mapas/map1.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/1cn2KdGDubvnss9p6",
      semana: ["Quarta-Feira", "Sábado"],
      status: "Disponível",
      grupo: "Grupo Central",
      atualizacao: "-"),
  Item(
      titulo: "Território 02",
      bairro: "Centro",
      image: "mapas/map2.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/HyeWcpp6XNYVrKn69",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo Central",
      atualizacao: "-"),
  Item(
      titulo: "Território 03",
      bairro: "Centro",
      image: "mapas/map3.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/fBhijsgYWzznmruz6",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo Central",
      atualizacao: "-"),
  Item(
      titulo: "Território 04",
      bairro: "Centro",
      image: "mapas/map4.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/xf3HLi9LnLZ9x5Ek8",
      semana: ["Sábado", "Terça-Feira"],
      status: "Disponível",
      grupo: "Grupo Central",
      atualizacao: "-"),
  Item(
      titulo: "Território 05",
      bairro: "Centro",
      image: "mapas/map5.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/mLS2oK2XnBJHhWTP6",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo Central",
      atualizacao: "-"),
  Item(
      titulo: "Território 06",
      bairro: "Bela Vista",
      image: "mapas/map6.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/wr6H9LeKPAi8YU716",
      semana: ["Quarta-Feira", "Domingo"],
      status: "Disponível",
      grupo: "Grupo 14 de Abril",
      atualizacao: "-"),
  Item(
      titulo: "Território 07",
      bairro: "Bela Vista",
      image: "mapas/map7.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/td4NLx25YjCD3kDj8",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo 14 de Abril",
      atualizacao: "-"),
  Item(
      titulo: "Território 08",
      bairro: "São Francisco",
      image: "mapas/map8.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/bXBKcEnBtCfk7e1E8",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo 14 de Abril",
      atualizacao: "-"),
  Item(
      titulo: "Território 09",
      bairro: "Sarney",
      image: "mapas/map9.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/ReNaGeyUWkh11AoB7",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo 14 de Abril",
      atualizacao: "-"),
  Item(
      titulo: "Território 10",
      bairro: "Sarney",
      image: "mapas/map10.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/62xuNGeXTSEFpgbR6",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo 14 de Abril",
      atualizacao: "-"),
  Item(
      titulo: "Território 11",
      bairro: "Subestação",
      image: "mapas/map11.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/7Ruttb5DuQuR5q1E6",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo 14 de Abril",
      atualizacao: "-"),
  Item(
      titulo: "Território 12",
      bairro: "Subestação",
      image: "mapas/map12.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/7Ruttb5DuQuR5q1E6",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo 14 de Abril",
      atualizacao: "-"),
  Item(
      titulo: "Território 13",
      bairro: "Subestação",
      image: "mapas/map13.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/7Ruttb5DuQuR5q1E6",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo 14 de Abril",
      atualizacao: "-"),
  Item(
      titulo: "Território 14",
      bairro: "Subestação",
      image: "mapas/map14.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/7Ruttb5DuQuR5q1E6",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo 14 de Abril",
      atualizacao: "-"),
  Item(
      titulo: "Território 15",
      bairro: "Novo Tempo",
      image: "mapas/map15.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/ESyLkXfSy4UaZfPC8",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo C",
      atualizacao: "-"),
  Item(
      titulo: "Território 16",
      bairro: "Quiabos",
      image: "mapas/map16.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/j6r9ZDSQsfj2cU8m9",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo C",
      atualizacao: "-"),
  Item(
      titulo: "Território 17",
      bairro: "Mutirão",
      image: "mapas/map17.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/GfHjoWprY6BpoXVN7",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo C",
      atualizacao: "-"),
  Item(
      titulo: "Território 18",
      bairro: "Mutirão",
      image: "mapas/map18.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/GfHjoWprY6BpoXVN7",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo C",
      atualizacao: "-"),
  Item(
      titulo: "Território 19",
      bairro: "Mutirão",
      image: "mapas/map20.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/GfHjoWprY6BpoXVN7",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo C",
      atualizacao: "-"),
  Item(
      titulo: "Território 20",
      bairro: "Mutirão",
      image: "mapas/map20.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/GfHjoWprY6BpoXVN7",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo C",
      atualizacao: "-"),
  Item(
      titulo: "Território 21",
      bairro: "Olho D'Aguinha",
      image: "mapas/map21.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/4B7t7iCqTbEykPj8A",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo D",
      atualizacao: "-"),
  Item(
      titulo: "Território 22",
      bairro: "Olho D'Aguinha",
      image: "mapas/map22.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/MovyLRB4PbTViyN76",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo D",
      atualizacao: "-"),
  Item(
      titulo: "Território 23",
      bairro: "Olho D'Aguinha",
      image: "mapas/map23.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/mjYTBQkhKMrs5Jm46",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo D",
      atualizacao: "-"),
  Item(
      titulo: "Território 24",
      bairro: "Anil",
      image: "mapas/map24.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/f3vnbTtd31vYG5dB7",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo D",
      atualizacao: "-"),
  Item(
      titulo: "Território 25",
      bairro: "Anil",
      image: "mapas/map25.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/p4MaB7Wj5ebkZJra8",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo D",
      atualizacao: "-"),
  Item(
      titulo: "Território 26",
      bairro: "Anil",
      image: "mapas/map26.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/gx8ENzqfV3EmevyZ8",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo D",
      atualizacao: "-"),
  Item(
      titulo: "Território 27",
      bairro: "Anil",
      image: "mapas/map27.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/8j7KAAJbFFVSUDAH9",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo D",
      atualizacao: "-"),
  Item(
      titulo: "Território 28",
      bairro: "Anil",
      image: "mapas/map28.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/uSKHu2zYLB2YyDyS9",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo D",
      atualizacao: "-"),
  Item(
      titulo: "Território 29",
      bairro: "Anil",
      image: "mapas/map29.webp",
      legenda: "Centro",
      link: "https://goo.gl/maps/mBB6sssEE6RFyr8X7",
      semana: ["Domingo", "Domingo"],
      status: "Disponível",
      grupo: "Grupo D",
      atualizacao: "-")
];
