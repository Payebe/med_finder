import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:finder_med/Pharmacy.dart';
import 'package:permission_handler/permission_handler.dart';// Ajouter cette ligne
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PharmacyDetailsPage extends StatelessWidget {
  final Pharmacy pharmacy;

  const PharmacyDetailsPage({Key? key, required this.pharmacy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pharmacy.nomPharmacie),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 202, 215, 221),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDetailCard('Nom de la pharmacie', pharmacy.nomPharmacie),
            _buildDetailCard('Type', pharmacy.type),
            _buildDetailCard('Emplacement', pharmacy.emplacement),
            _buildContactsCard('Contacts', pharmacy.contacts),
            if (pharmacy.longitude != null && pharmacy.latitude != null)
              ElevatedButton(
                onPressed: () {
                  _navigateToMap(context, pharmacy);
                },
                child: Text('Localiser'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildContactsCard(String title, List<String> contacts) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: contacts.map((contact) {
              return ElevatedButton(
                onPressed: () {
                  _callPhoneNumber(contact); // Appel de la fonction pour passer un appel
                },
                child: Text('Contacter : $contact'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _callPhoneNumber(String phoneNumber) async {
    if (await Permission.phone.request().isGranted) {
      final url = 'tel:${phoneNumber.trim()}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      // La permission n'est pas accordée
      // Vous pouvez afficher un message à l'utilisateur pour lui demander d'accorder la permission
      print('La permission de passer des appels téléphoniques est requise.');
    }
  }

  void _navigateToMap(BuildContext context, Pharmacy pharmacy) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage(pharmacy: pharmacy)),
    );
  }
}

class MapPage extends StatelessWidget {
  final Pharmacy pharmacy;

  const MapPage({Key? key, required this.pharmacy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localisation'),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(pharmacy.latitude ?? 0, pharmacy.longitude ?? 0),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('Pharmacy'),
            position: LatLng(pharmacy.latitude ?? 0, pharmacy.longitude ?? 0),
            infoWindow: InfoWindow(
              title: pharmacy.nomPharmacie,
              snippet: pharmacy.emplacement,
            ),
          ),
        },
      ),
    );
  }
}
