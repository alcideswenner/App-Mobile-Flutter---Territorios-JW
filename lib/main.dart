import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:territorios/pages/page_inicial.dart';
//import 'package:territorios/login.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.deepPurple),
        primarySwatch: Colors.deepPurple),
    debugShowCheckedModeBanner: false,
    home: PageInicial(),
    title: "Território Central",
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('pt', "BR"), // portugues
    ],
  ));
}
