import 'package:bloc_pattern/bloc_pattern.dart';
import 'dart:async';

class ModoEscuroBloc extends BlocBase {
  bool status = false;
  final StreamController _controle = StreamController();
  Sink get entrada => _controle.sink;
  Stream get saida => _controle.stream;

  verificaModoEscuro(bool status) {
    if (status == true) {
      status = true;
      _controle.add(status);
    }
  }
}
