// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verificaTerritorio.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$VerificaTerritorio on _VerificaTerritorio, Store {
  Computed<bool> _$isValidoComputed;

  @override
  bool get isValido =>
      (_$isValidoComputed ??= Computed<bool>(() => super.isValido)).value;

  final _$tituloAtom = Atom(name: '_VerificaTerritorio.titulo');

  @override
  bool get titulo {
    _$tituloAtom.context.enforceReadPolicy(_$tituloAtom);
    _$tituloAtom.reportObserved();
    return super.titulo;
  }

  @override
  set titulo(bool value) {
    _$tituloAtom.context.conditionallyRunInAction(() {
      super.titulo = value;
      _$tituloAtom.reportChanged();
    }, _$tituloAtom, name: '${_$tituloAtom.name}_set');
  }

  final _$terrVerificaAtom = Atom(name: '_VerificaTerritorio.terrVerifica');

  @override
  ObservableList<dynamic> get terrVerifica {
    _$terrVerificaAtom.context.enforceReadPolicy(_$terrVerificaAtom);
    _$terrVerificaAtom.reportObserved();
    return super.terrVerifica;
  }

  @override
  set terrVerifica(ObservableList<dynamic> value) {
    _$terrVerificaAtom.context.conditionallyRunInAction(() {
      super.terrVerifica = value;
      _$terrVerificaAtom.reportChanged();
    }, _$terrVerificaAtom, name: '${_$terrVerificaAtom.name}_set');
  }

  final _$_VerificaTerritorioActionController =
      ActionController(name: '_VerificaTerritorio');

  @override
  void addLista(List<dynamic> d) {
    final _$actionInfo = _$_VerificaTerritorioActionController.startAction();
    try {
      return super.addLista(d);
    } finally {
      _$_VerificaTerritorioActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic verificaTerritorio(String territorio) {
    final _$actionInfo = _$_VerificaTerritorioActionController.startAction();
    try {
      return super.verificaTerritorio(territorio);
    } finally {
      _$_VerificaTerritorioActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'titulo: ${titulo.toString()},terrVerifica: ${terrVerifica.toString()},isValido: ${isValido.toString()}';
    return '{$string}';
  }
}
