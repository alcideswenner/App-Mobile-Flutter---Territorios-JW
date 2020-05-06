import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginBloc extends BlocBase {
  CollectionReference colecao = Firestore.instance.collection("usuarios");
  String status = "";

  final StreamController _streamController = StreamController();
  Sink get entrada => _streamController.sink;
  Stream get saida => _streamController.stream;

  void verificaUsuario(String usuario) async {
    if (await verifica(usuario) == true) {
      status = "Localizado";
    } else {
      status = "Não localizado";
    }
    entrada.add(status);
  }

  Future<bool> verifica(String usuario) async {
    final QuerySnapshot res =
        await colecao.where("CPF", isEqualTo: usuario).getDocuments();
    final List<DocumentSnapshot> docs = res.documents;
    if (docs.length == 0) {
      return false;
    } else {
      return true;
    }
  }


  @override
  void dispose() {
    _streamController.close();
  }
}
