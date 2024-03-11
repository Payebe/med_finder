import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  final LatLng _yaoundeCenter = const LatLng(3.848, 11.502);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte de Yaoundé'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _yaoundeCenter,
          zoom: 12,
        ),
        markers: {
          Marker(
            markerId: MarkerId('yaounde'),
            position: _yaoundeCenter,
            infoWindow: InfoWindow(title: 'Yaoundé'),
          ),
        },
      ),
    );
  }
}
