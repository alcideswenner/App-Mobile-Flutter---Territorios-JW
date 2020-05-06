import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:territorios/bloc/login_bloc.dart';
import 'package:territorios/pages/dependsLogin/WaveClipper1.dart';
import 'package:territorios/pages/dependsLogin/WaveClipper3.dart';
import 'package:territorios/pages/home.dart';
import 'package:territorios/widgets/alertNet.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc bloc = LoginBloc();
  String connection = "";
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  ProgressDialog pr;
  TextEditingController usuario = TextEditingController();
  TextEditingController senha = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    carregaCircular();
    completaPreferencias();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text(
            "Mapas da Congregação Central",
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            stackHeader(),
            SizedBox(
              height: 30,
            ),
            Form(
              child: textCpf(),
            ),
            SizedBox(
              height: 20,
            ),
            textSenha(),
            SizedBox(
              height: 25,
            ),
            btnLogin(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget textCpf() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: StreamBuilder(
          stream: bloc.saida,
          builder: (context, snap) {
            return TextFormField(
                onChanged: bloc.verificaUsuario,
                maxLength: 11,
                autovalidate: true,
                validator: (val) {
                  if (val.trim().length >= 11 ||
                      val.trim().length <= 11 ||
                      val.trim().isEmpty) {
                    return bloc.status;
                  } else {
                    return null;
                  }
                },
                controller: usuario,
                toolbarOptions: ToolbarOptions(
                    copy: true, cut: false, paste: true, selectAll: true),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "CPF",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.person_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)));
          },
        ),
      ),
    );
  }

  Widget textSenha() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextFormField(
          autovalidate: true,
          validator: (val) {
            if (val.trim().length > 8 ||
                val.trim().length < 8 ||
                val.trim().isEmpty) {
              return "Digite corretamente a sua senha";
            } else {
              return null;
            }
          },
          toolbarOptions: ToolbarOptions(
              copy: true, cut: false, paste: true, selectAll: true),
          keyboardType: TextInputType.number,
          controller: senha,
          obscureText: true,
          onChanged: (String value) {},
          cursorColor: Colors.deepOrange,
          decoration: InputDecoration(
              hintText: "Senha",
              prefixIcon: Material(
                elevation: 0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        ),
      ),
    );
  }

  Widget btnLogin() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: Theme.of(context).primaryColor,),
          child: FlatButton(
            child: Text(
              "Login",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
            onPressed: () async {
              Toast.show("Aguarde!", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              if (usuario.text == "" || senha.text == "") {
                Toast.show("Preencha os campos!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              } else {
                if (connection == "Não Conectado!") {
                  alerta(context);
                } else {
                  login();
                  Toast.show(connection, context);
                }
              }
            },
          ),
        ));
  }

  Stack stackHeader() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipper3(),
          child: Container(
            child: Column(),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor,),
          ),
        ),
        ClipPath(
          clipper: WaveClipper1(),
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Icon(
                  Icons.map,
                  color: Colors.white,
                  size: 60,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Territórios",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 30),
                ),
              ],
            ),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _onBackPressed() {
    return SystemNavigator.pop() ?? false;
  }

  void _updateStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.mobile) {
      updateText("3G/4G");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      String wifiIp = await _connectivity.getWifiIP();
      updateText("Wi-Fi\n$wifiIp");
    } else {
      updateText("Não Conectado!");
    }
  }

  void updateText(String texto) {
    setState(() {
      connection = texto;
    });
  }

  salvarPreferencias(String c, String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cpf = (prefs.getString('cpf') ?? c) + "";
    String senha = (prefs.getString('senha') ?? s) + "";
    await prefs.setString('cpf', cpf);
    await prefs.setString('senha', senha);
  }

  login() async {
    print(connection);
    DocumentSnapshot dados;
    dados = await Firestore.instance
        .collection("usuarios")
        .document(usuario.text)
        .get();
    if (dados.data == null) {
      Toast.show("Esse CPF não foi encontrado!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      if (dados.data["senha"] == senha.text) {
        Toast.show("Login Aprovado!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (usuario.text != prefs.getString("cpf")) {
          prefs.clear();
        }

        salvarPreferencias(usuario.text, senha.text);

        Future.delayed(Duration(seconds: 3)).then((value) {
          pr.hide().whenComplete(() {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          });
        });
      } else {
        Toast.show("Senha Errada!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }
  }

  carregaCircular() {
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Carregando...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
  }

  completaPreferencias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usuario.text = prefs.getString('cpf');
    senha.text = prefs.getString('senha');
  }
}
