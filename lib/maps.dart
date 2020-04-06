import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

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
  final String legenda;
  Item({this.titulo, this.bairro, this.image, this.legenda});
}

class Mapas extends StatelessWidget {
  _image(BuildContext context, String image,String titulo, String bairro) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        child: Image(
                          image: AssetImage(image),
                          fit: BoxFit.contain,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.share),
                        onPressed: () {
                           _shareImageAndText(image,titulo,bairro);
                           print("aqui"+image);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ));
  }

  final List<Item> data = [
    Item(
        titulo: "Território 01",
        bairro: "Centro",
        image: "mapas/map1.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 02",
        bairro: "Centro",
        image: "mapas/map2.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 03",
        bairro: "Centro",
        image: "mapas/map3.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 04",
        bairro: "Centro",
        image: "mapas/map4.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 05",
        bairro: "Centro",
        image: "mapas/map5.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 06",
        bairro: "Bela Vista",
        image: "mapas/map6.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 07",
        bairro: "Bela Vista",
        image: "mapas/map7.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 08",
        bairro: "São Francisco",
        image: "mapas/map8.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 09",
        bairro: "Sarney",
        image: "mapas/map9.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 10",
        bairro: "Sarney",
        image: "mapas/map10.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 11",
        bairro: "Subestação",
        image: "mapas/map11.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 12",
        bairro: "Subestação",
        image: "mapas/map12.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 13",
        bairro: "Subestação",
        image: "mapas/map13.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 14",
        bairro: "Quiabos",
        image: "mapas/map14.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 15",
        bairro: "Novo Tempo",
        image: "mapas/map15.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 16",
        bairro: "Quiabos",
        image: "mapas/map16.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 17",
        bairro: "Quiabos",
        image: "mapas/map17.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 18",
        bairro: "Quiabos",
        image: "mapas/map18.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 19",
        bairro: "Mutirão",
        image: "mapas/map19.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 20",
        bairro: "Mutirão",
        image: "mapas/map20.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 21",
        bairro: "Olho D'Aguinha",
        image: "mapas/map21.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 22",
        bairro: "Olho D'Aguinha",
        image: "mapas/map22.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 23",
        bairro: "Olho D'Aguinha",
        image: "mapas/map23.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 24",
        bairro: "Anil",
        image: "mapas/map24.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 25",
        bairro: "Anil",
        image: "mapas/map25.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 26",
        bairro: "Anil",
        image: "mapas/map26.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 27",
        bairro: "Anil",
        image: "mapas/map27.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 28",
        bairro: "Anil",
        image: "mapas/map28.png",
        legenda: "Centro"),
    Item(
        titulo: "Território 29",
        bairro: "Anil",
        image: "mapas/map29.png",
        legenda: "Centro")
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: data.length,
      itemBuilder: (BuildContext build, int index) {
        Item item = data[index];
        return Card(
          elevation: 3,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {

                  _image(context, item.image,item.titulo,item.bairro);
                },
                child: Container(
                  height: 150,
                  width: 110,
                  padding:
                      EdgeInsets.only(left: 0, top: 10, bottom: 70, right: 20),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(item.image), fit: BoxFit.contain)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.titulo,
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                    ),
                    Text(
                      item.bairro,
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.add_box),
                      onPressed: (){
                       
                      })
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  void _shareImageAndText(String image,String titulo,String bairro) async {
    try {
      final ByteData bytes = await rootBundle.load(image);
      print("aquiiii "+image);
      var nomeMapa=image.split("/");

      await WcFlutterShare.share(
          sharePopupTitle: 'Mapa',
          subject: 'This is subject',
          text: 'Prezado irmão, segue os dados do território a ser trabalhado: Número do território: '+titulo+" | Bairro: "+bairro,
          fileName: nomeMapa[1],
          mimeType: 'image/png',
          bytesOfFile: bytes.buffer.asUint8List());
          print("uauu");
    } catch (e) {
      print('error: $e');
    }
  }
}
