import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:territorios/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ProgressDialog pr;
  TextEditingController usuario = TextEditingController();
  TextEditingController senha = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
    completaPreferencias();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Mapas da Congregação Central",
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipper3(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.indigo.shade300,
                      Colors.indigo.shade500
                    ]),
                  ),
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
                    gradient: LinearGradient(colors: [
                      Colors.indigo.shade300,
                      Colors.indigo.shade500
                    ]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                  controller: usuario,
                  onChanged: (value) {
                    if (value.length == 11) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    }
                  },
                  toolbarOptions: ToolbarOptions(
                      copy: true, cut: false, paste: true, selectAll: true),
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "CPF",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.blue,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13))),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                toolbarOptions: ToolbarOptions(
                    copy: true, cut: false, paste: true, selectAll: true),
                keyboardType: TextInputType.number,
                controller: senha,
                obscureText: true,
                onChanged: (String value) {
                  if (value.length == 8) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  }
                },
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Senha",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
                        color: Colors.blue,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  gradient: LinearGradient(
                      colors: [Colors.indigo.shade300, Colors.indigo.shade500]),
                ),
                child: FlatButton(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    DocumentSnapshot dados;
                    if (usuario.text == "" || senha.text == "") {
                      Toast.show("Preencha os campos!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    } else {
                      dados = await Firestore.instance
                          .collection("usuarios")
                          .document(usuario.text)
                          .get();
                      if (dados.data == null) {
                        Toast.show("Esse CPF não foi encontrado!", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      } else {
                        if (dados.data["senha"] == senha.text) {
                          salvarPreferencias(usuario.text, senha.text);
                          Toast.show("Login Aprovado!", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                          pr.show();
                          Future.delayed(Duration(seconds: 3)).then((value) {
                            pr.hide().whenComplete(() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => Home()));
                            });
                          });
                        } else {
                          Toast.show("Senha Errada!", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                      }
                    }
                  },
                ),
              )),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  salvarPreferencias(String c, String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cpf = (prefs.getString('cpf') ?? c) + "";
    String senha = (prefs.getString('senha') ?? s) + "";
    await prefs.setString('cpf', cpf);
    await prefs.setString('senha', senha);
  }

  completaPreferencias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usuario.text = prefs.getString('cpf');
    senha.text = prefs.getString('senha');
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
