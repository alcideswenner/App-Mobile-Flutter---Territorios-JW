import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';

class Grupos extends StatefulWidget {
  @override
  _GruposState createState() => _GruposState();
}


String valor = "Grupo Central";
String selecao;
String bairro;
 
class _GruposState extends State<Grupos> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Escolha um mapa"),
        elevation: 2,
        actions: <Widget>[
          DropdownButton<String>(
            value: valor,
            icon: Icon(Icons.calendar_today, color: Colors.white),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.white,
            ),
            onChanged: (String newValue) {
              setState(() {
                valor = newValue;
                selecao = newValue;
                if (selecao == "Grupo Central") {
                 bairro="Centro";
                }else if(selecao == "Grupo 14 de Abril"){
                 bairro="Centro";
                }else if(selecao == "Grupo C"){
                 bairro="Mutirão";
                }else if(selecao == "Grupo D"){
                 bairro="Subestação";
                }
              });
            },
            items: <String>[
              'Grupo Central',
              'Grupo 14 de Abril',
              'Grupo C',
              'Grupo D',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.filter_list),
          ),
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
  final String link;
  final List<String> semana;
  Item(
      {this.titulo,
      this.bairro,
      this.image,
      this.legenda,
      this.link,
      this.semana});
}

class Mapas extends StatefulWidget {
  @override
  _MapasState createState() => _MapasState();
}

class _MapasState extends State<Mapas> {
  imagemAmpliada(
      BuildContext context, String image, String titulo, String bairro, link) {
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
                          _compartilhaImagemTexto(image, titulo, bairro, link);
                          print("aqui" + image);
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
        legenda: "Centro",
        link: "https://goo.gl/maps/1cn2KdGDubvnss9p6",
        semana: ["Quarta-Feira", "Sábado"]),
    Item(
        titulo: "Território 02",
        bairro: "Centro",
        image: "mapas/map2.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/HyeWcpp6XNYVrKn69",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 03",
        bairro: "Centro",
        image: "mapas/map3.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/fBhijsgYWzznmruz6",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 04",
        bairro: "Centro",
        image: "mapas/map4.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/xf3HLi9LnLZ9x5Ek8",
        semana: ["Sábado", "Terça-Feira"]),
    Item(
        titulo: "Território 05",
        bairro: "Centro",
        image: "mapas/map5.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/mLS2oK2XnBJHhWTP6",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 06",
        bairro: "Bela Vista",
        image: "mapas/map6.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/wr6H9LeKPAi8YU716",
        semana: ["Quarta-Feira", "Domingo"]),
    Item(
        titulo: "Território 07",
        bairro: "Bela Vista",
        image: "mapas/map7.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/td4NLx25YjCD3kDj8",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 08",
        bairro: "São Francisco",
        image: "mapas/map8.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/bXBKcEnBtCfk7e1E8",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 09",
        bairro: "Sarney",
        image: "mapas/map9.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/ReNaGeyUWkh11AoB7",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 10",
        bairro: "Sarney",
        image: "mapas/map10.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/62xuNGeXTSEFpgbR6",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 11",
        bairro: "Subestação",
        image: "mapas/map11.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/7Ruttb5DuQuR5q1E6",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 12",
        bairro: "Subestação",
        image: "mapas/map12.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/NCruS8M9BVFCBarP7",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 13",
        bairro: "Subestação",
        image: "mapas/map13.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/b3ZdA4dtmt2WFMdNA",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 14",
        bairro: "Quiabos",
        image: "mapas/map14.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/dte6Gcq7ayhgHgSJA",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 15",
        bairro: "Novo Tempo",
        image: "mapas/map15.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/ESyLkXfSy4UaZfPC8",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 16",
        bairro: "Quiabos",
        image: "mapas/map16.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/j6r9ZDSQsfj2cU8m9",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 17",
        bairro: "Quiabos",
        image: "mapas/map17.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/XeWuACsVUjWfxVkE9",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 18",
        bairro: "Quiabos",
        image: "mapas/map18.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/f6v2CNo3nrnLhuds5",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 19",
        bairro: "Mutirão",
        image: "mapas/map19.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/Cog37jYeVrcDiPs3A",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 20",
        bairro: "Mutirão",
        image: "mapas/map20.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/GfHjoWprY6BpoXVN7",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 21",
        bairro: "Olho D'Aguinha",
        image: "mapas/map21.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/4B7t7iCqTbEykPj8A",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 22",
        bairro: "Olho D'Aguinha",
        image: "mapas/map22.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/MovyLRB4PbTViyN76",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 23",
        bairro: "Olho D'Aguinha",
        image: "mapas/map23.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/mjYTBQkhKMrs5Jm46",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 24",
        bairro: "Anil",
        image: "mapas/map24.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/f3vnbTtd31vYG5dB7",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 25",
        bairro: "Anil",
        image: "mapas/map25.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/p4MaB7Wj5ebkZJra8",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 26",
        bairro: "Anil",
        image: "mapas/map26.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/gx8ENzqfV3EmevyZ8",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 27",
        bairro: "Anil",
        image: "mapas/map27.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/8j7KAAJbFFVSUDAH9",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 28",
        bairro: "Anil",
        image: "mapas/map28.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/uSKHu2zYLB2YyDyS9",
        semana: ["Domingo", "Domingo"]),
    Item(
        titulo: "Território 29",
        bairro: "Anil",
        image: "mapas/map29.png",
        legenda: "Centro",
        link: "https://goo.gl/maps/mBB6sssEE6RFyr8X7",
        semana: ["Domingo", "Domingo"])
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        Item item = data[index];
        
        return selecao == null || selecao == ""
            ? new Card(
                elevation: 3,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        imagemAmpliada(context, item.image, item.titulo,
                            item.bairro, item.link);
                      },
                      child: Container(
                        height: 150,
                        width: 130,
                        padding: EdgeInsets.only(
                            left: 0, top: 10, bottom: 70, right: 10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(item.image),
                                fit: BoxFit.contain)),
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
                            style:
                                TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                          Text(
                            "Status: Disponível",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                          Text(
                            "Atualização: 15/01/2020",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: null,
                                child: Text(
                                  "Selecionar",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue,
                                disabledColor: Colors.blue,
                              ),
                              IconButton(
                                icon: Icon(Icons.map),
                                onPressed: () {
                                  abrirLink(item.link);
                                },
                                color: Colors.blue,
                                disabledColor: Colors.blue,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ))
            : item.bairro.contains(bairro)
                ? new Card(
                    elevation: 3,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            imagemAmpliada(context, item.image, item.titulo,
                                item.bairro, item.link);
                          },
                          child: Container(
                            height: 150,
                            width: 130,
                            padding: EdgeInsets.only(
                                left: 0, top: 10, bottom: 70, right: 10),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(item.image),
                                    fit: BoxFit.contain)),
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
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 14),
                              ),
                              Text(
                                "Status: Disponível",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 14),
                              ),
                              Text(
                                "Atualização: 15/01/2020",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 14),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: null,
                                    child: Text(
                                      "Selecionar",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.blue,
                                    disabledColor: Colors.blue,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.map),
                                    onPressed: () {
                                      abrirLink(item.link);
                                    },
                                    color: Colors.blue,
                                    disabledColor: Colors.blue,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : new Container();
      },
    );
  }

  void _compartilhaImagemTexto(
      String image, String titulo, String bairro, String link) async {
    try {
      final ByteData bytes = await rootBundle.load(image);
      print("aquiiii " + image);
      var nomeMapa = image.split("/");

      await WcFlutterShare.share(
          sharePopupTitle: 'Mapa',
          subject: 'This is subject',
          text: 'Prezado irmão, segue os dados do território a ser trabalhado: Número do território: ' +
              titulo +
              " | Bairro: " +
              bairro +
              ". Caso queira mais informações sobre o território, clique no link que redirecionará ao google maps. " +
              link,
          fileName: nomeMapa[1],
          mimeType: 'image/png',
          bytesOfFile: bytes.buffer.asUint8List());
      print("uauu");
    } catch (e) {
      print('error: $e');
    }
  }

  abrirLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }
}
