
import 'package:mobx/mobx.dart';

part 'verificaTerritorio.g.dart';

class VerificaTerritorio = _VerificaTerritorio with _$VerificaTerritorio;

abstract class _VerificaTerritorio with Store {
  @observable
  bool titulo = false;
  @observable
  ObservableList terrVerifica = ObservableList();
  _VerificaTerritorio() {
    autorun((_) {
      print(isValido);
    });
  }
  @action
  void addLista(List d) {
    terrVerifica.add(d);
  }

  @action
  verificaTerritorio(String territorio) {
    for (int i = 0; i < terrVerifica.length; i++) {
      if (terrVerifica[i].contains(territorio)) {
        titulo = true;
      } else {
        titulo = false;
      }
    }
  }

  @computed
  bool get isValido => titulo;
}
