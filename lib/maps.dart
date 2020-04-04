import 'package:flutter/material.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Escolha um mapa"),
        elevation: 2,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.filter_list),
          )
        ],
      ),
      body: Mapas(),
    );
  }
}

class Item {
  final String titulo;
  final String bairro;
  final String image;
  Item({this.titulo, this.bairro, this.image});
}

class Mapas extends StatelessWidget {
  final List<Item> data = [
    Item(titulo: "Território 01", bairro: "Centro", image: "map1.png")
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(6),
      itemCount: data.length,
      itemBuilder: (BuildContext build, int index) {
        Item item = data[index];
        return Card(
          elevation: 3,
          child: Row(
            children: <Widget>[
              Container(
                height: 125,
                width: 110,
                padding: EdgeInsets.only(
                  left: 0,top: 10,bottom: 70,right: 20
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(item.image)
                  )
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
