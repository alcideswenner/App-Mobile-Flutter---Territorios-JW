import 'package:flutter/material.dart';
import 'package:territorios/pages/grupos.dart';
import 'package:territorios/widgets/alertNet.dart';
import 'package:territorios/widgets/ampliarImagem.dart';

Container cardOffline(Item item, BuildContext context) {
  return Container(
    margin: EdgeInsets.all(20.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      imagemAmpliada(context, item.image, item.titulo,
                          item.bairro, item.link);
                    },
                    child: Ink(
                      child: Image.asset(
                        item.image,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  ),
                  Ink(
                    height: 200,
                    decoration: BoxDecoration(color: Colors.black12),
                  ),
                  Positioned(
                    right: 8,
                    top: 20,
                    child: IconButton(
                      icon: Icon(Icons.map),
                      onPressed: () {
                        abrirLink(item.link);
                      },
                      color: Colors.blue,
                      disabledColor: Colors.blue,
                    ),
                  ),
                  Positioned(
                      right: 10,
                      bottom: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            color: Colors.red[200],
                            child: Text(
                              "Offline",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ))
                ],
              ),
              Divider(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(
                        item.titulo,
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      subtitle: Text(
                        item.bairro,
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      trailing: Text("Atualização:-"),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      alerta(context);
                    },
                    child: Text(
                      "Indisponível",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.red,
                    disabledColor: Colors.blue,
                  ),
                  FlatButton(
                    onPressed: () {
                     alerta(context);
                    },
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.description),
                        Text("Anotações")
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
