import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapa extends StatefulWidget {
  @override
  _GoogleMapaState createState() => _GoogleMapaState();
}

class _GoogleMapaState extends State<GoogleMapa> {
  Completer<GoogleMapController> _controller = Completer();

  var posicaoInical = CameraPosition(
    target: LatLng(-4.255905, -43.016410),
    zoom: 14.4746,
  );

  recuperaLocal() async {
    Position posicao = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(posicao.toString());
    if (mounted && posicao != null) {
      setState(() {
        posicaoInical = CameraPosition(
            target: LatLng(
              posicao.latitude,
              posicao.longitude,
            ),
            zoom: 17);
        movimentarCamera();
      });
    }
  }

  movimentarCamera() async {
    GoogleMapController controle = await _controller.future;
    controle.animateCamera(CameraUpdate.newCameraPosition(posicaoInical));
  }

  @override
  void initState() {
    super.initState();
    recuperaLocal();
    movimentarCamera();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Localizações"),
      ),
      body: GoogleMap(
        trafficEnabled: true,
        padding: EdgeInsets.only(top: 50),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapType: MapType.hybrid,
        initialCameraPosition: posicaoInical,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
