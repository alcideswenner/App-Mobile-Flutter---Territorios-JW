import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:territorios/pages/home.dart';
import 'package:timeago/timeago.dart' as timeago;

class Historico extends StatefulWidget {
  @override
  _HistoricoState createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  SharedPreferences prefs;
  iniciar() async {
    prefs = await SharedPreferences.getInstance();
  }

  String nome = "";
  String cpf = "";
  mostraNome() async {
    prefs = await SharedPreferences.getInstance();
    cpf = prefs.getString("cpf");
    DocumentSnapshot doc = await usuariosBase.document(cpf).get();
    if (mounted && doc.data["nome"] != null) {
      setState(() {
        nome = doc.data["nome"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    iniciar();
    mostraNome();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[Expanded(child: mostrarAnotacoes())],
      ),
    );
  }

  mostrarAnotacoes() {
    timeago.setLocaleMessages('br', timeago.PtBrMessages());
    Timestamp timestamp;
    return Container(
        padding: EdgeInsets.all(8),
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Text(
                      "Histórico de Atividades",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            StreamBuilder(
              stream: Firestore.instance
                  .collection("historico")
                  .orderBy("timestamp", descending: true)
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
                    return snap.data.documents.length == 0
                        ? Center(
                            child: Text("Nenhum Histórico disponível"),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 35),
                            itemCount: snap.data.documents.length,
                            itemBuilder: (context, index) {
                              timestamp =
                                  snap.data.documents[index].data["timestamp"];
                              return ListTile(
                                title: Text(
                                    snap.data.documents[index].data["tipo"]),
                                subtitle: Text(snap
                                    .data.documents[index].data["historico"]),
                                leading: Text(
                                    snap.data.documents[index].data["nome"]),
                                trailing: Text(timeago
                                    .format(timestamp.toDate(), locale: "br")),
                              );
                            },
                          );
                }
              },
            ),
          ],
        ));
  }
}
