import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:toast/toast.dart';

class MovimentacaoMapa extends StatefulWidget {
  final String cpf;
  final String nome;
  final String titulo;
  final String imagem;
  final String dataInicio;
  final String dataConclusao;
  final String status;
  final String bairro;

  MovimentacaoMapa(
      {this.cpf,
      this.nome,
      this.titulo,
      this.imagem,
      this.dataInicio,
      this.dataConclusao,
      this.status,
      this.bairro});

  @override
  _MovimentacaoMapaState createState() => _MovimentacaoMapaState();
}

class _MovimentacaoMapaState extends State<MovimentacaoMapa> {
  DateFormat formatarData;
  DateFormat formatarHora;
  Map<String, dynamic> mapRecebeDadosOnline = {};
  String dataInicio = "";
  String data = "";
  String idMapaOnline = "";
  bool verifica = false;
  Text textDesignadoOuNao;
  @override
  void initState() {
    super.initState();
    verificaDesignacaoOnline(widget.titulo);
    initializeDateFormatting();
    formatarData = new DateFormat.yMMMMd('pt_BR');
    formatarHora = new DateFormat.Hms('pt_BR');
  }

  @override
  Widget build(BuildContext context) {
    verifica = false;
    var dateTime = new DateTime.now();
    verificacaoInicialDesignacao(dateTime);
    return Scaffold(
        appBar: AppBar(
          title: Text("Designar Mapa"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 0, left: 5, right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                header(),
                ListTile(
                  title: Text(
                      "Todas as designações ficam disponíveis para que outros usuários vejam!"),
                  leading: Icon(
                    Icons.warning,
                    color: Theme.of(context).primaryColor,
                  ),
                  subtitle: Divider(),
                ),
                secao(),
                new Text(formatarData.format(dateTime)),
                new Text(formatarHora.format(dateTime)),
              ],
            ),
          ),
        ));
  }

  verificacaoInicialDesignacao(DateTime dateTime) {
    if (dataInicio == null) {
      verifica = false;
      textDesignadoOuNao = Text(
        "Informações (Não Designado!)",
        style: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 16),
        textAlign: TextAlign.left,
      );
      dataInicio =
          formatarData.format(dateTime) + " - " + formatarHora.format(dateTime);
    } else {
      verifica = true;
      textDesignadoOuNao = Text(
        "Informações (Designado!)",
        style: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 16),
        textAlign: TextAlign.left,
      );
    }
  }

  header() {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(widget.imagem), fit: BoxFit.contain)),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(color: Colors.black12),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.grey,
                child: CircleAvatar(
                  backgroundImage: AssetImage("icon/user.png"),
                  radius: 35,
                  backgroundColor: Colors.white,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  secao() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: textDesignadoOuNao),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: Icon(Icons.location_on),
                        title: Text(widget.titulo),
                        subtitle: Text(widget.bairro),
                      ),
                      Divider(),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: Icon(Icons.person),
                        title: Text(widget.nome),
                        subtitle: Text(widget.cpf),
                      ),
                      Divider(),
                      ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          leading: Icon(Icons.timer),
                          title: Text("Data da Designação: " + dataInicio)),
                      Divider(),
                      RaisedButton(
                        color: verifica == false ? Colors.red : Colors.yellow,
                        onPressed: () async {
                          try {
                            final result =
                                await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              if (verifica == true) {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true, onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  print('confirm $date');
                                  try {
                                    atualiza(
                                        idMapaOnline,
                                        formatarData.format(date) +
                                            " - " +
                                            formatarHora.format(date));
                                    apagarDesignacaoEmEscolha(widget.titulo);
                                    atualizaMapaStatus(widget.titulo,
                                        "Disponível", formatarData.format(date));
                                    // apagar(idMapaOnline);
                                    Navigator.of(context).pop();
                                  } catch (e) {}
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.pt);
                              } else {
                                Toast.show("Designado!", context);
                                addDesignacao(widget.titulo);
                                addHistorico("Novo Mapa Designado", widget.cpf,
                                    widget.nome, widget.titulo);
                                atualizaMapaStatus(
                                    widget.titulo, "Indisponível", "-");
                                Navigator.of(context).pop();
                              }
                            }
                          } on SocketException catch (_) {
                            Toast.show("Você não está conectado na internet!",
                                context);
                          }
                        },
                        animationDuration: Duration(seconds: 3),
                        child: Text(
                            verifica == false
                                ? "Designar"
                                : "Concluir designação",
                            style: TextStyle(
                              color: Colors.black,
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  apagarDesignacaoEmEscolha(String id) async {
    final doc =
        await Firestore.instance.collection("designacoes").document(id).get();
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  atualizaMapaStatus(String id, String status, String atualizacao) async {
    final doc = await Firestore.instance.collection("mapas").document(id).get();
    if (doc.exists) {
      doc.reference.updateData({"status": status, "atualizacao": atualizacao});
    }
  }

  atualiza(String id, String data) async {
    final doc =
        await Firestore.instance.collection("designacoes").document(id).get();
    if (doc.exists) {
      doc.reference.updateData({"dataConclusao": data, "status": "Concluído"});
    }
  }

  verificaDesignacaoOnline(String titulo) async {
    if (mapRecebeDadosOnline.isEmpty) {
    } else {
      mapRecebeDadosOnline.remove("territorio");
      mapRecebeDadosOnline.remove("dataInicio");
    }

    QuerySnapshot snap = await Firestore.instance
        .collection("designacoes")
        .where("status", isEqualTo: "Em Andamento")
        .getDocuments();
    snap.documents.forEach((f) {
      if (f.data["territorio"] == titulo) {
        idMapaOnline = f.documentID;
        mapRecebeDadosOnline = {
          "territorio": f.data["territorio"],
          "dataInicio": f.data["dataInicio"]
        };
      }
    });
    setState(() {
      dataInicio = mapRecebeDadosOnline["dataInicio"];
      print(dataInicio);
    });
  }

  addHistorico(String tipo, String cpf, String nome, String titulo) async {
    Firestore.instance.collection("historico").add({
      "CPF": cpf,
      "historico": "$nome escolheu um mapa",
      "timestamp": DateTime.now(),
      "territorio": titulo,
      "nome": nome,
      "tipo": tipo
    });
  }

  addDesignacao(String titulo) async {
    var dateTime = new DateTime.now();
    try {
      Firestore.instance.collection("designacoes").document(titulo).setData({
        "CPF": widget.cpf,
        "nome": widget.nome,
        "timestamp": DateTime.now(),
        "territorio": widget.titulo,
        "bairro": widget.bairro,
        "imagem": widget.imagem,
        "status": "Em Andamento",
        "dataInicio": formatarData.format(dateTime) +
            " - " +
            formatarHora.format(dateTime),
        "dataConclusao": ""
      });
      setState(() {
        verifica = true;
      });
    } catch (e) {}
  }
}
