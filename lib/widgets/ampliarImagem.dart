import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

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
                    const SizedBox(width: 10.0),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.map),
                      onPressed: () async {
                        if(link==""){
                           
                        }else{
                          abrirLink(link);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ));
}

abrirLink(String link) async {
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Could not launch $link';
  }
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
        mimeType: 'image/webp',
        bytesOfFile: bytes.buffer.asUint8List());
    print("uauu");
    
  } catch (e) {
    print('error: $e');
  }
}

