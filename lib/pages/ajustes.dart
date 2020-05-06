import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:territorios/leitorPdf.dart';
import 'package:territorios/pages/home.dart';
import 'package:territorios/pages/login.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class Ajustes extends StatefulWidget {
  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  SharedPreferences preferencias;
  String nome = "";
  String cpf = "";

  @override
  void initState() {
    super.initState();
    iniciar();
    mostraNome();
    _initPackageInfo();
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle ?? 'Not set'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Ajustes"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: ListTile(
              title: Text(
                "Nome: " + nome,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500),
              ),
              leading: Icon(Icons.person),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: ListTile(
              title: Text(
                "CPF: " + cpf,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500),
              ),
              leading: Icon(Icons.description),
            ),
          ),
          Divider(),
          GestureDetector(
            onTap: () async {
              WcFlutterShare.share(
                  sharePopupTitle: 'Mapas',
                  subject: 'Mapas da Congregação',
                  text:
                      'Segue o link para fazer o download de todos os mapas da congregação: https://photos.app.goo.gl/qchKfa4KFBWRBAs59',
                  mimeType: 'text/plain');
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: ListTile(
                title: Text(
                  "Compartilhar Mapas",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
                leading: Icon(Icons.share),
              ),
            ),
          ),
          Divider(),
          _infoTile('Versão do APP', _packageInfo.version),
           Divider(),
          ListTile(
            leading: Icon(Icons.picture_as_pdf),
            title: Text("Programação Mensal da Reunião"),
            trailing: FlatButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LeitorPdf()));
                },
                child: Icon(
                  Icons.remove_red_eye,
                  color: Theme.of(context).primaryColor,
                )),
          ),
         
        ],
      ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: () {
          preferencias.remove("cpf");
          preferencias.remove("senha");
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => Login()));
        },
        label: Text("Sair da Conta"),
        icon: Icon(Icons.close),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  iniciar() async {
    preferencias = await SharedPreferences.getInstance();
  }

  mostraNome() async {
    preferencias = await SharedPreferences.getInstance();
    cpf = preferencias.getString("cpf");
    DocumentSnapshot doc = await usuariosBase.document(cpf).get();
    print(doc.data["nome"]);
    if (mounted && doc.data["nome"] != null) {
      setState(() {
        nome = doc.data["nome"];
      });
    }
  }
}
