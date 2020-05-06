import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:territorios/pages/home.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
class Anotacao extends StatefulWidget {
  final String titulo;
  final String bairro;
  final String mapa;
  Anotacao({this.titulo, this.bairro, this.mapa});

  @override
  _AnotacaoState createState() => _AnotacaoState();
}

class _AnotacaoState extends State<Anotacao> {
  SharedPreferences prefs;
  TextEditingController controle = TextEditingController();
  @override
  void initState() {
    mostraNome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mensagem = Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Padding(
                  child: TextFormField(
                    controller: controle,
                    maxLines: 1,
                    decoration:
                        InputDecoration(labelText: "Faça anotações aqui"),
                  ),
                  padding: EdgeInsets.only(right: 8))),
          FloatingActionButton(
            backgroundColor: Color(0xff075E54),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: addAnotacao,
          )
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text("Anotações do " + widget.titulo),
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: SafeArea(
              child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[Expanded(child: mostrarAnotacoes()), mensagem],
            ),
          )),
        ));
  }

  mostrarAnotacoes() {
    timeago.setLocaleMessages('br', timeago.PtBrMessages());
    Timestamp timestamp;
    return StreamBuilder(
      stream: Firestore.instance
          .collection("anotacoes")
          .where("territorio", isEqualTo: widget.titulo).orderBy("timestamp")
          .snapshots(),
      builder: (context, snap) {
        switch (snap.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          default:
            return ListView.builder(
              itemCount: snap.data.documents.length,
              itemBuilder: (context, index) {
                timestamp = snap.data.documents[index].data["timestamp"];
                return ListTile(
                  title: Text(snap.data.documents[index].data["anotacao"]),
                  subtitle: Text(snap.data.documents[index].data["nome"]),
                  trailing:
                      Text(timeago.format(timestamp.toDate(), locale: "br")),
                );
              },
            );
        }
      },
    );
  }

  String nome = "";
  mostraNome() async {
    prefs = await SharedPreferences.getInstance();
    DocumentSnapshot doc =
        await usuariosBase.document(prefs.getString("cpf")).get();
    print(doc.data["nome"]);
    setState(() {
      nome = doc.data["nome"];
    });
  }

  addAnotacao() async {
    prefs = await SharedPreferences.getInstance();
    if (controle.text == null ||
        controle.text == "" ||
        (controle.text.trim() == "")) {
      Toast.show("Digite algo", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else {
      Firestore.instance.collection("anotacoes").add({
        "CPF": prefs.getString("cpf"),
        "anotacao": controle.text.trim(),
        "timestamp": DateTime.now(),
        "territorio": widget.titulo,
        "nome": nome
      });
      addHistorico("Anotação");
    }
  }

  addHistorico(String tipo) async {
    prefs = await SharedPreferences.getInstance();
    Firestore.instance.collection("historico").add({
      "CPF": prefs.getString("cpf"),
      "historico": controle.text.trim(),
      "timestamp": DateTime.now(),
      "territorio": widget.titulo,
      "nome": nome,
      "tipo": tipo
    });
    controle.clear();
  }
}